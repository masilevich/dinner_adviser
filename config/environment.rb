# Load the Rails application.
require File.expand_path('../application', __FILE__)
require 'hirb'
Hirb::View.enable

# Initialize the Rails application.
DinnerAdviser::Application.initialize!
