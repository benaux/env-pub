#!/usr/bin/perl
#
# usage:  perl twikpw profile bkb 1
#
# browse profiles: perl twikpw 
# browse logins : perl twikpw myprofile <regex>
# browse logins : perl twikpw myprofile <regex>
# get specific login: perl twikpw myprole <regex> 2

use strict;
use warnings;
use Data::Dumper;
my $DEFAULT_PROFILE_TOOL = 'pwh'; #pwdhash

our $PASSX = qx(which pass);
chomp $PASSX;

our $PWSTORE = "$ENV{HOME}/.password-store";

our $TWIKCONF = $ENV{HOME} . "/.twik.conf";


our $Rx_profile = qr(^\[(.*)\]\s*$);

#[bkb_H3b0]
#private_key = 62S39Y2H-AMPH-YT11-HMLR-8C5I46IGEF1X
#chars = 12
#password_type = 1
#resilio = bkb-gremlins_password_type = 1
#password_type = 1
#resilio = bkb-gremlins_password_type = 1
our $Rx_login = qr[^(.*)_chars = \d+$];

sub parse_twikconf {
   my ($fh) = @_;
  
   my (%login_index, @profile_list, $profile);
   while(<$fh>){
      chomp;
      if(/$Rx_profile/){
        $profile = $1;
        $login_index{$profile} = [];
        push @profile_list, $profile;
      }elsif(/$Rx_login/){
        my $login = $1;
        if($profile){
          push @{ $login_index{$profile}}, $login;
        }
      }
   }

   return (\%login_index, \@profile_list);
}



sub get_twikpw {
  my ($profile) = @_;

  #log
   print("$PASSX twik/$profile\n");

   my ($twikpw) = qx($PASSX twik/$profile);
   chomp $twikpw if $twikpw;
   return $twikpw;
}

sub get_password {
   my ($login, $profile, $printpw) = @_;

      my $twikpw;
      if($PASSX){
         if (-f $PASSX ){ 
            $twikpw = get_twikpw($profile);
         }
      }else{
        print("Warn: now pass in $PASSX\n")
      }

      print "gen: twik -p '" . $profile . "' '" . $login . "'\n" unless $printpw;
      my $pw;
      if($twikpw){
        #print qq(/usr/local/bin/twik -p "$profile" -m "$twikpw" "$login"); 
        #  print "\n";
         ($pw) = qx(/usr/local/bin/twik -p "$profile" -m "$twikpw" "$login") or
            die "Err: could not run twik: $!"; 
      }else{
         ($pw) = qx(/usr/local/bin/twik -p "$profile" "$login") or
            die "Err: could not run twik: $!" ;
      }
      return $pw;

}

sub copypw {
   my ($cmd, $pw) =  @_;
   my $r = open my $exe, $cmd or die "Couldn't run `$cmd`: $!\n";

   print "copied into clipboard ...\n";;;

   print $exe  $pw;
   close $exe or die "Error closing `$cmd`: $!";
}
sub password_to_clipboard {
   my ($pw, $printpw) = @_;

   my ($os) = qx(uname);
   chomp $os;
   if(lc($os) eq 'linux'){
     if(qx(which xlip)){
      my $cmd = '| DISPLAY=:0 xclip -sel clip ';
      copypw($cmd, $pw);
     }else{
       print $pw
     }
   }elsif(lc($os) eq 'darwin'){
      my $cmd = '|pbcopy';
      copypw($cmd, $pw);
   }else{
      die "Err: clipboard not implemented for $os";
   }
}


sub result_pw {
   my ($profile, $login, $printpw) = @_;

   my $pw = get_password ($login, $profile, $printpw);

      if($printpw){
         print $pw;
      }
      password_to_clipboard ($pw, $printpw);
}



sub neardown_logn {
  my ($profile_list, $login_index, $login_token, $profile_token) = @_ ;
  my @logins;
  my $i = 0;
  if($profile_token){
    foreach my $profile (@$profile_list){
      if($profile =~ /$profile_token/){
        my $ii= 0;
        foreach (@{ $login_index->{$profile} } ){
          if($_ =~ /$login_token/){
            push @logins, [ $i, $profile, $ii, $_ ];
          }
          $ii++;
        }
      }
      $i++;
    }
  }else{
    foreach my $profile (@$profile_list){
      my $ii= 0;
      foreach (@{ $login_index->{$profile} } ){
        if($_ =~ /$login_token/){
          push @logins, [ $i, $profile, $ii, $_ ];
        }
        $ii++;
      }
      $i++;
    }
  }
  return @logins;
}

sub get_login {
   my ($profile_list, $login_index, $profile_id, $login_id) = @_;

   my ($prfl) =  $profile_list->[$profile_id];
   die "Err: cannot find profile for $1" unless $prfl;
   my $logins = $login_index->{$prfl};
   my $log = $logins->[$login_id];
   return ($prfl, $log);
}

sub run {
  my ($login_input, $profile_input, $print_pw) = @_;

  if($profile_input){
    unless($profile_input =~ /[\w_]*\.\w*/){
      $profile_input = $profile_input . '.' . $DEFAULT_PROFILE_TOOL;
    }
  }
  die "Err: no twik.conf" unless ( -f $TWIKCONF ) ;
  open (my $fh, '<', $TWIKCONF) || die "Err: cannot opn TWIKCONF in $TWIKCONF";
  my ($login_index, $profile_list) = parse_twikconf($fh);

  close $fh;


  if($login_input){
    if($login_input =~ /(\d+)\.(\d+)/){ # if I call the tool with a number xx.yy (xx=profile, yy=login)
      my ($profile, $login) = get_login ($profile_list, $login_index, $1, $2);
      result_pw ($profile, $login, $print_pw);
    }else{
      my @logins = neardown_logn($profile_list, $login_index, $login_input, $profile_input);
      if(@logins == 0){
        if($profile_input){
          die "Err: invalid profile '$profile_input', cannot make new login" unless grep { $_ eq $profile_input } @$profile_list;
           print "Warn: Sorry, couldnt find any logins for $login_input, try to make a new twik pw\n";
           result_pw($profile_input, $login_input, $print_pw);
        }else{
            die "Err: Could not find any logins, please give a profile";
        }
      }elsif(@logins == 1){
        my ($i, $profile, $ii, $login ) = @{ $logins[0] };
        result_pw ($profile, $login, $print_pw);
      }else{
        foreach (@logins){
          my ($i, $profile, $ii, $login) = @{$_};
          print "$i.$ii: " . $profile . ' / ' . $login . "\n";
        }
      }
   }
 }else{
   map { print "$_" . "\n" } @$profile_list;
 }
}

run(@ARGV);
