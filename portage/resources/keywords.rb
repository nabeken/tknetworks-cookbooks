def initialize(*args) super(*args)
  @action = :create
end

actions :create, :update, :delete
attribute :keyword, :kind_of => String
