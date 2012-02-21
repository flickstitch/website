source 'https://rubygems.org'

gem 'rails', '3.2.0'
gem 'jquery-rails'
gem 'haml'
gem 'haml-rails', :group => :development
gem 'devise'
gem 'newrelic_rpm'
gem 'pry', :group => :development
gem 'cancan'
gem 'thumbs_up', '0.4.6'
gem 'simple_form', git: 'git://github.com/plataformatec/simple_form.git'

group :production do
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'less-rails-bootstrap'
end

group :development, :test do
  gem 'sqlite3'
end

group :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'launchy'
  gem 'factory_girl_rails'
  gem 'spork-rails'
end
