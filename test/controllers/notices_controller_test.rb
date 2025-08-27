require "test_helper"

class NoticesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get notices_index_url
    assert_response :success
  end

  test "should get show" do
    get notices_show_url
    assert_response :success
  end
end
