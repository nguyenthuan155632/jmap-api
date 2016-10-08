require 'test_helper'

class GetAreasControllerTest < ActionController::TestCase
  # 初期設定
  def setup
    @controller = GetAreasController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end
  
  # 正常系テスト
  def test_get_areas1
    post :get_areas
    assert_response :success
    p 'test_get_areas1 response'
    p @response
  end

  #--------------------
  #private method テスト
  #--------------------    
  # get_dfs_countテスト
  def test_get_areas3
    obj = GetAreasController.new
    result = obj.send(:get_dfs_count, 4)
    p 'test_get_areas3'
    assert_response :success
    p result
  end

  # get_concierge_countテスト
  def test_get_areas4
    obj = GetAreasController.new
    result = obj.send(:get_concierge_count, 3)
    p 'test_get_areas4'
    assert_response :success
    p result
  end
  
  # get_bgimage_urlテスト
  def test_get_areas5
    obj = GetAreasController.new
    result = obj.send(:get_bgimage_url, 3)
    p 'get_bgimage_url5'
    assert_response :success
    p result
  end
end
