# Makes a vector of paths to all .ab1 files in the sub-directories
dirs <- list.files(pattern = ".ab1$", recursive = TRUE)
dir.create("./Results")
wd_dirs <- list.dirs(recursive = FALSE)
orig_dir <- getwd()

# Creates 13 directories in Results named as the 13 first (alphabetical) directories in working directory.
for (i in 1:13) {
  dirname <- strsplit(wd_dirs[i], "/")[[1]][2]
  dir.create(paste0("./Results/", dirname)) 
}

x <- 1
o <- 0
for (a in 1:51){
  system(paste("./tracy assemble", dirs[x], dirs[x+1], dirs[x+2], dirs[x+3]))
  system("gzip -d al.fa.gz")
  filename <- paste0(strsplit(dirs[x], "/")[[1]][1], "_", strsplit(dirs[x], "/")[[1]][2])
  system(paste0("cat al.fa | awk -F\\| '{print $2}' | tr -d '\n' | sed '1i>", filename, "'",  ">", filename, ".fasta"))
  file.copy(paste0(filename, ".fasta"), paste0("./Results/", strsplit(dirs[x], "/")[[1]][1], "/"))
  system("rm *.fa *.fasta")
  o <- o+1
  if (o == 5){
    system(paste0("(cd ./Results/", strsplit(dirs[x], "/")[[1]][1], "; ", "for x in *.fasta; do cat $x; echo; done > combined.fa)"))
    system(paste0("(cd ./Results/", strsplit(dirs[x], "/")[[1]][1], "; ", "mafft --adjustdirection combined.fa > aligned_contigs.fa)"))
    o <- 0
    }
  x <- x+4
}


################################################################################################
## NOTES
################################################################################################
# Converts tracy assembly to fasta, prepends ">contig_wt"
# system("cat al.fa | awk -F\| '{print $2}' | tr -d '\n' | sed '1i>contig_wt' > contig.fasta")
# system(paste("dmtxwrite", x, "-o image.png"))
## Combines multiple fasta files from above and adds missing newlines.
# for x in *.fasta; do cat $x; echo \n; done > combined.fa
# system("mafft --adjustdirection input > output")
#system("echo pdf | prettyplot filename.aln -ratio=0.59 -docolour")