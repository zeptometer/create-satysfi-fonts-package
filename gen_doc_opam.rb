# frozen_string_literal: true

require 'erb'
require 'digest'

DOC_OPAM_TEMPLATE = <<~TEMPLATE
  opam-version: "2.0"
  name: "satysfi-<%= yml['name'] %>-doc"
  version: "<%= yml['font-metadata']['version'] %>+satysfi0.0.4"
  synopsis: "Document of SATySFi Font Package for <%= yml['font-metadata']['name'] %> fonts"
  description: """
  Document package for satysfi-<%= yml['name'] %>
  """
  maintainer: "Yuito Murase <yuito.murase@gmail.com>"
  authors: "Yuito Murase <yuito.murase@gmail.com>"
  license: "CC0-1.0"
  homepage: "https://github.com/zeptometer/SATySFi-<%= yml['name'] %>"
  bug-reports: "https://github.com/zeptometer/SATySFi-<%= yml['name'] %>/issues"
  dev-repo: "git+https://github.com/zeptometer/SATySFi-<%= yml['name'] %>.git"
  depends: [
    "satysfi" {>= "0.0.3+dev2019.02.12" & < "0.0.5"}
    "satyrographos" {>= "0.0.2" & < "0.0.3"}
    "satysfi-base" {>= "1.2.0"}
    "satysfi-<%= yml['name'] %>" {= "<%= yml['font-metadata']['version'] %>+satysfi0.0.4"}
  ]
  build: [
    ["satyrographos" "opam" "build"
     "-name" "<%= yml['name'] %>-doc"
     "-prefix" "%{prefix}%"
     "-script" "%{build}%/Satyristes"]
  ]
  install: [
    ["satyrographos" "opam" "install"
     "-name" "<%= yml['name'] %>-doc"
     "-prefix" "%{prefix}%"
     "-script" "%{build}%/Satyristes"]
  ]
TEMPLATE

def gen_doc_opam(yml)
  ERB.new(DOC_OPAM_TEMPLATE)
     .result(binding)
end
