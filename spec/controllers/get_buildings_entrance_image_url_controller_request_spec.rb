require 'rails_helper'

RSpec.describe GetBuildingsEntranceImageUrlController, :type => :controller do
  
  before(:each) do
    request.env["HTTP_ACCEPT"] = 'application/json'
    create_dummy
  end

  describe "GET get_buildings_entrance_image_url" do
    it "returns http success" do
      post :get_buildings_entrance_image_url
      expect(response.status).to eq(200)
    end
    
    it "正常系（日本語）" do
      lang = "ja"
      building_id = "9686"
      post :get_buildings_entrance_image_url, :lang => lang, :building_id => building_id
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      puts response.body
      
      # response
      expect(json["response"]["code"]).to    eq(0)
      expect(json["response"]["message"]).to eq("取得しました。")
      
      # 多言語APIを叩く
      jmapi      = JmapI18n::ApiClient.new
      lang_array = jmapi.get(type: "venue", lang: lang, id: building_id)
      
      # response -> info
      info = json["response"]["info"]
      expect(info["building_id"]).to     eq(building_id)
      expect(info["building_name"]).to   eq(lang_array[0][:attrs][:name])
      expect(info["latitude"]).to        eq(Venue.find_by(venueId: building_id).lat)
      expect(info["longitude"]).to       eq(Venue.find_by(venueId: building_id).lon)
      expect(info["duty_free_count"]).to eq(get_count_from_type_venue(building_id, "dutyfree"))
      expect(info["concierge_count"]).to eq(get_count_from_type_venue(building_id, "chconcierge"))
      
      # response -> info -> entrance_infoのアイテム数と同じだけループする
      entrance_info = info["entrance_info"]
      
      for info_item in entrance_info do
        expect(info_item[:entrance_image]).to eq(Attribute.find_by(shopId: info_item[:shop_id], name: "entrance"))
      end
    end
    
    it "正常系（中国語）" do
      lang = "zh-cn"
      building_id = "9686"
      post :get_buildings_entrance_image_url, :lang => lang, :building_id => building_id
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      
      # response
      expect(json["response"]["code"]).to    eq(0)
      expect(json["response"]["message"]).to eq("取得しました。")
      
      # 多言語APIを叩く
      jmapi      = JmapI18n::ApiClient.new
      lang_array = jmapi.get(type: "venue", lang: lang, id: building_id)
      
      # response -> info
      info = json["response"]["info"]
      expect(info["building_id"]).to     eq(building_id)
      expect(info["building_name"]).to   eq(lang_array[0][:attrs][:name])
      expect(info["latitude"]).to        eq(Venue.find_by(venueId: building_id).lat)
      expect(info["longitude"]).to       eq(Venue.find_by(venueId: building_id).lon)
      expect(info["duty_free_count"]).to eq(get_count_from_type_venue(building_id, "dutyfree"))
      expect(info["concierge_count"]).to eq(get_count_from_type_venue(building_id, "chconcierge"))
      
      # response -> info -> entrance_infoのアイテム数と同じだけループする
      entrance_info = info["entrance_info"]
      
      for info_item in entrance_info do
        expect(info_item[:entrance_image]).to eq(Attribute.find_by(shopId: info_item[:shop_id], name: "entrance"))
      end
      
    end
    
    it "異常系（IDなし）" do
      post :get_buildings_entrance_image_url, :lang => "ja"
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      
      # response
      expect(json["response"]["code"]).to    eq(101)
      expect(json["response"]["message"]).to eq("施設IDが入力されておりません。")
      expect(json["response"]["info"]).to    eq({})
      
    end
    
    it "異常系（出力言語の指定が不正）" do
      post :get_buildings_entrance_image_url, :lang => "hoge", :building_id => "9686"
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      
      # response
      expect(json["response"]["code"]).to    eq(501)
      expect(json["response"]["message"]).to eq("DB処理に失敗しました。")
      expect(json["response"]["info"]).to    eq({})
      
    end
  end
  
  ########################################
  # タイプと施設IDから、その施設のIDに合致する店舗情報を調べる
  ########################################
  def get_count_from_type_venue(venueId, name)
    store_attributes = Attribute.where(["venueId = ? and name = ?", venueId, name])
    return store_attributes.count
  end
  
  ########################################
  # 施設IDからエントランス画像と、その画像の所属する店舗IDのセットアイテムをもった配列を作成する
  ########################################
  def create_entrance_info(venueId)
    entrance_info = Array.new
    
    attributes = Attribute.where(venueId: venueId, name: "entrance")
    for attribute in attributes do
      info_item = {
        entrance_image: attribute.value,
        shop_id:        attribute.shopId
      }
      entrance_info << info_item
    end
    
    return entrance_info
  end
  
  # - - - - - - - - - - - - - - - - - - - -
  # ダミーデータの生成
  # - - - - - - - - - - - - - - - - - - - -
  def create_dummy
    FactoryGirl.create(:area, areaid:  "1", lat: "35.672194", lon: "139.763954", url: "/back.jpeg")
    FactoryGirl.create(:area, areaid:  "2", lat: "35.658517", lon: "139.701334", url: "/back.jpeg")
    FactoryGirl.create(:area, areaid:  "3", lat: "35.690921", lon: "139.700258", url: "/back.jpeg")
    FactoryGirl.create(:area, areaid:  "4", lat: "35.698972", lon: "139.774773", url: "/back.jpeg")
    FactoryGirl.create(:area, areaid:  "5", lat: "35.713981", lon: "139.777265", url: "/back.jpeg")
    FactoryGirl.create(:area, areaid:  "6", lat: "35.627991", lon: "139.778554", url: "/back.jpeg")
    FactoryGirl.create(:area, areaid:  "7", lat: "35.681594", lon: "139.766106", url: "/back.jpeg")
    FactoryGirl.create(:area, areaid:  "8", lat: "35.682033", lon: "139.775514", url: "/back.jpeg")
    FactoryGirl.create(:area, areaid:  "9", lat: "35.630372", lon: "139.740364", url: "/back.jpeg")
    FactoryGirl.create(:area, areaid: "10", lat: "35.729139", lon: "139.710348", url: "/back.jpeg")
    FactoryGirl.create(:area, areaid: "11", lat: "35.775815", lon: "140.392473", url: "/back.jpeg")
    FactoryGirl.create(:area, areaid: "12", lat: "35.543991", lon: "139.768744", url: "/back.jpeg")
    FactoryGirl.create(:area, areaid: "13", lat: "34.435031", lon: "135.244226", url: "/back.jpeg")
    FactoryGirl.create(:area, areaid: "14", lat: "33.584829", lon: "130.444292", url: "/back.jpeg")
    FactoryGirl.create(:area, areaid: "15", lat: "34.859319", lon: "136.814591", url: "/back.jpeg")
    FactoryGirl.create(:area, areaid: "16", lat: "34.796149", lon: "138.179726", url: "/back.jpeg")
    FactoryGirl.create(:area, areaid: "17", lat: "42.787467", lon: "141.678402", url: "/back.jpeg")
    
    FactoryGirl.create(:venue, areaId: "1", venueId:  "9686", country: "JP", business: "Shopping Mall", lat: "35.674597", lon: "139.763549", zipCode: "100-0006", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "1", venueId:  "9696", country: "JP", business: "Shopping Mall", lat: "35.673631", lon: "139.763493", zipCode: "100-8488", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "2", venueId:  "3", country: "JP", business: "Shopping Mall", lat: "35.660903", lon: "139.701078", zipCode: "150-0041", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "2", venueId:  "4", country: "JP", business: "Shopping Mall", lat: "35.65862",  lon: "139.701869", zipCode: "150-8319", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "3", venueId:  "5", country: "JP", business: "Shopping Mall", lat: "35.688595", lon: "139.697929", zipCode: "160-0023", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "2", venueId:  "6", country: "JP", business: "Shopping Mall", lat: "35.65955",  lon: "139.699065", zipCode: "150-0043", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "2", venueId:  "7", country: "JP", business: "Shopping Mall", lat: "35.659825", lon: "139.698176", zipCode: "150-0043", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "3", venueId:  "8", country: "JP", business: "Shopping Mall", lat: "35.688595", lon: "139.697929", zipCode: "160-0023", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "2", venueId:  "9", country: "JP", business: "Shopping Mall", lat: "35.65955",  lon: "139.699065", zipCode: "150-0043", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "2", venueId: "10", country: "JP", business: "Shopping Mall", lat: "35.659825", lon: "139.698176", zipCode: "150-0043", imageUrl: "/test.jpeg")
    
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  13680027, name:       "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  13680027, name:     "address", value: "hoge")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  3, name:       "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  3, name:     "address", value: "piyo")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  5, name:       "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  5, name:     "address", value: "fuga")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  7, name:       "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  7, name:     "address", value: "hogera")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  9, name:    "dutyfree", value: "foo")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  9, name: "chconcierge", value: "bar")
    FactoryGirl.create(:attribute, venueId: "5", shopId: 11, name: "chconcierge", value: "baz")
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  13680027, name:    "entrance", value: "http://www.hogehogehoge.com")
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  13680027, name:    "entrance", value: "http://www.fugafugafuga.com")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  7, name:    "entrance", value: "http://www.piyopiyopiyo.com")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  7, name:    "entrance", value: "http://www.hogerahogera.com")
  end
end
