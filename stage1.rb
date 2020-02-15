# frozen_string_literal: true

require 'yaml'
require_relative 'gen_stage2_yml'

def prepare_archive(yml)
  archive_url = yml['font-archive']['url']
  archive_name = yml['font-archive']['name']
  archive_extract_cmd = yml['font-archive']['extract']
  expand_dir = yml['font-archive']['expand-dir']

  `wget #{archive_url} -O #{archive_name}` unless File.exist?(archive_name)
  `#{archive_extract_cmd}` unless File.exist?(expand_dir)
end

unless ARGV.size == 2
  p 'usage: ruby stage1.rb stage1_yml output_yml'
  exit(1)
end

input_yml_path = ARGV[0]
output_yml_path = ARGV[1]

yml = YAML.load_file(input_yml_path)
prepare_archive(yml)
stage2_yml = gen_stage2_yml(yml)
YAML.dump(stage2_yml, File.open(output_yml_path, 'w'))
