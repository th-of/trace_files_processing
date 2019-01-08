# Align ORFs
library(microseq)
library(stringr)

fils <- list.files(pattern = ".fasta$", recursive = TRUE)

for (i in fils){
  system(sprintf("getorf -table 11 -find 3 -minsize 200 -maxsize 1500 -sequence %s -outseq orfs.fasta", i))
  orfs <- readFasta("orfs.fasta")
  writeFasta(orfs[which.max(nchar(orfs$Sequence)),], "longest_orf.fasta", width = 80)
  lorf <- readFasta("longest_orf.fasta")
  if (str_detect(lorf$Header, "REVERSE") == TRUE){
    lorf$Sequence[1] <- reverseComplement(lorf$Sequence[1])
    lorf$Header[1] <- str_replace(lorf$Header[1], "REVERSE", "FORWARD")
    writeFasta(lorf, "longest_orf.fasta")
    file.rename("longest_orf.fasta", paste(strsplit(i, "/")[[1]][3]))
  }
  file.remove("orfs.fasta")
}


