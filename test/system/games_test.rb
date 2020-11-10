require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  # test "visiting the index" do
  #   visit games_url
  #
  #   assert_selector "h1", text: "Game"
  # end
  test "visiting new" do
    visit new_url
    assert_selector "h1", text: "New game"
  end
end
