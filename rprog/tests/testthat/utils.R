## Returns an absolute, but portable directory path
## 'name' directory name
getDataDir <- function(name) {
  file.path(PROJHOME, "resources", name)
} 

getSourceFile <- function(...) {
  file.path(PROJHOME, "R", ...)
}