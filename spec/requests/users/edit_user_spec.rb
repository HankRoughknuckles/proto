require "spec_helper"

describe "The Edit User page" do
  let(:user)       { FactoryGirl.create(:user) }
  let(:edit_page) { UserEditPage.new }

  before { edit_page.visit_page_as user }

  describe "Changing the username" do
    it 'should work if username is present' do
      edit_page.fill_username_input_with "new_user"
      edit_page.fill_password_input_with user.password
      edit_page.click_save_button

      expect(User.first.username).to eq "new_user"
    end
  end

  describe "Gold status" do
    let(:activation_page) { GoldActivationPage.new }

    it 'should have an activation link if user has gold_credit' do
      user.update_attribute "gold_credit", 1

      edit_page.visit_page_as user
      edit_page.click_activate_gold_status_link

      expect(page.title).to match /#{activation_page.title}/
    end

    it 'should not have an activation link if user has no credit' do
      user.update_attribute "gold_credit", 0

      edit_page.visit_page_as user
      expect(edit_page).not_to have_activate_gold_status_link
    end
  end
end