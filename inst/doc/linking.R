## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## -----------------------------------------------------------------------------
# system.file() returns "" outside an installed layout, and dir("") would then
# list the working directory rather than nothing.
installed <- function(what) {
  path <- system.file(what, package = "zuxml")
  if (nzchar(path)) dir(path) else "(not an installed layout)"
}

installed("include")
arch <- .Platform$r_arch
installed(if (nzchar(arch)) file.path("lib", arch) else "lib")

