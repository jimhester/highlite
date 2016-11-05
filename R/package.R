#' @useDynLib highlite
#' @importFrom Rcpp sourceCpp
NULL

package_file <- function(path) {
  system.file(package = "highlite", path, mustWork = TRUE)
}

#' @export
highlight_string <- function(code, type = "r", theme = "solarized-light", theme_path = package_file("themes"), language_path = package_file("langDefs")) {
  highlight_(paste(code, collapse = "\n"), type = type, theme = theme, theme_path = theme_path, language_path = language_path)
}
