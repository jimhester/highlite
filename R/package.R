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

# Format the choices for display in Rd
choices_rd <- function(x) {
  paste0(collapse = ", ", paste0("\\sQuote{", x, "}"))
}

#' Highlight a character vector
#'
#' This function uses Andre Simon's
#' \href{http://andre-simon.de/doku/highlight/en/highlight.php}{highlight}
#' package to highlight code in
#' \Sexpr[stage=render]{length(highlite:::choices(highlite:::package_file("langDefs")))} programming
#' languages, markup languages and configuration files. It Can output to a variety
#' of formats including \sQuote{HTML}, \sQuote{ANSI escape codes},
#' \sQuote{TeX}, \sQuote{LaTeX} and \sQuote{SVG}.
#' @param code \code{[character()]}\cr The code to highlight. Multiple lines will be joined by newlines.
#' @param language \code{[character(1)]} default: \sQuote{r}\cr The language,
#' one of \Sexpr[stage=render, results=rd]{highlite:::choices_rd(highlite:::choices(highlite:::package_file("langDefs")))} with
#' the default \code{language_path}.
#' @param output \code{[character(1)]} default: \sQuote{ESC_ANSI}\cr The output type, one of
#' \Sexpr[stage=render, results=rd]{highlite:::choices_rd(names(highlite:::output_types()))}.
#' @param theme \code{[character(1)]} default: \sQuote{solarized-light}\cr The theme, one of
#' \Sexpr[stage=render, results=rd]{highlite:::choices_rd(highlite:::choices(highlite:::package_file("themes")))} with the default
#' \code{theme_path}.
#' @param theme_path \code{[character(1)]}\cr The directory containing \href{http://andre-simon.de/doku/highlight/en/highlight.php}{highlight} themes.
#' @param language_path \code{[character(1)]}\cr The directory containing \href{http://andre-simon.de/doku/highlight/en/highlight.php}{highlight} language definitions.
#' @export
highlight_string <- function(code, language = "r", output = "ESC_ANSI", theme = "solarized-light", theme_path = package_file("themes"), language_path = package_file("langDefs")) {
  output_types <- output_types()
  language <- match.arg(language, choices(language_path))
  output <- match.arg(output, names(output_types))
  theme <- match.arg(theme, choices(theme_path))
  highlight_(paste(code, collapse = "\n"), language = language, output = output_types[output], theme = theme, theme_path = theme_path, language_path = language_path)
}
