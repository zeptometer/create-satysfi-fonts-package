# frozen_string_literal: true

require 'yaml'
require 'erb'
require 'digest'
require 'ttfunk'

OPAM_TEMPLATE = ERB.new <<~OPAM
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
OPAM

def make_extract_command(cmdstr)
  cmdstr
    .split(/\s/).map do |cmd|
      "\"#{cmd}\""
    end
    .join(' ')
end

def gen_opam(yml)
  archive_info = yml['font-archive']
  extract_command = make_extract_command(archive_info['extract'])

  archive_name = archive_info['name']
  sha256sum = Digest::SHA256.file(archive_name).to_s
  sha512sum = Digest::SHA512.file(archive_name).to_s

  OPAM_TEMPLATE.result(binding)
end

def get_fonts_in_dir(dir)
  Dir
    .entries(dir)
    .select { |filename| /.*(\.ttf|\.otf)/.match(filename) }
end

def get_font_name(font_file_name)
  font = TTFunk::File.open(font_file_name)
  font.name.postscript_name.to_s
end

def make_stage2_yml_entry(dir, font_file_name)
  {
    'type' => nil,
    'name' => get_font_name("#{dir}/#{font_file_name}"),
    'file' => font_file_name
  }
end

def gen_stage2_yml(yml)
  expand_dir = yml['font-archive']['expand-dir']
  get_fonts_in_dir(expand_dir)
    .map { |fontname| make_stage2_yml_entry(expand_dir, fontname) }
    .sort_by { |entry| entry['name'] }
end
