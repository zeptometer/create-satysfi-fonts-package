require 'yaml'
require 'erb'
require 'digest'

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
    "sha256=<%= sha256sum %>"
    "sha512=<%= sha512sum %>"
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
   "-name" "<%= yml["name"] %>"
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

    `wget #{yml["font-archive"]["url"]} -O archive`
    sha256sum = Digest::SHA256.file('archive').to_s
    sha512sum = Digest::SHA512.file('archive').to_s
    `rm archive`

    File.open("actual-#{yml["name"]}.txt", "w") do |f|
      f.puts(OPAM_TEMPLATE.result(binding))
    end

    OPAM_TEMPLATE.result(binding)
end
