#!/usr/bin/perl
#
#
#
## replaces stuff in file
# case match 
# ; (* *)
#
use strict; use warnings;
use Data::Dumper 'Dumper';

my ($input_file, $replace_file) = @ARGV;

die "usage: input replace" unless $replace_file;
my %replaces ;

open (my $rfh, '<', $replace_file ) or die "Err: not file open $replace_file";
foreach (<$rfh>){
  chomp;
  my ($key, $val) = split /\s+/, $_;
  die "Err: invalid replace file" unless $key;
  die "Err: invalid replace file for key " . $key unless $val;
  $replaces{$key} = $val
}
close $rfh;

open (my $fh, '<', $input_file ) or die "Err: not file open $input_file";

my (@out, @line, @word, $terminal);
sub adder {
  my $w = join ('', @word);
  my $val = $replaces{$w};
  if(defined $val){
    push @line, $val;
  }else{
    push @line, $w
  }

  undef @word;
}
my ($instring);
foreach my $ln (<$fh>){
  chomp $ln;
  foreach my $chr (split //,$ln){
    if($terminal){
        push @word, $chr
    }elsif($instring){
      if($chr =~ /\"/){
        push @line, $chr, join('', @word), $instring;
        undef $instring; undef @word;
      }else{
        push @word, $chr
      }
    }else{
      if($chr =~ /\s|\(|\)|\-/){
        adder();
        push @line, $chr
      }elsif($chr =~ /\"/){
        adder();
        $instring = $chr;
      }else{
        push @word, $chr
      }
    }
  }
  adder();
  push @out, join('', @line);
  undef @line;
}


print ( join("\n", @out));
close $fh;


