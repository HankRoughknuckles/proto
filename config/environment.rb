# Load the Rails application.
require File.expand_path('../application', __FILE__)

AWS::S3::DEFAULT_HOST = "s3-eu-west-1.amazonaws.com"

# Initialize the Rails application.
Rails.application.initialize!

