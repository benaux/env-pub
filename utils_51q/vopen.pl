#!/usr/bin/env perl
use strict;
use warnings;
use File::Basename;
use Data::Dumper 'Dumper';

use Cwd qw(cwd);
my $cwd = cwd;

use IO::Prompt;


my @alph = qw(a b c d e f g h i k l m n o p q r s t u v x y);

my $alphi = scalar @alph;


my $listnodes; $listnodes = sub {
  my ($dir) = @_;
  my $i = 0;
  my $ii = 0;
  my %files;
  print "\n";
   foreach (glob("$dir/*")){
         $i++;
       if($i < $alphi){
       }else{
         $i = 0;
         $ii++
       }
     my $num = $alph[$ii] . $alph[$i];
     $files{$num} = $_;
     print( $num . ': ' . (basename($_ . "\n")));

   }
   print "\nPlease choose file/dir: \n";
   my $iikey = prompt '', -1;
   my $ikey;

   # quick FIX for 'enter' input
   my $iistr = "xx" . $iikey . "yy";

   if ($iistr eq "xxyy"){
       die "invalid input, exit"
   }elsif (defined $iikey){
     if ($iikey =~ /\s/){
       die "invalid input, exit"
     }else{
        $ikey = prompt '', -1;
     }
   }else{
       die "Exit"
   }

   my ($node) = $files{$iikey . $ikey};
   if ( -f $node) {
     system("$ENV{HOME}/tools/utils/v $node");
   }elsif ( -d $node) {
     $listnodes->($node);
   }else{
     die "invalid node"
   }

};



#die "usage: <dir>" unless $ARGV[0];
#die "usage: <dir>" unless -d $ARGV[0];
$listnodes->($cwd);

__END__

#


print "\nPressed key: $key\n";
