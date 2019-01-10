#!/usr/bin/perl -w

# the script reads in a single sequence as a fasta file.  If a genome contains several contigs, these need to be stored in different files!

#initialize genome name and base_hash
$my_genome = "";
%oligo_hash=(); 
@genome=();
$CTAG_location =0;
$CTAG_cum=0;
$CTAG_window=0;
$GATC_location =0;
$GATC_cum=0;
$GATC_window=0;

open (OUT5, ">mytable.csv" ); # the table contains the cumulative motif frequencies
#assign genome name to $my_genome
while(defined($my_genome=glob("*.fna")))
	{
	%oligo_hash=(); 
	@genome=();
	$CTAG_location =0;
	$CTAG_cum=0;
	$CTAG_window=0;
	$GATC_location =0;
	$GATC_cum=0;
	$GATC_window=0;

	chomp ($my_genome);
	print "\n\n$my_genome is the file name of the genome to be analyzed \n"; 

	# open my genome for input 
	open (IN, "< $my_genome") or die "cannot open $my_genome:$!";

	# several tab delimited files are created per genome 
	$out1=$my_genome.".CTAG_GATC_location.txt";
	$out2=$my_genome.".CTAG_GATC_cummulative.txt";
	$out3=$my_genome.".CTAG_GATC_window.txt";
	$out4=$my_genome.".genome.1line";


	open (OUT1, ">$out1" ) or die "cannot open CTAG_location" ;
	open (OUT2, ">$out2" ) or die "cannot open CTAG_cummulative" ;
	open (OUT3, ">$out3" ) or die "cannot open CTAG_window" ;
	open (OUT4, ">$out4" ) or die "cannot open genome.1line" ;
	print OUT2 "NucNum\tCTAG\tGTAC\n";
	$header = <IN>;
	#reads first line of file, next command test for fasta commentline

	if ($header =~m/^>/) {print "the analyzed genome has the following comment line:\n$header\n";
						};

	if (!($header =~m/^>/)) {print "this is not in FASTA format \n\n"; 
				exit;}
	###			exit - could have died instead; 
	print OUT3 "$header"; 

	### Read genome into array @genome
	$number=0;

	while (defined ($line=<IN>)){
	if ($line =~m/^>/) {print "the analyzed genome has a second comment line:\n$header\n";}
	else {
	#initialise @bases within loop
		
			@bases=();
			chomp($line);
	
			@bases=split(//,$line);

			foreach (@bases) { 
		   		$number += 1; 
		  	 	$genome[$number]=$_;
		}           
		}
	}

	close(IN);

	print "Total number of nucleotides:\t $number \n";
	print OUT3 "nucnumber: $number \n";
	for ($i = 1 ; $i<=$number ;$i++) {
		#print "$genome[$i]";
		print OUT4 "$genome[$i]";
		}   
  
	##calculate and print deltas

	#count how often oligos occur along a sequence

	for ($i = 1 ; $i<=($number-3) ;$i++) {
	$string = $genome[$i].$genome[$i+1].$genome[$i+2].$genome[$i+3];

	if ($string eq "CTAG") {
	print OUT1 "$i\n";
	# print "$i\n";
	$CTAG_cum += 1;
	$CTAG_window += 1;						
							}
	if ($string eq "GATC") {
	$GATC_cum += 1;
	$GATC_window += 1;
	print OUT1 "$i\n";
	#print "$i\t";
						
							}						
						
# you can change the window size in the following line.  Replace the 1000 with the desired window size 
	 if ($i%1000==0) {
	  print OUT2 "$i\t$CTAG_cum\t$GATC_cum\n";
	  print OUT3 "$i\t$CTAG_window\t$GATC_window\n";
	
		$GATC_window=0;
		$CTAG_window=0;
	   }
	   
	   }

	$freqGATC=1000*$GATC_cum/$i;
	$freqCTAG=1000*$CTAG_cum/$i;
	$ratio=$GATC_cum/$CTAG_cum;

	print "\nCTAG:\t$CTAG_cum\tGATC:\t$GATC_cum\ttotalnucs:\t$i\n";
	print "CTAGfreq/kb=$freqCTAG\nGATCfreq/kb=$freqGATC\n\n";
	print "GATC/CTAG ration=\t$ratio\n";
	print OUT5 "$header\t$CTAG_cum\t$GATC_cum\t$freqCTAG\t$freqGATC\t$ratio\n";
	close (OUT1);
	close (OUT2);
	close (OUT3);
	close (OUT4);
	close (IN);}
exit;


