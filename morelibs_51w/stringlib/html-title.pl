use strict; use warnings;




my $file = $ARGV[0];


open (my $fh, '<', $file) or die "Err: can not open file $file";


foreach(<$fh>){
  if(m{<TITLE>(.*?)</TITLE>}gism){
    print $1;
    exit;
  }
}

die "Err: could not match title";

