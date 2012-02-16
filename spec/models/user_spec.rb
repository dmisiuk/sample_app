# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do
	before(:each) do
	  @attr = {
      :name => "Example user", 
      :email => "user@example.com",
      :password => "mypassword", 
      :password_confirmation => "mypassword" 
    }
	end

	it "should create a new instance given valid attributes" do
	  User.create!(@attr)
	end
  
  it "should require a name" do
  	no_name_user = User.new(@attr.merge(:name => ""))
  	no_name_user.should_not be_valid
  end

  it "should require a email" do
    no_name_user = User.new(@attr.merge(:email => ""))
    no_name_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = 'a'*51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@mail.by Teh_ds@mail.by.ru dima.by@foot.ru]
    addresses.each do |address|
    	valid_email_user = User.new(@attr.merge(:email => address))
    	valid_email_user.should be_valid
    end
  end

  it "should reject invalid address" do
    addresses = %w[dima dima.by @mail.ru dima@ya dima@ dima@mail,ru dima@mail.]
    addresses.each do |address|
    	invalid_email_user = User.new(@attr.merge(:email => address))
    	invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email address" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses indentical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "password_validation" do
    
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end

    it "should require a matching password confirm" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end

    it "should reject a short password" do
      short = "a"*5
      User.new(@attr.merge(:password => short, :password_confirmation => short)).
        should_not be_valid
    end

    it "should reject a too long password" do
      long = "a"*41
      User.new(@attr.merge(:password => long, :password_confirmation => long)).
        should_not be_valid
    end
  end

  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
    it "should have a encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do
      it "should be true if the password match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false if the password don't match" do
        @user.has_password?("invalid").should be_false
      end

      describe "authenticate method" do
        it "should return nil on email/password mismatch" do
          wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
          wrong_password_user.should be_nil
        end

        it "should return nil for an email address with no user" do
          nonexistent_user = User.authenticate("foobar.by@gmail.com", @attr[:password])
          nonexistent_user.should be_nil
        end

        it "should return the user on email/password match" do
          matching_user = User.authenticate(@attr[:email], @attr[:password])
          matching_user.should == @user
        end
      end
    end
  end
end


