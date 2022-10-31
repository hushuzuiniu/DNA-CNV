#!/software/perl/bin/perl
#Function: compute the length of fastq or fasta, fa.
#usage: `perl script_name fastq/fasta/fa_file_name`, it will show the total length, also a detail file.
use strict;
use warnings;
my $infile = shift;  #give 1st default para to it, you can go on shift to get the 2st para
if ($infile=~m/gz$/)
{
    my @line=split(/.gz$/,$infile);
    system("gunzip -c $infile >$line[0]");
    $infile=$line[0];
}
open IN, "<$infile" or die $!;
open OUT, ">$infile.stat" or die $!;
our $total_len = 0;
our $seq_num = 0;
our $len;
our $Q20=0;
our $Q30=0;
our $GC=0;
if($infile=~/fastq$/ || $infile=~/fq$/)
{
    my $flag;
    while(my $line=<IN>)
    {
        if($line=~/^@/)
        {
            $flag=1;
        }
        if($flag eq "2")
        {
            my $seq=$line;
            chomp($seq);
            $seq_num+=1;
            $total_len+=length($seq);
            my $GC_seq=$seq;
            $GC_seq=~tr/A//d;
            $GC_seq=~tr/T//d;
            #print "$GC_seq\n";
            $GC+=length($GC_seq);
        }
        if($flag eq "4")
        {
            my $seq=$line;
            chomp($seq);
            my @array=split(//,$seq);
            foreach my $array(@array)
            {
                my $array_num=ord $array;
                my $Q20_num=ord '4';
                my $Q30_num=ord '>';
                if($array_num>=$Q20_num)
                {
                    $Q20++;
                }
                if($array_num>=$Q30_num)
                {
                    $Q30++;
                }
            }
        }
        $flag++;
    }
    my $Q20_percent=$Q20/$total_len*100;
    my $Q30_percent=$Q30/$total_len*100;
    my $GC_percent=$GC/$total_len*100;
    print OUT "Total Num of Reads:$seq_num\n";
    print OUT "Total Base Length:$total_len\n";
    print OUT "Q20 Base:$Q20\n";
    print OUT "Q30 Base:$Q30\n";
    print OUT "Q20%:$Q20_percent\n";
    print OUT "Q30%:$Q30_percent\n";
    print OUT "GC%:$GC_percent\n";
}
close(IN);
close(OUT);
