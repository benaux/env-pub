# filtering some stuff out of a StackOverflow answer
# that is comming from lynx -dump
#
BEGIN {
  $begin = 1;
  $start_line = undef;
  $start_emptyline = 0; 
  $start = undef;
  $end = undef;
}
if($start){
   if(/Your Answer/){
     undef $start; undef $begin;
   }else{
     s/\(BUTTON\)//g;
      s/\[\d+\]share\|\[\d+\]improve\sthis\s+answer//g;
      s/\[\d+\]share\|\[\d+\]improve\sthis\s+question//g;
      s/\[\d+\]active\s*\[\d*\]oldest\s\[\d*\]votes//g;
      s/\$\\begingroup\$//g;
      s/\$\\endgroup\$//g;
      s/\[\d+\]edited\s+\d+\s+hours\s+ago//g;
      s/\[\d+\]add\s+a\s+comment\s+\|//g;
      s/\d+\s+bronze\s+badges//g;
      s/\d+\s+gold\s+badges//g;
      s/\d+\s+gold\s+badge//g;
      s/\d+\s+silver\s+badges//g;
      s/answered\s+\d+\s+\w+\s+hours\s+ago//g; 
     print $_ 
   }
}else{
   if($begin){
      if($start_line){
         if(/^\s*$/){
            $start_emptyline++;
            $start = 1 if($start_emptyline == 2);
         }
      }else{
         if(/^\s*\[31\](.+)$/){
            print $1 . "\n";
            print "\n";
            $start_line = 1;
         }
      }
   }
}

__END__
[31]Queens attacking exactly one queen

   [32]Ask Question
   Asked yesterday
   Active [33]today
   Viewed 2k times
   (BUTTON)
   12
   (BUTTON) (BUTTON)
   2
   $\begingroup$



Your Answer
