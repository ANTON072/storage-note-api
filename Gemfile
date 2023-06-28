source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'

gem 'rails', '~> 7.0.5'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'jbuilder'
gem 'bootsnap', require: false
gem 'jwt'
gem "rack-cors"
gem 'httparty'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rspec-rails', '~> 6.0.0'
end

group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rails-erd'
end
