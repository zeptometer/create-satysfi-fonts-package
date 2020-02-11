require 'test-unit'
require 'yaml'
require '../stage1'

class TestStage1 < Test::Unit::TestCase

    def test_opam_generated_for_computer_modern
        # given
        yml = YAML.load_file('computer-modern-unicode-stage1.yml')

        # when
        actual = gen_opam(yml)

        # then
        expected = File.read('expected-computer-modern-unicode.opam')
        assert_equal(expected, actual)
    end

    def test_opam_generated_for_noto_sans_jp
        # given
        yml = YAML.load_file('noto-sans-jp-stage1.yml')

        # when
        actual = gen_opam(yml)

        # then
        expected = File.read('expected-noto-sans-jp.opam')
        assert_equal(expected, actual)
    end

end