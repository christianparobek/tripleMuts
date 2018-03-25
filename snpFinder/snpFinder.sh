## This script will do a few things:
## 1. annotate VCF
## 2. return mutations in genes of interest

## Started 15 Mar 2018
## Christian P

######################################
######### ANNOTATING THE VCF #########
######################################

## Molly is using: '/proj/ideel/resources/genomes/Pfalciparum/genomes/Pf3d7.fasta'
## Believe this is the Sanger Pf3d7 genome
## Made snpEff database for this, and stored in tripleMuts/snpEff
## Please see tripleMuts wiki on GitHub
## snpEff is now a module on Longleaf (snpeff), so using that

## Need to get a VCF to test
## Make a symlink to one of Molly's old VCFs in the VCFs folder
ln -s /proj/ideel/meshnick/users/MollyDF/projects/Rhea_Plasmepsin_Rx2/ASAP_PPQ/variants/ASAPbamlist_UG.pass.vcf

## Now can actually run snpEff
snpEff -c /proj/ideel/linjtlab/users/ChristianP/tripleMuts/snpEff/snpEffect.config -v Pf3d7 VCFs/ASAPbamlist_UG.pass.vcf > VCFs/ASAPbamlist_UG.ann.vcf


