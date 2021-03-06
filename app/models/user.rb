class User < ActiveRecord::Base
  has_one :profile, :class_name => "UserProfile", :dependent => :destroy, :include => [:group, :position]
  has_and_belongs_to_many :roles
  accepts_nested_attributes_for :profile
  set_inheritance_column 'object_type'
  
  named_scope :employees, {:conditions => ['object_type = "User"'], :include => [:profile]}
  
  acts_as_authentic do |c|
    c.logged_in_timeout = 1.minutes
  end

  def full_name
    "#{self.login}(#{self.profile.name})"
  end
  
  def permissions
    user_permissions = []
    self.roles.each do |role|
      user_permissions += role.permissions
    end
    user_permissions.uniq!
    return user_permissions
  end

  def to_s
    self.admin? ? "#{self.login} 超级管理员" : "#{self.profile.name}  所属部门: #{self.profile.group} 职称: #{self.profile.position}"
  end
  
  def admin?
    self.class == Admin
  end

  def save_default_password
    if self.password.blank?
      self.password = "ytrip"
    end
    if self.password_confirmation.blank?
      self.password_confirmation = self.password
    end
    if self.object_type.blank?
      self.object_type = self.class.to_s
    end
  end
end
