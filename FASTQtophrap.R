#Convert FASTQ to phrap input
library(readtext)

files <- list.files(path = "./", pattern=".ab1$")

for (i in 1:length(files)){
  system(paste0("./tracy basecall -f fastq -o", " ", strsplit(files[[i]], "[.]")[[1]][1], ".fastq", " ", files[[i]]))
  temp <- readLines(paste0("./", strsplit(files[[i]], "[.]")[[1]][1], ".fastq"), n = -1L)[4]
  temp <- strsplit(temp[[1]][1], "")
  scores <- " "
  for (a in 1:length(temp[[1]])){
    scores[a] <- 10^-((utf8ToInt(temp[[1]][a])-33)/10)
    write(scores, file = paste0(strsplit(files[[i]], "[.]")[[1]][1], ".qual"), ncolumns = length(scores))
  }
  scores <- " "
}


#a <- readLines("./69HB37_07314919_07314919.fastq", n = -1L)[4]
#a_split <- strsplit(a, "")
#
#
#scores <- " "
#for (i in 1:length(a_split[[1]])){
#  scores[i] <- 10^-((utf8ToInt(a_split[[1]][i])-33)/10)
#}
#
#write(scores, file = "test.qual", ncolumns = length(scores))
#
# Score to likelihood: 10^-((utf8ToInt(a_split[[1]][i])-33)/10)