#1. packages in the data base
avpack.bioc <- available.packages(contriburl="http://www.bioconductor.org/packages/release/bioc/src/contrib/")
avpack.cran <- available.packages(contriburl="http://cran.r-project.org/src/contrib/")
avpack.bioc2 <- available.packages(contriburl="http://www.bioconductor.org/packages/release/data/annotation/src/contrib/")
avpack <- rbind(avpack.bioc,avpack.bioc2,avpack.cran)

#2. functions get the dependencies
getPackages <- function(packs){
  packages <- unlist(
    tools::package_dependencies(packs, db=avpack,
                         which=c("Depends", "Imports"), recursive=TRUE)
  )
  packages <- union(packs, packages)
  packages
}
packages <- getPackages("spliceR")

#3. check which to download
#3.1 fundamental packages
fund.pck <- c("methods","utils","stats","stats4","tools","grid","graphics","grDevices","cluster",
              "rpart","nnet","foreign","splines")

#3.2 delete the old redundant packages
exist.pck <- gsub("_.*","",dir("D:/software/R/packages/",pattern="tar.gz"))
exist.pck.vsion <- gsub(".*_","",dir("D:/software/R/packages/",pattern="tar.gz"))
exist.pck.vsion <- gsub(".tar.gz","",exist.pck.vsion)
pck.vnum <- tapply(exist.pck.vsion,exist.pck,package_version)
pck.vnum <- pck.vnum[sapply(pck.vnum,length)>1]
pck.remov <- sapply(names(pck.vnum),function(x){
  rm.pck <- vector("character")
  x1 <- paste("D:/software/R/packages/",x,"_",pck.vnum[[x]][pck.vnum[[x]] != max(pck.vnum[[x]])],".tar.gz",sep="")
  file.remove(x1)
})

exist.pck <- gsub("_.*","",dir("D:/software/R/packages/",pattern="tar.gz"))
exist.pck.vsion <- gsub(".*_","",dir("D:/software/R/packages/",pattern="tar.gz"))
exist.pck.vsion <- gsub(".tar.gz","",exist.pck.vsion)
names(exist.pck.vsion) <- exist.pck

dn.pck <- setdiff(packages,c(fund.pck,exist.pck))

#3.2 update exist packages

upd <- sapply(intersect(exist.pck,rownames(avpack)),function(x){
  a <- max(package_version(c(avpack[x,"Version"],exist.pck.vsion[x])))
  !(a==exist.pck.vsion[x])
})
dn.pck <- c(dn.pck,intersect(exist.pck,rownames(avpack))[upd])


download.packages(dn.pck, destdir="D:/software/R/packages",
                  type="source",repos="http://cran.r-project.org/",
                  contriburl="http://www.bioconductor.org/packages/release/bioc/src/contrib/")

