$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'fuzzy-ruby/api'

require 'minitest/autorun'

class Foo
  def test_method
    123
  end
end


class FuzzyRubyTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil FuzzyRuby::VERSION
  end

  def test_local_variable
    result = FuzzyRuby.install do
      test_variable = 123
      test_vraiable
    end

    assert_equal 123, result
  end

  def test_method
    f = Foo.new
    result = FuzzyRuby.install do
      f.test_mthod
    end

    assert_equal 123, result
  end
end
