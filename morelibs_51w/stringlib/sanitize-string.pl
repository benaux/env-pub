$str=join "-", map { s/[^a-zA-Z0-9]+/_/g; lc $_ ; } @ARGV ; 
print $str ;
