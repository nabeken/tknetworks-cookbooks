def initialize(*args) super(*args)
  @action = :create
end

actions :create, :update, :delete
attribute :enable,      :kind_of => Array
attribute :disable,     :kind_of => Array
