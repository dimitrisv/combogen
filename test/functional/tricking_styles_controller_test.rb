require 'test_helper'

class TrickingStylesControllerTest < ActionController::TestCase
  setup do
    @tricking_style = tricking_styles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tricking_styles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tricking_style" do
    assert_difference('TrickingStyle.count') do
      post :create, tricking_style: { description: @tricking_style.description, name: @tricking_style.name }
    end

    assert_redirected_to tricking_style_path(assigns(:tricking_style))
  end

  test "should show tricking_style" do
    get :show, id: @tricking_style
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tricking_style
    assert_response :success
  end

  test "should update tricking_style" do
    put :update, id: @tricking_style, tricking_style: { description: @tricking_style.description, name: @tricking_style.name }
    assert_redirected_to tricking_style_path(assigns(:tricking_style))
  end

  test "should destroy tricking_style" do
    assert_difference('TrickingStyle.count', -1) do
      delete :destroy, id: @tricking_style
    end

    assert_redirected_to tricking_styles_path
  end
end
