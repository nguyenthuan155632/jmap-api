require 'test_helper'

class FindBuildingsControllerTest < ActionController::TestCase
  # 初期設定
  def setup
    @controller = FindBuildingsController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end
  
  # 正常系テスト
  def test_find_buildings1
    post :find_buildings, area_id: 1
    assert_response :success
    p 'test_find_buildings1 response'
    p @response
  end
  
  #--------------------
  #private method テスト
  #--------------------
  # calcdistanceテスト
  def test_find_buildings2
    obj = FindBuildingsController.new
    result = obj.send(:calcdistance, 35.0000, 139.0000, 34.0000, 140.0000)
    p 'test_find_buildings2'
    assert_response :success
    p result
  end

  # digtoradテスト
  def test_find_buildings3
    obj = FindBuildingsController.new
    result = obj.send(:digtorad, 35.0000)
    p 'test_find_buildings3'
    assert_response :success
    p result
  end
end
