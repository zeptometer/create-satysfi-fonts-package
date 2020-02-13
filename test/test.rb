# frozen_string_literal: true

require 'test-unit'
require 'yaml'
require '../gen_opam'
require '../gen_stage2_yml'

def prepare_archive(yml_file)
  yml = YAML.load_file(yml_file)
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
    # given
    yml = YAML.load_file('stage1-computer-modern-unicode.yml')

    # when
    actual = gen_opam(yml)

    # then
    expected = File.read('expected-computer-modern-unicode.opam')
    assert_equal(expected, actual)
  end

  def test_opam_generated_for_noto_sans_jp
    # given
    yml = YAML.load_file('stage1-noto-sans-cjk-jp.yml')

    # when
    actual = gen_opam(yml)

    # then
    expected = File.read('expected-noto-sans-cjk-jp.opam')
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
    # given
    yml = YAML.load_file('stage1-computer-modern-unicode.yml')

    # when
    actual = gen_stage2_yml(yml)

    # then
    expected = YAML.load_file('expected-stage2-fonts-computer-modern.yml')
    assert_equal(expected, actual)
  end

  def test_stage2_yml_generated_for_noto_sans_cjk_jp
    # given
    yml = YAML.load_file('stage1-noto-sans-cjk-jp.yml')

    # when
    actual = gen_stage2_yml(yml)

    # then
    expected = YAML.load_file('expected-stage2-fonts-noto-sans-cjk-jp.yml')
    assert_equal(expected, actual)
  end
end
