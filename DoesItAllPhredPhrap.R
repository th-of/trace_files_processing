library(stringr) # Unused
library(microseq) # readFasta, writeFasta

## Makes a list of all directories with *.ab1 files
dirs <- list.files(pattern = ".ab1$", recursive = TRUE)
dir.create("./Results")
wd_dirs <- list.dirs(recursive = FALSE)
orig_dir <- getwd()
subdirs <- c()
for (y in 1:length(dirs)){
  subdirs[y] <- paste0(strsplit(dirs, "/")[[y]][1], "/", strsplit(dirs, "/")[[y]][2])
}
subdirs <- unique(subdirs)

## Creates results directories
for (i in 1:13) {
  dirname <- strsplit(wd_dirs[i], "/")[[1]][2]
  dir.create(paste0("./Results/", dirname)) 
}

## Basecalls with phred, assembles with phrap, copies results into results directory (result = largest contig)
for (y in subdirs){
  system(sprintf("phred -id %s -sa seqs.fasta -qa seqs_fasta.qual", y))
  system("phrap seqs.fasta > phrap.out")
  contigs <- readFasta("seqs.fasta.contigs")
  writeFasta(contigs[which.max(nchar(contigs$Sequence)),], "newfasta.fasta", width = 80)
  system(paste0("cp newfasta.fasta Results/", strsplit(y, "/")[[1]][1], "/", strsplit(y, "/")[[1]][1], "_", strsplit(y, "/")[[1]][2], ".fasta"))
}

