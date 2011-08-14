ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
include Devise::TestHelpers


class ActiveSupport::TestCase
  
  # Drop all columns after each test case.
  def teardown
    Mongoid.database.collections.each do |coll|
      coll.remove
    end
    #$redis.flushdb
  end

  # Make sure that each test case has a teardown
  # method to clear the db after each test.
  def inherited(base)
    base.define_method teardown do
      super
    end
  end
end
