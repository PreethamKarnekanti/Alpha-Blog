require "test_helper"

class CreateCategoryTest < ActionDispatch::IntegrationTest

  setup do
    @admin_user = User.create(username:"admin", email: "admin@example.com",
                    password:"test123", admin: true)
    sign_in_as(@admin_user)
  end
  test "getting the category form and creating the category form" do
    get "/categories/new"
    assert_response :success
    assert_difference 'Category.count', 1 do
      post categories_path, params: { category: {name: "Sports"}}
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "Sports", response.body
  end

  test "getting the category form and reject invalid the category submission" do
    get "/categories/new"
    assert_response :success
    assert_no_difference 'Category.count' do
      post categories_path, params: { category: {name: " "}}
    end
    assert_match 'The following errors prevented the article from being saved', response.body
  end
end
