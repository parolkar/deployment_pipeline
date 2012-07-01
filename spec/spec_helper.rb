require 'rspec'
require "rr"
require File.expand_path(File.dirname(__FILE__) + '/../lib/pipeline')

RSpec.configure do |config|
  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate

  config.mock_with :rr

end
