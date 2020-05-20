
use strict;
use warnings;

use Data::Dumper 'Dumper';

my ($cmd) = join ' ', @ARGV;
my @res = qx($cmd);

my @alph = qw( a b c d e f g h i k l m n o p q r s t u v w x y);

my %store;

my $asize = @alph;

my @rows = (0); 

my $i = 0;
my $prex = '';
foreach (@res) {
  chomp;
   if($i < $asize){
      my $a = $alph[$i];
      my $val = $prex . $a;
      print $val . ": $_ | ";
      $store{$val} = $_;
   $i++;
   }else{
     my @nwrows;
     my $new;
     while ( @rows ){
       my $v = pop @rows;
       if($v < ($asize - 1)){
         push @nwrows, ++$v
       }else{
         push @nwrows,  $v ;
         $new = 1;
       }
     }
     @rows = reverse @nwrows;
     push @rows, $new if $new;

     $prex = join '' , map { $alph[$_] } @rows;
     $i = 0;
   }
}

print "\n";
print "Choose\n";
my $answ = <STDIN>;
chomp $answ;

my $res = $store{$answ};

die "Err: could not find $answ" unless $res;

print $res;
