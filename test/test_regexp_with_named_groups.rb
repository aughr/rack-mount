require 'abstract_unit'

unless supports_named_captures?
  class TestRegexpWithNamedGroups < Test::Unit::TestCase
    RegexpWithNamedGroups = Rack::Mount::RegexpWithNamedGroups

    def test_simple_regexp
      regexp = RegexpWithNamedGroups.new(/foo/)
      assert_equal(/foo/, regexp)
      assert_equal([], regexp.names)
      assert_equal({}, regexp.named_captures)
    end

    def test_simple_string
      regexp = RegexpWithNamedGroups.new('foo')
      assert_equal(/foo/, regexp)
      assert_equal([], regexp.names)
      assert_equal({}, regexp.named_captures)
    end

    def test_regexp_with_captures
      regexp = RegexpWithNamedGroups.new(/(bar|baz)/)
      assert_equal(/(bar|baz)/, regexp)
      assert_equal([], regexp.names)
      assert_equal({}, regexp.named_captures)
    end

    def test_regexp_with_named_captures
      regexp = RegexpWithNamedGroups.new(/(?:<foo>bar|baz)/)
      assert_equal(/(bar|baz)/, regexp)
      assert_equal(['foo'], regexp.names)
      assert_equal({'foo' => [1]}, regexp.named_captures)
    end

    def test_regexp_with_non_captures
      regexp = RegexpWithNamedGroups.new(/(?:foo)(?:<bar>baz)/)
      assert_equal(/(?:foo)(baz)/, regexp)
      assert_equal(['bar'], regexp.names)
      assert_equal({'bar' => [1]}, regexp.named_captures)
    end

    def test_ignores_noncapture_indexes
      regexp = RegexpWithNamedGroups.new(/foo(?:bar)(?:<baz>baz)/)
      assert_equal(/foo(?:bar)(baz)/, regexp)
      assert_equal(['baz'], regexp.names)
      assert_equal({ 'baz' => [1]}, regexp.named_captures)
    end
    
    def test_ignores_noncapture_regexp_options
      regexp = RegexpWithNamedGroups.new(/foo(?:<bar>(?i-mx:bar))(?:<baz>baz)/)
      assert_equal(/foo((?i-mx:bar))(baz)/, regexp)
      assert_equal(['bar', 'baz'], regexp.names)
      assert_equal({ 'bar' => [1], 'baz' => [2]}, regexp.named_captures)
    end
  end
end
