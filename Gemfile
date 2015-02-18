source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# keep passwords safe
gem 'figaro', '1.1.0'
# user authentication with devise
gem 'devise', '3.4.1'
# allow voting
gem 'acts_as_votable', '0.10.0' 
#upload images and such
gem "paperclip", "~> 4.2"
#for use with heroku
gem "rails_12factor", group: :production
#use amazon aws for storing images
gem 'aws-sdk'


group :development do
  gem "spring-commands-rspec", "1.0.4"
end


group :development, :test do
  # Call 'byebug' anywhere to stop execution and get a debug console
  gem 'byebug'

  # Access an IRB console on exception pages or <%= console %> in views
  gem 'web-console', '~> 2.0'

  gem 'spring'
  gem 'rspec-rails', '3.2.0'
  gem 'factory_girl_rails', '4.5.0'
end


group :test do
  gem 'capybara', '~> 2.4.4'            #intuitive testing language
  gem 'capybara-webkit', '1.4.1'
  gem 'selenium-webdriver', '~> 2.44.0'  #allows js in tests
  gem 'database_cleaner', '~> 1.4.0'    #clean the database in tests easily
  gem 'launchy', '~> 2.4.3'             #for opening up the page while debugging tests
end
