require 'spec_helper'

describe "Microposts" do

  before(:each) do
    user = Factory(:user)
    visit signin_path
    fill_in :email,	:with => user.email
    fill_in :password, :with => user.password
    click_button
  end

  describe "creattion" do

    describe "failure" do

      it "should not make a new micropost" do
        lambda do
          visit root_path
          fill_in :micropost_content, :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Micropost, :count)
      end
    end


    describe "success" do

      it "should make a new micropost" do
        content = "my ....nnn"
        lambda do
          visit root_path
          fill_in :micropost_content, :with => content
          click_button
          response.should have_selector('span.content', :content => content)
        end.should change(Micropost, :count).by(1)
      end
    end
  end

  describe "show count message" do

    before(:each) do
      @content1 = "my ....nnn"
      @content2 = "two may"
    end

    it "should show '1 micropost'" do
      lambda do
        visit root_path
        fill_in :micropost_content, :with => @content1
        click_button
        response.should_not have_selector('span.microposts', :content => 'microposts')
        response.should have_selector('span.microposts', :content => '1 micropost')
      end.should change(Micropost, :count).by(1)
    end

    it "should show '2 microposts'" do
      lambda do
        visit root_path
        fill_in :micropost_content, :with => @content1
        click_button
        fill_in :micropost_content, :with => @content2
        click_button
        response.should have_selector('span.microposts', :content => '2 microposts')
      end.should change(Micropost, :count).by(2)
    end
  end
end
