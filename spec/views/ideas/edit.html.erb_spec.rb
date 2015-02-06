require 'rails_helper'

RSpec.describe "ideas/edit", type: :view do
  before(:each) do
    @idea = assign(:idea, Idea.create!(
      :title => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit idea form" do
    render

    assert_select "form[action=?][method=?]", idea_path(@idea), "post" do

      assert_select "input#idea_title[name=?]", "idea[title]"

      assert_select "textarea#idea_description[name=?]", "idea[description]"
    end
  end
end
