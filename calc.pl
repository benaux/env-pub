
my $num = 33556654;

my @alph = qw( a b c d e f g h i k l m n o p r s t u v x );
my $size = @alph;


my @rows; 

my $calc; $calc = sub {
  my ($inp) = @_;
  my $res = $inp / $size;
  if ($res > $size){
    calc($res);
  }else{
    return $res;
  }

};


