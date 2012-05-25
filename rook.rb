require 'sinatra'
require 'data_mapper'
require 'haml'
require 'will_paginate'
require 'will_paginate/data_mapper'
require 'will_paginate/view_helpers/sinatra'

require_relative 'routes/init'
require_relative 'models/init'

DataMapper.setup(:default, 'mysql://root@localhost/rook')

class Rook < Sinatra::Base

  configure do
    helpers WillPaginate::Sinatra::Helpers
    set :app_file, __FILE__
  end
end

#class Rook::Subscription
#  include DataMapper::Resource
#end
