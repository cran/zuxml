## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## ----setup--------------------------------------------------------------------
library(zuxml)

## -----------------------------------------------------------------------------
zuxml_info()

## ----error = TRUE-------------------------------------------------------------
try({
xml_parse('<!DOCTYPE d [<!ENTITY x SYSTEM "file:///etc/passwd">]><d>&x;</d>')
})

## ----error = TRUE-------------------------------------------------------------
try({
xml_parse(paste0(
  '<!DOCTYPE lol [',
  '<!ENTITY a "aaaaaaaaaa">',
  '<!ENTITY b "&a;&a;&a;&a;&a;&a;&a;&a;&a;&a;">',
  '<!ENTITY c "&b;&b;&b;&b;&b;&b;&b;&b;&b;&b;">',
  ']><lol>&c;</lol>'))
})

## -----------------------------------------------------------------------------
xml_text(xml_root(xml_parse("<!DOCTYPE feed><feed>hi</feed>",
                            allow_doctype = TRUE)))

## ----error = TRUE-------------------------------------------------------------
try({
xml_parse('<!DOCTYPE d [<!ENTITY e "X">]><d>x&e;y</d>', allow_doctype = TRUE)
})

## ----error = TRUE-------------------------------------------------------------
try({
xml_parse("<p>caf&eacute;</p>")
})

## ----error = TRUE-------------------------------------------------------------
try({
xml_parse(paste0(strrep("<a>", 300), strrep("</a>", 300)), max_depth = 256)
})

## ----error = TRUE-------------------------------------------------------------
try({
xml_parse("<a>a rather long run of text</a>", max_text = 8)
})

## -----------------------------------------------------------------------------
parse_or_null <- function(x, ...) {
  tryCatch(xml_parse(x, ...), zuxml_error = function(e) NULL)
}
parse_or_null("<a><b></a>")

## -----------------------------------------------------------------------------
classify <- function(x, ...) {
  tryCatch({ xml_parse(x, ...); "ok" },
    zuxml_doctype_error = function(e) "doctype refused",
    zuxml_limit_error   = function(e) "too expensive",
    zuxml_parse_error   = function(e) "malformed")
}
c(classify("<a/>"),
  classify("<!DOCTYPE a><a/>"),
  classify("<a><b></a>"),
  classify("<a>xxxxxxxx</a>", max_text = 2))

## -----------------------------------------------------------------------------
tryCatch(xml_parse("<a/>", max_depth = -1),
         zuxml_invalid_argument = function(e) conditionMessage(e))

## -----------------------------------------------------------------------------
e <- tryCatch(xml_parse("<a>\n  <b>\n</a>"), zuxml_error = identity)
conditionMessage(e)

## -----------------------------------------------------------------------------
xml_text(xml_root(xml_parse(as.raw(c(0x3c, 0x61, 0x3e, 0xe9, 0x3c, 0x2f, 0x61, 0x3e)),
                            encoding = "ISO-8859-1")))

## ----error = TRUE-------------------------------------------------------------
try({
xml_parse("<a>x</a>", encoding = "NOT-AN-ENCODING")
})

