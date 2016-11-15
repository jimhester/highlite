#include <Rcpp.h>
#include "codegenerator.h"
#include <boost/move/unique_ptr.hpp>

using namespace highlight;

// [[Rcpp::export]]
Rcpp::IntegerVector output_types() {
  return Rcpp::IntegerVector::create(
      Rcpp::_["ESC_ANSI"] = ESC_ANSI,
      Rcpp::_["HTML"] = HTML,
      Rcpp::_["XHTML"] = XHTML,
      Rcpp::_["TEX"] = TEX,
      Rcpp::_["LATEX"] = LATEX,
      Rcpp::_["RTF"] = RTF,
      Rcpp::_["ESC_XTERM256"] = ESC_XTERM256,
      Rcpp::_["HTML32"] = HTML32,
      Rcpp::_["SVG"] = SVG,
      Rcpp::_["BBCODE"] = BBCODE,
      Rcpp::_["PANGO"] = PANGO,
      Rcpp::_["ODTFLAT"] = ODTFLAT,
      Rcpp::_["ESC_TRUECOLOR"] = ESC_TRUECOLOR);
}


// [[Rcpp::export]]
std::string highlight_(std::string input, std::string language, int output, std::string theme, std::string theme_path, std::string language_path) {
  using boost::movelib::unique_ptr;
  unique_ptr<highlight::CodeGenerator> generator(highlight::CodeGenerator::getInstance(static_cast<highlight::OutputType>(output)));
  if (!generator->initTheme(theme_path + "/" + theme + ".theme")) {
    Rcpp::stop(generator->getThemeInitError());
  }
  generator->initIndentationScheme("");
  highlight::LoadResult loadRes = generator->loadLanguage(language_path + '/' + language + ".lang");
  std::stringstream err;
  if ( loadRes==highlight::LOAD_FAILED_REGEX ) {
    err << "highlight: Regex error ( "
      << generator->getSyntaxRegexError()
      << " ) in "<< language <<".lang\n";
    Rcpp::stop(err.str());
  } else if ( loadRes==highlight::LOAD_FAILED_LUA ) {
    err << "highlight: Lua error ( "
      << generator->getSyntaxLuaError()
      << " ) in "<< language <<".lang\n";
    Rcpp::stop(err.str());
  } else if ( loadRes==highlight::LOAD_FAILED ) {
    Rcpp::stop("Could not load: " + language_path + '/' + language + ".lang");
  }
  return generator->generateString(input);
}
