source :rubygems

gem 'sinatra'
gem 'thin'
gem 'data_mapper'
gem 'haml'
gem 'dm-mysql-adapter'

group :development, :test do
  gem 'shotgun'
  gem 'capybara'
  gem 'rack-test'
  gem 'pry-nav'
  if RUBY_PLATFORM =~ /darwin/i
    gem 'guard-minitest'
    gem 'growl'
    gem 'growl_notify'
    gem 'rb-fsevent', :require => false
  end
  gem 'minitest-reporters'
  gem 'ruby_gntp'
  #gem 'guard-livereload' #guard init livereload #also install live reload ext in browser
end
