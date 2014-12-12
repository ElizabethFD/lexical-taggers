use Getopt::Std;
use utf8;
binmode(STDOUT, ":utf8");
binmode(STDIN, ":utf8");
use Encode;

my $usage;
{
$usage = <<"_USAGE_";
_enrich.pl version 1.0

This script enriches lines based on the first tab-delimited column of that line with values from a lexicon file in a new column of the output file.
Optional arguments are currently only outputting the help message.

Usage:  _enrich.pl [optional args] -l <LEXICON> <IN_FILE>

Options and arguments:

-h              print this [h]elp message and quit
-l              [l]exicon file (required)

<IN_FILE>    A text file one category per line, only text up to the first tab is used for lexicon lookup

Copyright 2014, Amir Zeldes

This program is free software. You may copy or redistribute it under
the same terms as Perl itself.
_USAGE_
}


### OPTIONS BEGIN ###
%opts = ();
getopts('hl:',\%opts) or die $usage;

#help
if ($opts{h} || (@ARGV == 0)) {
    print $usage;
    exit;
}
if (!($lexicon = $opts{l})) 
    {$lexicon = "lexicon.txt";}

### OPTIONS END ###


	open(FLH,"$lexicon");
	@array = <FLH>;
	close(FLH);



        foreach $ar (@array)
        {
		
		$ar = decode_utf8( $ar );

                if ($ar =~ /^(.+)\t(.+)\n/)
                {
					$entry = decode_utf8($1);
					$trans = $2;
					$lex{decode_utf8($entry)} .= $trans;
					$trans =~ s/^[ \t]+//g;
					$trans =~ s/[ \t]+$//g;
				}
					
		}

		
while($ar = <>)	
{
		$ar = decode_utf8( $ar );
		$ar =~ s/\n//g;
		        if ($ar =~ /^([^\t]+)/)
                {

				if (exists $lex{$1}) {$mykey=$1;}
					elsif (exists $lex{"*" .  substr(decode_utf8($1), -4)})  {$mykey="*" .  substr(decode_utf8($1), -4);}
					elsif (exists $lex{"*" .  substr(decode_utf8($1), -3)}) {$mykey="*" .  substr(decode_utf8($1), -3);}
					elsif (exists $lex{substr(decode_utf8($1), 0,5) . "*"}) {$mykey=substr(decode_utf8($1), 0,5) . "*";}
					elsif (exists $lex{substr(decode_utf8($1), 0,4) . "*"}) {$mykey=substr(decode_utf8($1), 0,4) . "*";}
					elsif (exists $lex{substr(decode_utf8($1), 0,3) . "*"}) {$mykey=substr(decode_utf8($1), 0,3) . "*";}
					elsif (exists $lex{substr(decode_utf8($1), 0,2) . "*"}) {$mykey=substr(decode_utf8($1), 0,2) . "*";} 
					else {$mykey='';}
					if ($mykey ne ''){
					{print $ar . "\t" .  $lex{$mykey} . "\n";}
					}
					else
					{print $ar ."\n";}
				}
				else
				{
					print $ar."\n";
				}
	}
	
