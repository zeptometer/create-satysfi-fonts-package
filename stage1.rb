require 'yaml'

OPAM_TEMPLATE = <<EOS
opam-version: "2.0"
name: "satysfi-fonts-computer-modern"
version: "0.7.0+satysfi0.0.4"
synopsis: "SATySFi Font Package for Donald Knuth's Computer Modern Fonts"
description: """
SATySFi font package for Donald Knuth's Computer Modern Fonts.

This package installs fonts from https://www.checkmyworking.com/cm-web-fonts/.
"""
maintainer: "MURASE Yuito <yuito.murase@gmail.com>"
authors: "MURASE Yuito <yuito.murase@gmail.com>"
license: "OFL"
homepage: "https://github.com/zeptometer/SATySFi-fonts-computer-modern"
bug-reports: "https://github.com/zeptometer/SATySFi-fonts-computer-modern/issues"
dev-repo: "git+https://github.com/zeptometer/SATySFi-fonts-computer-modern.git"
extra-source "computer-modern.zip" {
  archive: "https://www.checkmyworking.com/cm-web-fonts/Computer%20Modern.zip"
  checksum: [
    "sha256=c240fff666a7d66de83a9f09ef045732c07291f2c83a07ae25ed888dc92f00f0"
    "sha512=fddad701425d1d1e761f1998b9a168fb60dff5972a858e44ae107e9bfa1678f807e71055b93b0969d29a0d728233a5532edc02c0655bded3ac5bc69b580da0c4"
  ]
}
depends: [
  "satysfi" {>= "0.0.3+dev2019.02.12" & < "0.0.5"}
  "satyrographos" {>= "0.0.2" & < "0.0.3"}
]
build: [
  ["unzip" "-j" "-d" "computer-modern" "-o" "computer-modern.zip" "*.ttf"]
]
install: [
  ["satyrographos" "opam" "install"
   "-name" "fonts-computer-modern"
   "-prefix" "%{prefix}%"
   "-script" "%{build}%/Satyristes"]
]
EOS

def gen_opam(spec)
    OPAM_TEMPLATE
end