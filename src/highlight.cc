#include <Rcpp.h>
#include "codegenerator.h"

using namespace std;

// [[Rcpp::export]]
std::string highlight_(std::string input, std::string type, std::string theme, std::string theme_path, std::string language_path) {
  unique_ptr<highlight::CodeGenerator> generator(highlight::CodeGenerator::getInstance(highlight::ESC_ANSI));
  if (!generator->initTheme(theme_path + "/" + theme + ".theme")) {
    Rcpp::stop(generator->getThemeInitError());
  }
  generator->initIndentationScheme("");
  highlight::LoadResult loadRes = generator->loadLanguage(language_path + '/' + type + ".lang");
  std::stringstream err;
  if ( loadRes==highlight::LOAD_FAILED_REGEX ) {
    err << "highlight: Regex error ( "
      << generator->getSyntaxRegexError()
      << " ) in "<< type <<".lang\n";
    Rcpp::stop(err.str());
  } else if ( loadRes==highlight::LOAD_FAILED_LUA ) {
    err << "highlight: Lua error ( "
      << generator->getSyntaxLuaError()
      << " ) in "<< type <<".lang\n";
    Rcpp::stop(err.str());
  } else if ( loadRes==highlight::LOAD_FAILED ) {
    Rcpp::stop("Could not load: " + language_path + '/' + type + ".lang");
  }
  return generator->generateString(input);
}
