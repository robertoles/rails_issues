require 'test/unit'
require 'ruby-debug'
require 'active_support'
require 'active_support/core_ext'

class BugTest < Test::Unit::TestCase
  def test_inflection
    name = 'XYPlotter'
    assert_equal 'xy_plotter', name.underscore
    assert_equal 'XYPlotter', name.underscore.classify
  end
end