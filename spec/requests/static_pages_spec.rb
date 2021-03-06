require 'spec_helper'

describe "Static pages" do

	let(:base_title) { "Ruby on Rails Tutorial Sample App"}
  subject { page }

  it "should have the right links on the layout" do
  visit root_path
  click_link "About"
  should have_selector('title', :text => full_title('About Us'))
  click_link "Help"
  should have_selector('title', :text => full_title('Help'))
  click_link "Contact"
  should have_selector('title', :text => full_title('Contact'))
  click_link "Home"
  click_link "Sign up now!"
  should have_selector('title', :text => full_title('Sign up'))
  click_link "sample app"
  should have_selector('title', :text => full_title(''))
  end


  describe "Home page" do
    before { visit root_path }
    it "should have the h1 'Sample App'" do
    should have_selector('h1' , :text => 'Sample App')
    end
    it "should have the base title 'Home'" do
    should have_selector('title', :text => full_title(''))
    end
    it "should not have a custom page title" do
    should_not have_selector('title', :text => '| Home')
    end

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user)}
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolo sit amet")
        sign_in user
        visit root_path
      end

      it " should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) {FactoryGirl.create(:user)}
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 follower", href: followers_user_path(user)) }
      end
    end
    
  end

  describe "Help page" do
  	it "should have the h1 'Help'" do
  		visit help_path
  		page.should have_selector('h1' , :text => 'Help')
  	end
  	it "should have the right title 'Help'" do
    	visit help_path
    	page.should have_selector('title',
    		:text => full_title('Help'))
    end
  end

  describe "About page" do
  	it "should have the h1 'About Us'" do
  		visit about_path
  		page.should have_selector('h1' , :text => 'About Us')
  	end
  	it "should have the right title 'About Us'" do
    	visit about_path
    	page.should have_selector('title',
    		:text => full_title('About Us'))
    end
  end

  describe "Contact page" do
  	it "should have the h1 'Contact" do
  		visit contact_path
  		page.should have_selector('h1', :text => 'Contact')
  	end
  	it "should have the right title 'Contact'" do
  		visit contact_path
  		page.should have_selector('title', :text => full_title('Contact'))
  	end
  end



end
