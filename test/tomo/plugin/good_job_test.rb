require "test_helper"

class Tomo::Plugin::GoodJobTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil Tomo::Plugin::GoodJob::VERSION
  end
end
