class Permission < ActiveRecord::Base
  has_and_belongs_to_many :roles

  named_scope :by_controller_action, lambda { |c, a| {:conditions => ["controller_name = ? and action_name = ?", c, a]} }
  
  validates_presence_of :name, :controller_name, :action_name
end
