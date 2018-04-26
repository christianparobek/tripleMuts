readWD=/proj/ideel/meshnick/users/MollyDF/projects/Rhea_Plasmepsin_Rx2/ASAP_PPQ2/symlinks/
speedseq=/proj/ideel/linjtlab/users/ChristianP/tripleMuts/speedseq/bin/speedseq
ref=/proj/ideel/resources/genomes/Pfalciparum/genomes/Pf3d7.fasta
scripts=/proj/ideel/linjtlab/users/ChristianP/tripleMuts/lumpy/lumpy-sv/scripts
lumpy=/proj/ideel/linjtlab/users/ChristianP/tripleMuts/lumpy/lumpy-sv/bin/lumpy


#$speedseq align -R "@RG\tID:id\tSM:sample\tLB:lib" -o "aln4/$name" \
#    $ref \
#    $readWD/$name\_R1.PAIREDtrimmomatictrimmed.fastq.gz \
#    $readWD/$name\_R2.PAIREDtrimmomatictrimmed.fastq.gz


## Will I need to play with GB or thread limits??



## This will return the filenames 
for name in $(ls /proj/ideel/meshnick/users/MollyDF/projects/Rhea_Plasmepsin_Rx2/ASAP_PPQ2/symlinks | grep R1 | grep PAIRED | grep -v UN | sed 's/_R1.*//' | head -10)
do

	sbatch -t 99:59:59 --mem 30G --wrap "$speedseq align \
		-R '@RG\tID:id\tSM:sample\tLB:lib' \
		-o 'aln30g/$name' \
	    	$ref \
	    	$readWD/$name\_R1.PAIREDtrimmomatictrimmed.fastq.gz \
	    	$readWD/$name\_R2.PAIREDtrimmomatictrimmed.fastq.gz"

	echo "sent off job $name"

done


### Run the LUMPY parts
#for name in $(ls /proj/ideel/meshnick/users/MollyDF/projects/Rhea_Plasmepsin_Rx2/ASAP_PPQ2/symlinks | grep R1 | grep PAIRED | grep -v UN | sed 's/_R1.*//' | head -3)
#do

##	samtools view aln/$name.bam \
##	    | tail -n+100000 \
##	    | $scripts/pairend_distro.py \
##	    -r 150 \
##	    -X 4 \
##	    -N 10000 \
##	    -o aln/$name.histo > aln/$name.libstats



#	mean=`cat aln/$name.libstats | cut -f1 | sed 's/[a-z].*://'`
#	sd=`cat aln/$name.libstats | cut -f2 | sed 's/[a-z].*://'`
#	echo $name
#	echo $mean
#	echo $sd
#	
#	$lumpy -mw 4 -tt 0 \
#		-pe id:$name,bam_file:aln/$name.discordants.bam,histo_file:aln/$name.histo,mean:$mean,stdev:$sd,read_length:151,min_non_overlap:151,discordant_z:5,back_distance:10,weight:1,min_mapping_threshold:20 \
#		-sr id:$name,bam_file:aln/$name.splitters.bam,back_distance:10,weight:1,min_mapping_threshold:20 > sv/$name.vcf

#done
