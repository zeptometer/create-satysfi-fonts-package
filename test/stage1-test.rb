require 'test-unit'
require 'yaml'
require '../stage1'

class TestStage1 < Test::Unit::TestCase

    def cm_yml 
        YAML.load_file('computer-modern-stage1.yml')
    end

    def test_opam_generated_for_computer_modern
        expected = File.read('expected-cm.opam')
        actual = gen_opam(cm_yml)

        assert_equal(expected, actual)
    end

end