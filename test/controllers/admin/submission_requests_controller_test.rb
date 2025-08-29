require "test_helper"

class Admin::SubmissionRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_submission_requests_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_submission_requests_show_url
    assert_response :success
  end

  test "should get new" do
    get admin_submission_requests_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_submission_requests_edit_url
    assert_response :success
  end
end
