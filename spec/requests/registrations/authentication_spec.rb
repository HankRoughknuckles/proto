require "spec_helper"

describe "The authentication process" do
  let(:auth_page)         { AuthenticationPage.new }
  let(:existing_user)     { FactoryGirl.create(:user) }

  before :each do
    auth_page.visit_page_as nil
  end

  describe "the sign up form" do
    it "should work with proper information" do
      auth_page.fill_signup_inputs_with FactoryGirl.attributes_for :user
      auth_page.click_signup_submit_button

      expect(auth_page).to have_signup_successful_flash
    end


    it "should not work if no email is present" do
      auth_page.fill_signup_inputs_with FactoryGirl.attributes_for :user
      auth_page.fill_signup_email_input_with ""
      auth_page.click_signup_submit_button

      expect(auth_page).to have_missing_email_error
    end


    it "should not work if no password is present" do
      auth_page.fill_signup_inputs_with FactoryGirl.attributes_for :user
      auth_page.fill_signup_password_input_with ""
      auth_page.click_signup_submit_button

      expect(auth_page).to have_missing_password_error
    end
  end


  describe "the sign in form" do
    let(:existing_user_attrs) { existing_user.attributes.symbolize_keys }

    it "should work with proper information" do
      auth_page.fill_signin_email_input_with existing_user.email
      auth_page.fill_signin_password_input_with existing_user.password
      auth_page.click_signin_submit_button

      expect(auth_page).to have_signin_successful_flash
    end


    it "should not work if no email is present" do
      auth_page.fill_signin_inputs_with existing_user_attrs
      auth_page.fill_signin_email_input_with ""
      auth_page.click_signin_submit_button

      expect(auth_page).to have_invalid_email_flash
    end


    it "should not work if no password is present" do
      auth_page.fill_signin_inputs_with existing_user_attrs
      auth_page.fill_signin_password_input_with ""
      auth_page.click_signin_submit_button

      expect(auth_page).to have_invalid_password_flash
    end
  end

  it "should have a 'continue with facebook' link"
  # it "should have a 'continue with facebook' link" do
  #   expect(auth_page).to have_continue_with_facebook_link
  # end
end
