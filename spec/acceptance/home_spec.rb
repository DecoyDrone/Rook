require_relative '../spec_helper'

describe "Home page" do

  include AcceptanceHelper

  before (:each) do
    visit "/"
  end

  it "return 200" do
    assert_equal 200, page.status_code
  end

  it "greets the visitor" do
    assert has_content?("Welcome to Rook")
  end

  it "has a button to create opportunity" do
    click_link('Create')

    assert_equal "/opportunity", page.current_path
  end

  describe "pagination" do

    before(:each) do
      11.times { Rook::Opportunity.gen(:random) }
      visit "/"
    end

    it "table has a header" do
      assert has_content?("Available Opportunities!")
    end

    it "paginates" do
      assert has_content?("Next")
    end

    it "displays ten rows per page " do
      assert_equal 10, page.all(:xpath, '//tbody/tr').length
    end
  end
end

