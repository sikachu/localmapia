require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  before(:each) do
    @user = User.new
  end
  
  it "should be able to tell if the email is invalid or not" do
    @user.password = @user.password_confirmation = "changeme"
    @user.email = "invalid_email"
    @user.should have_exactly(1).error_on(:email)
    @user.email = "valid_email@domain.com"
    @user.should be_valid
  end
  
  it "should contains unique email" do
    @user.email = "valid_email@domain.com"
    @user.password = @user.password_confirmation = "changeme"
    @user.save
    
    @another_user = User.new(:email => "valid_email@domain.com")
    @another_user.password = @user.password_confirmation = "changeme"
    @another_user.should_not be_valid
    @another_user.should have_exactly(1).error_on(:email)
  end
  
  it "should require email and password" do
    @user.should have_exactly(1).error_on(:email)
    @user.should have_exactly(1).error_on(:password)
    @user.email = "valid_email@domain.com"
    @user.password = @user.password_confirmation = "changeme"
    @user.should be_valid
  end
  
  it "should contain password in the range between 6..16 characters" do
    @user.password = @user.password_confirmation = "short"
    @user.should have_exactly(1).error_on(:password)
    @user.password = @user.password_confirmation = "validpassword"
  end
  
  it "should be able to validate correct password" do
    @user.email = "valid_email@domain.com"
    @user.password = @user.password_confirmation = "changeme"
    @user.save
    User.first.password.should eql("changeme")
  end
  
  it "should be able to validate password confirmation" do
    @user.email = "valid_email@domain.com"
    @user.password = "changeme"
    @user.password_confirmation = nil
    @user.should_not be_valid
    @user.should have_exactly(1).error_on(:password_confirmation)
    @user.password_confirmation = "changeme"
    @user.should be_valid
  end
  
  it "should automatically generate a random unique salt" do
    salt = @user.salt
    salt.should_not be_nil
    @user.salt.should eql(salt)
  end
  
  it "should have default status to normal" do
    @user.email = "valid_email@domain.com"
    @user.password = @user.password_confirmation = "changeme"
    @user.save
    @user.status.should eql("normal")
  end
  
  it "should automatically generate activation key after create" do
    @user.email = "valid_email@domain.com"
    @user.password = @user.password_confirmation = "changeme"
    @user.save
    @user.activation_key.should_not be_blank
  end
  
  it "should remove activation key after activated" do
    @user.email = "valid_email@domain.com"
    @user.password = @user.password_confirmation = "changeme"
    @user.save
    @user.activate!
    @user.activation_key.should be_nil
  end
  
  it "should automatically generate password_reset_key if requested" do
    @user.email = "valid_email@domain.com"
    @user.password = @user.password_confirmation = "changeme"
    @user.save
    password_reset_key = @user.reset_password!
    @user.password_reset_key.should_not be_nil
    @user.password_reset_key.should eql(password_reset_key)
  end
  
  it "should generate new password after enter correct password_reset_key" do
    @user.email = "valid_email@domain.com"
    @user.password = @user.password_confirmation = "changeme"
    @user.save
    @user.reset_password!
    @user.reset_password!("false_key").should eql(false)
    @user.reset_password!(@user.password_reset_key).should eql(true)
    @user.password.should_not eql("changeme")
  end
end
