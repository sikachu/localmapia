# == Schema Information
# Schema version: 20090325065024
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  email              :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  displayname        :string(255)
#  city               :string(255)
#  province           :string(255)
#  country            :string(255)
#  status             :string(255)
#  activation_key     :string(255)
#  activated_at       :datetime
#  password_reset_key :string(255)
#  last_logged_in     :date
#  created_at         :datetime
#  updated_at         :datetime
#  auto_login_hash    :string(255)
#

class User < ActiveRecord::Base
  include Authentication::Model
  
  has_many :feedbacks
  has_many :participations
  has_many :participate_events, :through => :participations, :source => :event
  has_many :messages, :foreign_key => :to_id
  has_many :sent_messages, :foreign_key => :from_id
  has_many :reports
  has_many :event_logs
  has_many :locations
  has_many :photos
  has_and_belongs_to_many :friends, :class_name => "User", :association_foreign_key => :friend
  
  attr_encrypted :password, :key => :salt, :encode => true
  attr_accessor :password_confirmation
  STATUS = %w(banned monitored normal moderator admin)
  
  validates_uniqueness_of :email, :message => "has already been used"
  validates_format_of :email, :with => /(.+?)@(.+?)\.(.+)?/
  validates_uniqueness_of :displayname
  validates_presence_of :displayname
  validates_length_of :password, :in => 6..16
  
  before_create :set_default_status, :generate_activation_key!
  
  named_scope :online, :conditions => ["status NOT IN (?)", ["not_activated", "banned"]]
  
  def salt
    self[:salt] ||= Digest::SHA2.new(512).hexdigest(rand(2**1000).to_s)
  end
  
  def activate!
    self.activation_key = nil
    self.activated_at = Time.now
    self.status = "normal"
    self.save
  end
  
  def update_login!
    self.last_logged_in = Time.now
    self.save
  end
  
  def displayname=(displayname)
    self[:displayname] = displayname.strip
  end
  
  def reset_password!(reset_key = nil)
    if reset_key.nil?
      update_attributes(:password_reset_key => Digest::SHA1.hexdigest(rand(2**1000).to_s+salt))
      return password_reset_key
    elsif reset_key == password_reset_key
      self[:password_reset_key] = nil
      generate_random_password!
      return true
    else
      return false
    end
  end
  
  private
  
  def set_default_status
    self[:status] = "not_activated"
  end
  
  def generate_activation_key!
    self[:activation_key] = Digest::SHA1.hexdigest(rand(2**1000).to_s+salt)
  end
  
  def generate_random_password!
    self.password = self.password_confirmation = Digest::SHA1.hexdigest(rand(2**1000).to_s+salt)[0...8]
    save!
  end
  
  def validate
    self.errors.add(:password_confirmation, "is not match") if encrypted_password_changed? and self.password != self.password_confirmation
  end
end
