class Message
  include DataMapper::Resource

  property :id, Serial
  property :body, String

  belongs_to :opportunity
  belongs_to :recipient, :model => 'User', :key => true
  belongs_to :sender, :model => 'User', :key => true
end

