require 'test_helper'

class FindAreasBuildingsControllerTest < ActionController::TestCase
#  test "should post find_areas_buildings" do
#    post :find_areas_buildings, lang: 'jp', v: '1'
#  end

  # 初期設定
  def setup
    @controller = FindAreasBuildingsController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end
  
  # 正常系テスト
  def test_find_areas_buildings_request1
    post :find_areas_buildings, search_word: '横浜', lang: 'jp', v: '1'
    assert_response :success
    p 'test_find_areas_buildings_request1 response'
    p @response
  end

  # リクエストパラメータの検索キーワードなしテスト
  def test_find_areas_buildings_request2
    post :find_areas_buildings,  lang: 'jp', v: '1'
    assert_response :success
    p 'test_find_areas_buildings_request2 response'
    p @response
  end

  # リクエストパラメータの出力言語なしテスト
  def test_find_areas_buildings_request3
    post :find_areas_buildings, search_word: '大和', lang: '', v: '1'
    assert_response :success
    p 'test_find_areas_buildings_request3 response'
    p @response
  end

  # リクエストパラメータのバージョンなしテスト
  def test_find_areas_buildings_request4
    post :find_areas_buildings, search_word: '大和', lang: 'jp', v: ''
    assert_response :success
    p 'test_find_areas_buildings_request4 response'
    p @response
  end

  #--------------------
  #private method テスト
  #--------------------
  # get_areasテスト
  def test_find_areas_buildings_request5
    obj = FindAreasBuildingsController.new
    result = obj.send(:get_areas, '大和')
    p 'test_find_areas_buildings_request5'
    assert_response :success
    p result
    
    result = obj.send(:create_area_info, result)
    p 'test_find_areas_buildings_request10'
    assert_response :success
    p result
  end
    
  # get_buildingsテスト
  def test_find_areas_buildings_request6
    obj = FindAreasBuildingsController.new
    result = obj.send(:get_buildings, '大和')
    p 'test_find_areas_buildings_request6'
    assert_response :success
    p result
    
    result = obj.send(:cerate_building_info, result)
    p 'test_find_areas_buildings_request11'
    assert_response :success
    p result
  end

  # get_duty_free_shopテスト(エリア情報)
  def test_find_areas_buildings_request7_1
    obj = FindAreasBuildingsController.new
    result = obj.send(:get_duty_free_shop, 0, 1)
    p 'test_find_areas_buildings_request7_1'
    assert_response :success
    p result
  end
  
  # get_duty_free_shopテスト(施設情報)
  def test_find_areas_buildings_request7_2
    obj = FindAreasBuildingsController.new
    result = obj.send(:get_duty_free_shop, 1, 1)
    p 'test_find_areas_buildings_request7_2'
    assert_response :success
    p result
  end

  # get_conciergeテスト(エリア情報)
  def test_find_areas_buildings_request8_1
    obj = FindAreasBuildingsController.new
    result = obj.send(:get_concierge, 0, 1)
    p 'test_find_areas_buildings_request8_1'
    assert_response :success
    p result
  end

  # get_conciergeテスト(施設情報)
  def test_find_areas_buildings_request8_2
    obj = FindAreasBuildingsController.new
    result = obj.send(:get_concierge, 1, 1)
    p 'test_find_areas_buildings_request8_2'
    assert_response :success
    p result
  end

  # get_background_imageテスト
  def test_find_areas_buildings_request9
    obj = FindAreasBuildingsController.new
    result = obj.send(:get_background_image, 281110143)
    p 'test_find_areas_buildings_request9'
    assert_response :success
    p result
  end
end
