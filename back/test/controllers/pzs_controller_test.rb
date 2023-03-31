require "test_helper"

class PzsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pz = pzs(:one)
  end

  test "should get index" do
    get pzs_url, as: :json
    assert_response :success
  end

  test "should create pz" do
    assert_difference("Pz.count") do
      post pzs_url, params: { pz: { altitude: @pz.altitude, area_id: @pz.area_id, name: @pz.name, radius: @pz.radius, type: @pz.type } }, as: :json
    end

    assert_response :created
  end

  test "should show pz" do
    get pz_url(@pz), as: :json
    assert_response :success
  end

  test "should update pz" do
    patch pz_url(@pz), params: { pz: { altitude: @pz.altitude, area_id: @pz.area_id, name: @pz.name, radius: @pz.radius, type: @pz.type } }, as: :json
    assert_response :success
  end

  test "should destroy pz" do
    assert_difference("Pz.count", -1) do
      delete pz_url(@pz), as: :json
    end

    assert_response :no_content
  end
end
