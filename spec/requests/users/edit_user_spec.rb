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
end
