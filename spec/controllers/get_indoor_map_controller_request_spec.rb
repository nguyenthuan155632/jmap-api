require 'rails_helper'

RSpec.describe GetIndoorMapController, :type => :controller do
  
  before(:each) do
    request.env["HTTP_ACCEPT"] = 'application/json'
    create_dummy
  end

  describe "GET get_indoor_map" do
    it "正常系（日本語）" do
      lang = "ja"
      building_id = "9686"
      post :get_indoor_map, :lang => lang, :building_id => building_id
      expect(response.status).to eq(200)
      puts response.body
      
      json = JSON.parse(response.body)
      expect(json["response"]["code"]).to    eq(0)
      expect(json["response"]["message"]).to eq("取得しました。")
      
      jmapi      = JmapI18n::ApiClient.new
      lang_array = jmapi.get(type: "shop", lang: lang)
      
      shop_info = json["response"]["info"]["shop_info"]
      for d_item in shop_info do
        category_id = CategorySet.find_by(shopId: d_item["shop_id"]).category_id
        expect(d_item["shop_id"]).to            eq(d_item["shop_id"])
        expect(d_item["shop_name"]).to          eq(lang_array.find{|item| item[:id] == d_item["shop_id"]}[:attrs][:name])
        expect(d_item["shop_name"]).to          eq(shop_data[0][:attrs][:name])
        expect(d_item["floor_id"]).to           eq(Shop.find_by(shopId: d_item["shop_id"]).floorId)
        expect(d_item["category_parentId"]).to  eq(CategoryMaster.find_by(category_id: category_id).category_parentId)
        expect(d_item["category_id"]).to        eq(category_id)
      end
      
      duty_free_info = json["response"]["info"]["duty_free_info"]
      for d_item in duty_free_info do
        expect(d_item["duty_free_name"]).to        eq(lang_array.find{|item| item[:id] == d_item["duty_free_id"]}[:attrs][:name])
        expect(d_item["duty_free_description"]).to eq(lang_array.find{|item| item[:id] == d_item["duty_free_id"]}[:attrs][:dutyfree])
      end
      
      concierge_info = json["response"]["info"]["concierge_info"]
      for d_item in concierge_info do
        expect(d_item["concierge_name"]).to        eq(lang_array.find{|item| item[:id] == d_item["concierge_id"]}[:attrs][:name])
        expect(d_item["concierge_description"]).to eq(lang_array.find{|item| item[:id] == d_item["concierge_id"]}[:attrs][:chconcierge])
      end
    end
    
    it "正常系（中国語）" do
      lang = "zh-cn"
      building_id = "9686"
      post :get_indoor_map, :lang => lang, :building_id => building_id
      expect(response.status).to eq(200)
      
      json = JSON.parse(response.body)
      expect(json["response"]["code"]).to    eq(0)
      expect(json["response"]["message"]).to eq("取得しました。")
      
      jmapi      = JmapI18n::ApiClient.new
      lang_array = jmapi.get(type: "shop", lang: lang)
      
      shop_info = json["response"]["info"]["shop_info"]
      for d_item in shop_info do
        category_id = CategorySet.find_by(shopId: d_item["shop_id"]).category_id
        expect(d_item["shop_id"]).to            eq(d_item["shop_id"])
        expect(d_item["shop_name"]).to          eq(lang_array.find{|item| item[:id] == d_item["shop_id"]}[:attrs][:name])
        expect(d_item["floor_id"]).to           eq(Shop.find_by(shopId: d_item["shop_id"]).floorId)
        expect(d_item["category_parentId"]).to  eq(CategoryMaster.find_by(category_id: category_id).category_parentId)
        expect(d_item["category_id"]).to        eq(category_id)
      end
      
      duty_free_info = json["response"]["info"]["duty_free_info"]
      for d_item in duty_free_info do
        expect(d_item["duty_free_name"]).to        eq(lang_array.find{|item| item[:id] == d_item["duty_free_id"]}[:attrs][:name])
        expect(d_item["duty_free_description"]).to eq(lang_array.find{|item| item[:id] == d_item["duty_free_id"]}[:attrs][:dutyfree])
      end
      
      concierge_info = json["response"]["info"]["concierge_info"]
      for d_item in concierge_info do
        expect(d_item["concierge_name"]).to        eq(lang_array.find{|item| item[:id] == d_item["concierge_id"]}[:attrs][:name])
        expect(d_item["concierge_description"]).to eq(lang_array.find{|item| item[:id] == d_item["concierge_id"]}[:attrs][:chconcierge])
      end
    end
    
    #入力チェックを削除にしたのでテストコードも削除する
    #it "異常系（出力言語の指定なし）" do
    #  lang = ""
    #  building_id = "9686"
    #  post :get_indoor_map, :building_id => building_id
    #  expect(response.status).to eq(200)
    #  
    #  json = JSON.parse(response.body)
    #  expect(json["response"]["code"]).to    eq(501)
    #  expect(json["response"]["message"]).to eq("DB処理に失敗しました。")
    #end
    
    #it "異常系（出力言語の指定が不正）" do
    #  lang = "hoge"
    #  building_id = "9686"
    #  post :get_indoor_map, :lang => lang, :building_id => building_id
    #  expect(response.status).to eq(200)
    #  
    #  json = JSON.parse(response.body)
    #  expect(json["response"]["code"]).to    eq(501)
    #  expect(json["response"]["message"]).to eq("DB処理に失敗しました。")
    #end
    
    it "異常系（idの値が不正）" do
      lang = "ja"
      building_id = "hoge"
      post :get_indoor_map, :lang => lang, :building_id => building_id
      expect(response.status).to eq(200)
      
      json = JSON.parse(response.body)
      expect(json["response"]["code"]).to    eq(101)
      expect(json["response"]["message"]).to eq("施設IDが入力されておりません。")
    end
    
    it "異常系（idの値なし）" do
      lang = "ja"
      building_id = "hoge"
      post :get_indoor_map, :lang => lang
      expect(response.status).to eq(200)
      
      json = JSON.parse(response.body)
      expect(json["response"]["code"]).to    eq(101)
      expect(json["response"]["message"]).to eq("施設IDが入力されておりません。")
    end
  end
  
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
    
    FactoryGirl.create(:attribute, venueId: "5", shopId:  1, name:       "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  1, name:     "address", value: "hoge")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  3, name:       "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  3, name:     "address", value: "piyo")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  5, name:       "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  5, name:     "address", value: "fuga")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  7, name:       "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  7, name:     "address", value: "hogera")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  9, name:    "dutyfree", value: "foo")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  9, name: "chconcierge", value: "bar")
    FactoryGirl.create(:attribute, venueId: "5", shopId: 11, name: "chconcierge", value: "baz")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  5, name:    "entrance", value: "http://www.hogehogehoge.com")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  5, name:    "entrance", value: "http://www.fugafugafuga.com")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  7, name:    "entrance", value: "http://www.piyopiyopiyo.com")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  7, name:    "entrance", value: "http://www.hogerahogera.com")
    
    FactoryGirl.create(:shop, venueId: "9686", shopId:  "13680027", drowingId: "0", floorId: "0")
    FactoryGirl.create(:shop, venueId: "5", shopId:  "2", drowingId: "0", floorId: "0")
    FactoryGirl.create(:shop, venueId: "5", shopId:  "3", drowingId: "0", floorId: "0")
    FactoryGirl.create(:shop, venueId: "5", shopId:  "4", drowingId: "0", floorId: "0")
    FactoryGirl.create(:shop, venueId: "5", shopId:  "5", drowingId: "0", floorId: "0")
    FactoryGirl.create(:shop, venueId: "5", shopId:  "6", drowingId: "0", floorId: "0")
    FactoryGirl.create(:shop, venueId: "5", shopId:  "7", drowingId: "0", floorId: "0")
    FactoryGirl.create(:shop, venueId: "5", shopId:  "8", drowingId: "0", floorId: "0")
    FactoryGirl.create(:shop, venueId: "5", shopId:  "9", drowingId: "0", floorId: "0")
    FactoryGirl.create(:shop, venueId: "5", shopId: "10", drowingId: "0", floorId: "0")
    FactoryGirl.create(:shop, venueId: "5", shopId: "11", drowingId: "0", floorId: "0")
    FactoryGirl.create(:shop, venueId: "5", shopId: "12", drowingId: "0", floorId: "0")
    FactoryGirl.create(:shop, venueId: "5", shopId: "13", drowingId: "0", floorId: "0")
    FactoryGirl.create(:shop, venueId: "5", shopId: "14", drowingId: "0", floorId: "0")
    FactoryGirl.create(:shop, venueId: "5", shopId: "15", drowingId: "0", floorId: "0")
  end
end
