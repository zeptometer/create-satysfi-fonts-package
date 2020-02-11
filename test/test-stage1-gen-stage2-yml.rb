require 'test-unit'
require 'yaml'
require '../stage1'

class TestStage1_gen_opam < Test::Unit::TestCase

    def test_stage2_yml_generated_for_computer_modern
        # given
        yml = YAML.load_file('stage1-computer-modern-unicode.yml')

        # when
        actual = gen_stage2_yml(yml)

        # then
        expected = File.read('expected-stage2-fonts-computer-modern.yml')
        assert_equal(expected, actual)
    end
end