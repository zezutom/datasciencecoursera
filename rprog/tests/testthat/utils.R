## Returns an absolute, but portable directory path
## 'name' directory name
getDataDir <- function(name) {
  file.path(PROJHOME, "data", name)
} 

getSourceFile <- function(name) {
  file.path(PROJHOME, "R", name)
}