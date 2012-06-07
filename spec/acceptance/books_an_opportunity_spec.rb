require_relative '../spec_helper'

describe "Booking an opportunity" do

  include AcceptanceHelper

  let(:user) { User.gen }
  before do
    User.gen(:opp)
    sign_in(user) 
    visit "/"
  end

  it "books an opportunity" do
    before = Booking.count
    within(:xpath, '//tbody/tr//td/form') do 
      click_button('Book it!')
    end

    assert_equal before + 1, Booking.count
  end
end
