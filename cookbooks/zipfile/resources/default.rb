actions :extract, :compress, :nothing
default_action :extract

attribute :from, :kind_of => String, :name_attribute => true
attribute :into, :kind_of => String, :required => true
attribute :overwrite, :kind_of => [ TrueClass, FalseClass ], :default => false
