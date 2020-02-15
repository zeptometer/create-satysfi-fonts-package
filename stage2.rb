# frozen_string_literal: true

require 'fileutils'
require 'yaml'
require_relative 'gen_doc_opam'
require_relative 'gen_doc_saty'
require_relative 'gen_hash'
require_relative 'gen_opam'
require_relative 'gen_readme'
require_relative 'gen_satyristes'

def prepare_archive(yml)
  archive_url = yml['font-archive']['url']
  archive_name = yml['font-archive']['name']
  archive_extract_cmd = yml['font-archive']['extract']
  expand_dir = yml['font-archive']['expand-dir']

  `wget #{archive_url} -O #{archive_name}` unless File.exist?(archive_name)
  `#{archive_extract_cmd}` unless File.exist?(expand_dir)
end

unless ARGV.size == 2
  p 'usage: ruby stage1.rb stage1_yml output_dir'
  exit(1)
end

input_yml_path = ARGV[0]
output_dir = ARGV[1]

FileUtils.mkdir_p output_dir unless File.exist?(output_dir)

yml = YAML.load_file(input_yml_path)
prepare_archive(yml)

pkgname = yml['name']

File.write("#{output_dir}/satysfi-#{pkgname}.opam", gen_opam(yml))
File.write("#{output_dir}/satysfi-#{pkgname}-doc.opam", gen_doc_opam(yml))
File.write("#{output_dir}/doc-#{pkgname}.saty", gen_doc_saty(yml))
File.write("#{output_dir}/fonts.satysfi-hash", gen_fonts_hash(yml))
File.write("#{output_dir}/mathfonts.satysfi-hash", gen_mathfonts_hash(yml))
File.write("#{output_dir}/README.md", gen_readme(yml))
File.write("#{output_dir}/Satyristes", gen_satyristes(yml))
