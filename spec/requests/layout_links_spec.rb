require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end

  it "should have a Contact page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end

  it "should have an About page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => "About")
  end

  it "should have a Help page at '/help'" do
    get '/help'
    response.should have_selector('title', :content => "Help")
  end

  it "should have a Sign up page at /signup" do
    get '/signup'
    response.should have_selector('title', :content => "Sign up")
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    response.should have_selector('title', :content => "About")
    click_link "Help"
    response.should have_selector('title', :content => "Help")
    click_link "Contact"
    response.should have_selector('title', :content => "Contact")
    click_link "Home"
    response.should have_selector('title', :content => "Home")
    click_link "Sign up now!"
    response.should have_selector('title', :content => "Sign up")
  end

  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      response.should have_selector('a', :href => signin_path,
      :content => "Sign in")
    end
  end

  describe "when signed in" do
    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in :email, :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    end

    it "should have a signout link" do
      visit root_path
      response.should have_selector('a', :href => signout_path,
                                          :content => "Sign out")
    end

    it "should have a profile link" do
      visit root_path
      response.should have_selector('a', :href => user_path(@user),
                                          :content => "Profile")
    end
  end

  describe "link delete" do

    describe "for admin user" do
      before(:each) do
        admin = Factory(:user, :email => "admin@exampl.com", :admin => true)
        visit signin_path
        fill_in :email, :with => admin.email
        fill_in :password, :with => admin.password
        click_button
      end

      it "should have a 'delete' link" do
        get '/users'
        response.should have_selector('a', :content => 'delete')
      end
    end


    describe "for non-admin user" do
      before(:each) do
        user = Factory(:user)
        visit signin_path
        fill_in :email, :with => user.email
        fill_in :password, :with => user.password
        click_button
      end

      it "should not have a 'delete' link" do
        get '/users'
        response.should_not have_selector('a', :content => 'delete')
      end
    end
  end

end
