use Math::BigInt;

use strict;
use warnings;

my @base58_alphabet= qw( 1 2 3 4 5 6 7 8 9
    A B C D E F G H   J K L M N   P Q R S T U V W X Y Z
    a b c d e f g h i j k   m n o p q r s t u v w x y z
);
 
sub encode_base58 {
    my ($num) = @_;
    $num = Math::BigInt->new($num);
 
 
    my $base58 = '';
    while ($num->is_pos) {
        my ($quotient, $remainder) = $num->bdiv(58);
        $base58 = $base58_alphabet[$remainder] . $base58;
    }
    $base58
}

my $num = $ARGV[0];

printf "%56s -> %s\n", $num , encode_base58($num);
