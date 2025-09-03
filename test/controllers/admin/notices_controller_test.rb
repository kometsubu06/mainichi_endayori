require "test_helper"

class Admin::NoticesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_notices_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_notices_show_url
    assert_response :success
  end

  test "should get new" do
    get admin_notices_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_notices_edit_url
    assert_response :success
  end
end
