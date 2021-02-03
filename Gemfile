# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in poc_github_ap.gemspec
gemspec

group :development do
  # pry on steroids
  # gem 'pry-coolline', github: 'owst/pry-coolline', branch: 'support_new_pry_config_api'
  # gem 'jazz_fingers'
end

group :development, :test do
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rake', '~> 12.0'
  # this is used for cmdlets 'self-executing gems'
  gem 'rake-compiler'
  gem 'rspec', '~> 3.0'
  gem 'rubocop'
end

# group :test do
#   gem 'k_usecases', path: '~/dev/kgems/k_usecases'
# end
