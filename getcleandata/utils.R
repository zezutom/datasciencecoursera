## Utility methods

## Location of the current working directory as an absolute path
this.dir <- dirname(normalizePath(parent.frame(2)$ofile))

## Sets a working directory to the location of the current script
## Params:
## dir .. the root directory of the script considered the 'current' one
set_wd <- function(dir) {
  setwd(file.path(this.dir, dir))
}

## Resumes the working directory to the original location.
## This method is supposed to be called at the end of the client script
resume_wd <- function() {
  setwd(this.dir)
}

## Installs the required packages if needed and imports them
load_packages <- function(...) {
  packages <- c(...)
  lapply(packages, function(pkg) {
    if (!pkg %in% installed.packages()) 
      install.packages(pkg)
  })
  sapply(packages, require, character.only = TRUE, quietly = TRUE)
}

## Checks if there is such a file in the current directory. If the file is not found,
## it will be downloaded and saved.
## Params:
## fname .. filename 
## url .. download link
download_if_not_exists <- function(fname, url) {
  if (!file.exists(fname)) 
    download.file(url, destfile = fname, method = "curl")  
}

## Prints a message to stdout 
## Params:
## ellipsis .. an arbitrary number of parts comprising the final message
msg <- function(...) {
  print(paste(..., sep = " "))
}