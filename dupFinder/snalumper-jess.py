## PIPELINE FOR CNV CALLING USING
#### speedseq
#### lumpy
## Adapted from cambodiaWGS project
## Chrisitan P
## 23 April 2018

workdir: '/proj/ideel/linjtlab/users/ChristianP/tripleMuts/dupFinder/'
REF = '/proj/ideel/resources/genomes/Pfalciparum/genomes/Pf3d7.fasta'
readWD = '/proj/ideel/linjtlab/users/ChristianP/tripleMuts/dupFinder/'
SAMPLES, = glob_wildcards('/proj/ideel/linjtlab/users/ChristianP/tripleMuts/dupFinder/symlinks/{sample}_R1.PAIREDtrimmomatictrimmed.fastq.gz')
lumpyscripts='/proj/ideel/linjtlab/users/ChristianP/tripleMuts/lumpy/lumpy-sv/scripts'

####### Target #######
rule all:
	input: expand('aln/{sample}.bam', sample = SAMPLES)
	#input: expand('aln/{sample}.libstats', sample = SAMPLES)
	#input: expand('sv/{sample}.vcf', sample = SAMPLES)
	#input: expand('sv/{sample}.gt.vcf', sample = SAMPLES)

rule svtyper:
	input: bam = 'aln/{sample}.sorted.bam', splitters = 'aln/{sample}.splitters.bam', index = 'aln/{sample}.splitters.bam.bai', vcf = 'sv/{sample}.vcf'
	output: 'sv/{sample}.gt.vcf'
	shell: 'eval `/nas02/apps/Modules/$MODULE_VERSION/bin/modulecmd bash remove python`; \
			eval `/nas02/apps/Modules/$MODULE_VERSION/bin/modulecmd bash load python/2.7.6`; \
			svtyper -B {input.bam} -S {input.splitters} -i {input.vcf} -M > {output}'

rule index_splitters:
	input: 'aln/{sample}.splitters.bam'
	output: 'aln/{sample}.splitters.bam.bai'
	shell: 'samtools index {input}'

rule run_lumpy:
	input: libstats = 'aln/{sample}.libstats', discordants = 'aln/{sample}.discordants.bam', histo = 'aln/{sample}.histo', splitters = 'aln/{sample}.splitters.bam'
	output: 'sv/{sample}.vcf'
	shell:"mean=`cat {input.libstats} | cut -f1 | sed 's/[a-z].*://'`; \
		sd=`cat {input.libstats} | cut -f2 | sed 's/[a-z].*://'`; \
		echo $samp; echo $mean; echo $sd; \
		lumpy -mw 4 -tt 0 \
		-pe id:{wildcards.sample},bam_file:{input.discordants},histo_file:{input.histo},mean:$mean,stdev:$sd,read_length:101,min_non_overlap:101,discordant_z:5,back_distance:10,weight:1,min_mapping_threshold:20 \
		-sr id:{wildcards.sample},bam_file:{input.splitters},back_distance:10,weight:1,min_mapping_threshold:20 > {output}"

rule get_lib_dist_info:
	input: 'aln/{sample}.bam'
	output: histo = 'aln/{sample}.histo', libstats = 'aln/{sample}.libstats'
	shell: 'samtools view {input} | tail -n+100000 \
		| {lumpyscripts}/pairend_distro.py \
		-r 151 -X 4 -N 10000 -o {output.histo} > {output.libstats}'

rule fastq_to_bam:
	input: 'symlinks/{sample}_R1.PAIREDtrimmomatictrimmed.fastq.gz', 'symlinks/{sample}_R2.PAIREDtrimmomatictrimmed.fastq.gz'
	output: 'aln/{sample}.bam'
	params: 'aln/{sample}'
	shell: 'speedseq align -R "@RG\tID:id\tSM:sample\tLB:lib" -o {params} \
		{REF} {readWD}{input[0]} {readWD}{input[1]}'
