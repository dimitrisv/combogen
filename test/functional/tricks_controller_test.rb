require 'test_helper'

class TricksControllerTest < ActionController::TestCase
  setup do
    @trick = tricks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tricks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create trick" do
    assert_difference('Trick.count') do
      post :create, trick: { difficulty: @trick.difficulty, landed: @trick.landed, name: @trick.name, setup: @trick.setup }
    end

    assert_redirected_to trick_path(assigns(:trick))
  end

  test "should show trick" do
    get :show, id: @trick
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @trick
    assert_response :success
  end

  test "should update trick" do
    put :update, id: @trick, trick: { difficulty: @trick.difficulty, landed: @trick.landed, name: @trick.name, setup: @trick.setup }
    assert_redirected_to trick_path(assigns(:trick))
  end

  test "should destroy trick" do
    assert_difference('Trick.count', -1) do
      delete :destroy, id: @trick
    end

    assert_redirected_to tricks_path
  end
end
