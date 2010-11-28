def initialize(*args)
  super(*args)
  @action = :create
end

actions :create, :update, :delete
attribute :versions, :kind_of => Array
