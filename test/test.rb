# frozen_string_literal: true

require 'test-unit'
require 'yaml'
require_relative '../gen_hash'
require_relative '../gen_opam'
require_relative '../gen_readme'
require_relative '../gen_satyristes'
require_relative '../gen_stage2_yml'

def load_yaml_input(path)
  abs_path = File.expand_path("./input/#{path}", File.dirname(__FILE__))
  YAML.load_file(abs_path)
end

def load_yaml_expect(path)
  abs_path = File.expand_path("./expected/#{path}", File.dirname(__FILE__))
  YAML.load_file(abs_path)
end

def read_expect(path)
  abs_path = File.expand_path("./expected/#{path}", File.dirname(__FILE__))
  File.read(abs_path)
end

def prepare_archive(input_yaml_path)
  yml = load_yaml_input(input_yaml_path)
  archive_url = yml['font-archive']['url']
  archive_name = yml['font-archive']['name']
  archive_extract_cmd = yml['font-archive']['extract']
  expand_dir = yml['font-archive']['expand-dir']

  `wget #{archive_url} -O #{archive_name}` unless File.exist?(archive_name)
  `#{archive_extract_cmd}` unless File.exist?(expand_dir)
end

class TestStage1 < Test::Unit::TestCase
  def setup
    prepare_archive('stage1-computer-modern-unicode.yml')
    prepare_archive('stage1-noto-sans-cjk-jp.yml')
  end

  def test_opam_generated_for_computer_modern
    yml = load_yaml_input('stage1-computer-modern-unicode.yml')
    actual = gen_opam(yml)
    expected = read_expect('expected-computer-modern-unicode.opam')
    assert_equal(expected, actual)
  end

  def test_opam_generated_for_noto_sans_jp
    yml = load_yaml_input('stage1-noto-sans-cjk-jp.yml')
    actual = gen_opam(yml)
    expected = read_expect('expected-noto-sans-cjk-jp.opam')
    assert_equal(expected, actual)
  end

  def test_get_font_name_computer_modern_unicode
    font_file_name = 'cm-unicode-0.7.0/cmunbi.ttf'
    expected = 'CMUSerif-BoldItalic'
    actual = get_font_name(font_file_name)
    assert_equal(expected, actual)
  end

  def test_get_font_name_noto_sans_cjk_jp
    font_file_name = 'noto-sans-cjk-jp/NotoSansCJKjp-Light.otf'
    expected = 'NotoSansCJKjp-Light'
    actual = get_font_name(font_file_name)
    assert_equal(expected, actual)
  end

  def test_stage2_yml_generated_for_computer_modern_unicode
    yml = load_yaml_input('stage1-computer-modern-unicode.yml')
    actual = gen_stage2_yml(yml)
    expected = load_yaml_expect('expected-stage2-fonts-computer-modern-unicode.yml')
    assert_equal(expected, actual)
  end

  def test_stage2_yml_generated_for_noto_sans_cjk_jp
    yml = load_yaml_input('stage1-noto-sans-cjk-jp.yml')
    actual = gen_stage2_yml(yml)
    expected = load_yaml_expect('expected-stage2-fonts-noto-sans-cjk-jp.yml')
    assert_equal(expected, actual)
  end

  def test_satyristes_generation_for_computer_modern
    yml = load_yaml_input('stage2-fonts-computer-modern-unicode.yml')
    actual = gen_satyristes(yml)
    expected = read_expect('expected-Satyristes-computer-modern-unicode.txt')
    assert_equal(expected, actual)
  end

  def test_satyristes_generation_for_noto_sans_cjk
    yml = load_yaml_input('stage2-fonts-noto-sans-cjk-jp.yml')
    actual = gen_satyristes(yml)
    expected = read_expect('expected-Satyristes-noto-sans-cjk-jp.txt')
    assert_equal(expected, actual)
  end

  def test_fonts_hash_generation_for_computer_modern
    yml = load_yaml_input('stage2-fonts-computer-modern-unicode.yml')
    actual = gen_fonts_hash(yml)
    expected = read_expect('expected-computer-modern-unicode-fonts.satysfi-hash')
    assert_equal(expected, actual)
  end

  def test_fonts_hash_generation_for_noto_sans_cjk_jp
    yml = load_yaml_input('stage2-fonts-noto-sans-cjk-jp.yml')
    actual = gen_fonts_hash(yml)
    expected = read_expect('expected-noto-sans-cjk-jp-fonts.satysfi-hash')
    assert_equal(expected, actual)
  end

  def test_mathfonts_hash_generation_for_noto_sans_cjk_jp
    yml = load_yaml_input('stage2-fonts-noto-sans-cjk-jp.yml')
    actual = gen_mathfonts_hash(yml)
    expected = read_expect('expected-noto-sans-cjk-jp-mathfonts.satysfi-hash')
    assert_equal(expected, actual)
  end

  def test_mathfonts_hash_generation_for_asana_math
    yml = load_yaml_input('stage2-fonts-asana-math.yml')
    actual = gen_mathfonts_hash(yml)
    expected = read_expect('expected-asana-math-mathfonts.satysfi-hash')
    assert_equal(expected, actual)
  end

  def test_readme_generation_for_computer_modern
    yml = load_yaml_input('stage2-fonts-computer-modern-unicode.yml')
    actual = gen_readme(yml)
    expected = read_expect('expected-computer-modern-unicode-README.md')
    assert_equal(expected, actual)
  end

  def test_readme_generation_for_noto_sans_cjk_jp
    yml = load_yaml_input('stage2-fonts-noto-sans-cjk-jp.yml')
    actual = gen_readme(yml)
    expected = read_expect('expected-noto-sans-cjk-jp-README.md')
    assert_equal(expected, actual)
  end

  def test_readme_generation_for_asana_math
    yml = load_yaml_input('stage2-fonts-asana-math.yml')
    actual = gen_readme(yml)
    expected = read_expect('expected-asana-math-README.md')
    assert_equal(expected, actual)
  end

  def test_doc_opam_generation_for_noto_sans_cjk_jp
    yml = load_yaml_input('stage2-fonts-noto-sans-cjk-jp.yml')
    actual = gen_doc_opam(yml)
    expected = read_expect('expected-noto-sans-cjk-jp-doc.opam')
    assert_equal(expected, actual)
  end
end
