#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper 'Dumper';

my $pickfile = $ENV{HOME} . "/.pickfile";
my $histfile = $ENV{HOME} . "/.local/share/fish/fish_history";

my ($cmd) = join ' ', @ARGV;
unless($cmd){
  open(my $fh,"<",$histfile) || die "Err: cannot open history file";
  my $first;
  foreach(reverse <$fh>){
    chomp;
    my($c,$v) = split(": ",$_);
    if($c eq "- cmd"){
      if($first){
         $cmd = $v;
         last;
       }else{
         $first = 1;
       }
    }
  }
}

die "Err: pick doesn't pick pick" if $cmd eq 'pick';

my @res = qx($cmd);

my @alph = qw( a b c d e f g h i k l m n o p q r s t u v w x y);

my %store;

my $asize = @alph;

my $nsize = $asize - 1;

my @rows = (0); 

sub takenext {
  my $isset;
  my (@nrow, @auxrow);
  for (my $i = (scalar @rows ) - 1; $i >= 0; $i--){
    my $place = $rows[$i];
    unless($isset){
      if($place < $nsize){
         $rows[$i] = $place + 1;
         $isset = 1;
      } else{
         $rows[$i] = 0;
      }
     }
   }
   push @rows, 0 unless $isset;
}

my $i = 0;
my $prex = '';
foreach (@res) {
  chomp;
   unless($i < $nsize ){
     takenext;
     $prex = join '' , map { $alph[$_] } @rows;
     $i = 0;
   }
   my $char = $alph[$i];
   my $string = $prex . $char;
   $store{$string} = $_;

   print "$string: $_ | ";

   $i++;
}

print "\n";
print "Choose\n";
my $answ = <STDIN>;
chomp $answ;

my $res = $store{$answ};

die "Err: could not find $answ" unless $res;

if ( -d $res ) {
   open(my $of, '>', $pickfile) || die "Err: no out to pickfile";
   print $of $res;
}else{
   my ($ext) = $res =~ /\.([^.]+)$/;
   if( $ext eq "html"){
     system "/opt/local/bin/elinks -remote '$res'";
     exec "/usr/bin/osascript -e 'tell application \"Terminal\" to activate'" ; 
   }else{
      exec "/bin/sh \$HOME/tools/utils/fileopen.sh '$res'";
   }
}

