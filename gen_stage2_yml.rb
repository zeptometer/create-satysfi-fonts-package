# frozen_string_literal: true

require 'ttfunk'

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

def gen_font_list(expand_dir_name)
  get_fonts_in_dir(expand_dir_name)
    .map { |font_name| make_stage2_yml_entry(expand_dir_name, font_name) }
    .sort_by { |entry| entry['name'] }
end

def gen_stage2_yml(yml)
  font_list = gen_font_list(yml['font-archive']['expand-dir'])
  yml.merge('font-list' => font_list)
end
