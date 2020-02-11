require 'test-unit'
require 'yaml'
require '../stage1'

class TestStage1_gen_opam < Test::Unit::TestCase

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
        # assert_equal(expected, actual)
    end

end