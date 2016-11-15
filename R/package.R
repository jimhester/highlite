#' @useDynLib highlite
#' @importFrom Rcpp sourceCpp
NULL

package_file <- function(path) {
  system.file(package = "highlite", path, mustWork = TRUE)
}

remove_extension <- function(path) {
  sub("[.][^.]*$", "", path)
}

choices <- function(path, default) {
  remove_extension(dir(path))
}

#' @export
highlight_string <- function(code, language = "r", output = "ESC_ANSI", theme = "solarized-light", theme_path = package_file("themes"), language_path = package_file("langDefs")) {
  output_types <- output_types()
  language <- match.arg(language, choices(language_path))
  output <- match.arg(output, names(output_types))
  theme <- match.arg(theme, choices(theme_path))
  highlight_(paste(code, collapse = "\n"), language = language, output = output_types[output], theme = theme, theme_path = theme_path, language_path = language_path)
}
