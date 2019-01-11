# CTAG-GATC-frequencies
Perl script to measure frequency and distribution of CTAG and GATC motifs in DNA
The script analyses nucleotide fasta formated files.  One sequence per file.  
The script works on all files that end on .fna present in the directory where the scrip is located.
(you can change the extension in line 18).

To invoke the script move to the dirctory and type "perl MultipleGenomeScan_CTAG_GATC_Table.pl

The script will generate several files per genome (or rather .fna file).
These include file that give the location of each CTAG and GATC oligo "*.CTAG_GATC_location.txt", 
a cumulative distribution for each type "*.CTAG_GATC_cummulative.txt",
the frequency of the motifs in each window "*.CTAG_GATC_window.txt", 
and a file containg the genome in a single line (i.e. with out returns and spaces).  
The tables can be loaded into excel (for further manipulation, eg, create a rolling window), 
or plotted directly using gnuplot. 
The window size can be modifies in line 109 of the script.  
