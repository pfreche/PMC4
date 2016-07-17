require 'test_helper'

class MtypeControllerTest < ActionController::TestCase
  test "should get name:strong" do
    get :name:strong
    assert_response :success
  end

  test "should get model:string" do
    get :model:string
    assert_response :success
  end

end
