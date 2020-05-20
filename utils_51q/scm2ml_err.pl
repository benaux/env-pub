#!/usr/bin/perl

#
### parse errors form scm2ml
#
#
use strict; use warnings;


sub parse_error {
  my ($file, $line, $range, ) = @_;
  my ($start, $end) = split /\-/, $range;

  die "Err: could not find line information " unless $line;
  die "Err: could not find line information " unless $end;

  open (my $fh, '<', $file) || die "Err: couldnt' open file $file";

  my $i = 0;
  my $final_line = 0;
  my $counting; 
  my $delta = 0;
  foreach my $ln (<$fh>){
    $i++;
      my @chars = split //, $ln;
      my $charnum = @chars;

      if($line == $i){
        if($start > $charnum){
          $delta = ($start - $charnum);
          $counting = 1;
        }else{
          $delta = $start;
        }
      }else{
        if($counting){
          my $res = ($delta - $charnum);
          if($res > 0){
            $delta = $res;
          }else{
            $final_line = $i;
            undef $counting
          }
        }
      }
    }
    if($final_line) {
    return ( $final_line,  $delta);
    }else{
    return ( $i,  $delta);
    }
}



my ($file, $errfile) = @ARGV;

die "usage: file errfile" unless $file;
die "usage: file errfile" unless $errfile;

my $line ; 
my $range;

my @errmsg;

open (my $fh, '<', $errfile) || die "Err: couldnt' open err file $errfile";
foreach (<$fh>){
  chomp;
  if (/^File \"([\w\.]+)\"\, line (\d+), characters (\d+\-\d+)\:$/){
    $line = $2;
    $range = $3; 
    my ( $final_line,  $delta) =  parse_error ($file, $line, $range);
    push @errmsg,  "File $1, line $final_line, characters $delta";
  }else{
    push @errmsg, $_;
  }
}

my $msg = join ("\n", @errmsg);
print STDERR $msg;


