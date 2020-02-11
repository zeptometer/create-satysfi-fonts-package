require 'yaml'
require 'erb'

OPAM_TEMPLATE = ERB.new(<<EOS
opam-version: "2.0"
name: "satysfi-<%= yml["name"] %>"
version: "<%= yml["font-metadata"]["version"] %>+satysfi0.0.4"
synopsis: "SATySFi Font Package for <%= yml["font-metadata"]["name"] %> fonts"
description: """
SATySFi font package for <%= yml["font-metadata"]["name"] %> fonts.

This package installs fonts from <%= yml["font-metadata"]["url"] %>.
"""
maintainer: "<%= yml["author"]["name"] %> <<%= yml["author"]["email"] %>>"
authors: "<%= yml["author"]["name"] %> <<%= yml["author"]["email"] %>>"
license: "<%= yml["font-metadata"]["license"] %>"
homepage: "<%= yml["site"]["homepage"] %>"
bug-reports: "<%= yml["site"]["bug-reports"] %>"
dev-repo: "<%= yml["site"]["dev-repo"] %>"
extra-source "<%= yml["font-archive"]["name"] %>" {
  archive: "<%= yml["font-archive"]["url"] %>"
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
  [<%= extract_command %>]
]
install: [
  ["satyrographos" "opam" "install"
   "-name" "fonts-computer-modern"
   "-prefix" "%{prefix}%"
   "-script" "%{build}%/Satyristes"]
]
EOS
)

def gen_opam(yml)
    extract_command = yml["font-archive"]["extract"].split(/\s/).map do |cmd|
      "\"#{cmd}\""
    end
    .join(" ")

    File.open("actual-#{yml["name"]}.txt", "w") do |f|
      f.puts(OPAM_TEMPLATE.result(binding))
    end

    OPAM_TEMPLATE.result(binding)
end