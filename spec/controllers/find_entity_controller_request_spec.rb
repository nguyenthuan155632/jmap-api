require 'rails_helper'
require 'jmap-i18n/api_client'

RSpec.describe FindEntityController, :type => :controller do
  before(:each) do
      request.env["HTTP_ACCEPT"] = 'application/json'
      create_dummy
    end
  describe "POST find_entity" do
    it "正常系テスト(日本語)23区" do
      post :find_entity, building_id: 9686, search_word: "23区", lang: 'ja'
      puts response.body
      expect(response.status).to eq(200)
      
      json = JSON.parse(response.body)
      
      # response
      response = json["response"]
      expect(response["code"]).to eq(0)
      expect(response["message"]).to eq("取得しました。")
      
      # entity_info_count
      expect(response["entity_info_count"]).to eq(Shop.count)

      # 多言語対応APIを叩く
      jmapi = JmapI18n::ApiClient.new
      names = jmapi.search("23区", type: 'shop', attr: [:name, :icname], lang: 'ja')

      # entity_info
      entity_info = response["entity_info"]
      for items in entity_info do
        name_item = names.find(ifnone = nil){|item| item[:id] == items["shop_id"]}
        expect(items["building_id"]).to  eq(items["building_id"])
        expect(items["floor_id"]).to     eq(Shop.find_by(venueId: items["building_id"], floorId: items["floor_id"]).floorId)
        expect(items["shop_id"]).to      eq(Shop.find_by(venueId: items["building_id"], shopId: items["shop_id"]).shopId)
        expect(items["drowing_id"]).to   eq(Shop.find_by(venueId: items["building_id"], drowingId: items["drowing_id"]).drowingId)
        expect(items["shop_name"]).to    eq(name_item[:attrs][:name].presence || '')
        expect(items["icon_name"]).to    eq(name_item[:attrs][:icname].presence || '')
        expect(items["shop_image"]).to    eq(getShopImage(items["shop_id"]).presence || '')
        expect(items["shop_category"]).to    eq(getCategory(items["shop_id"],'ja').presence || '')
      end
    end
    
    it "正常系テスト(中国語)" do
      post :find_entity, building_id: 9686, search_word: "23", lang: 'zh-cn'
      puts response.body
      expect(response.status).to eq(200)
      
      json = JSON.parse(response.body)
      
      # response
      response = json["response"]
      expect(response["code"]).to eq(0)
      expect(response["message"]).to eq("取得しました。")
      
      # entity_info_count
      #expect(response["entity_info_count"]).to eq(Shop.count)
      expect(response["entity_info_count"]).to eq(3)

      # 多言語対応APIを叩く
      jmapi = JmapI18n::ApiClient.new
      names = jmapi.search("23", type: 'shop', attr: [:name, :icname], lang: 'zh-cn')

      # entity_info
      entity_info = response["entity_info"]
      for items in entity_info do
        name_item = names.find(ifnone = nil){|item| item[:id] == items["shop_id"]}
        expect(items["building_id"]).to  eq(items["building_id"])
        expect(items["floor_id"]).to     eq(Shop.find_by(venueId: items["building_id"], floorId: items["floor_id"]).floorId)
        expect(items["shop_id"]).to      eq(Shop.find_by(venueId: items["building_id"], shopId: items["shop_id"]).shopId)
        expect(items["drowing_id"]).to   eq(Shop.find_by(venueId: items["building_id"], drowingId: items["drowing_id"]).drowingId)
        expect(items["shop_name"]).to    eq(name_item[:attrs][:name].presence || '')
        expect(items["icon_name"]).to    eq(name_item[:attrs][:icname].presence || '')
        expect(items["shop_image"]).to    eq(getShopImage(items["shop_id"]).presence || '')
        expect(items["shop_category"]).to    eq(getCategory(items["shop_id"],'zh-cn').presence || '')
      end
    end
    
    it "出力言語指定コードが未入力" do
      post :find_entity, building_id: 5, search_word: "中国"
      expect(response.status).to eq(200)
      
      json = JSON.parse(response.body)
      
      # response
      response = json["response"]
      expect(response["code"]).to eq(0)
      expect(response["message"]).to eq("取得しました。")
      expect(response["entity_info_count"]).to eq(0)
      expect(response["entity_info"]).to eq([])
    end
    
    it "検索ワードが未入力" do
      post :find_entity, building_id: 5, lang: "ja"
      expect(response.status).to eq(200)
      
      json = JSON.parse(response.body)
      
      # response
      response = json["response"]
      expect(response["code"]).to eq(101)
      expect(response["message"]).to eq("search_wordが未入力です。")
      expect(response["entity_info_count"]).to eq(0)
      expect(response["entity_info"]).to eq([])
    end

    it "building_idが未入力" do
      post :find_entity, search_word: '日本', lang: "ja"
      expect(response.status).to eq(200)
      
      json = JSON.parse(response.body)
      
      # response
      response = json["response"]
      expect(response["code"]).to eq(101)
      expect(response["message"]).to eq("building_idが未入力です。")
      expect(response["entity_info_count"]).to eq(0)
      expect(response["entity_info"]).to eq([])
    end
  end
    
  private
  def create_dummy
    #FactoryGirl.create(:area, areaid:  "1", lat: "35.672194", lon: "139.763954", url: "/back.jpeg")
    #FactoryGirl.create(:area, areaid:  "2", lat: "35.658517", lon: "139.701334", url: "/back.jpeg")
    #FactoryGirl.create(:area, areaid:  "3", lat: "35.690921", lon: "139.700258", url: "/back.jpeg")
    #FactoryGirl.create(:area, areaid:  "4", lat: "35.698972", lon: "139.774773", url: "/back.jpeg")
    #FactoryGirl.create(:area, areaid:  "5", lat: "35.713981", lon: "139.777265", url: "/back.jpeg")
    #FactoryGirl.create(:area, areaid:  "6", lat: "35.627991", lon: "139.778554", url: "/back.jpeg")
    #FactoryGirl.create(:area, areaid:  "7", lat: "35.681594", lon: "139.766106", url: "/back.jpeg")
    #FactoryGirl.create(:area, areaid:  "8", lat: "35.682033", lon: "139.775514", url: "/back.jpeg")
    #FactoryGirl.create(:area, areaid:  "9", lat: "35.630372", lon: "139.740364", url: "/back.jpeg")
    #FactoryGirl.create(:area, areaid: "10", lat: "35.729139", lon: "139.710348", url: "/back.jpeg")
    #FactoryGirl.create(:area, areaid: "11", lat: "35.775815", lon: "140.392473", url: "/back.jpeg")
    #FactoryGirl.create(:area, areaid: "12", lat: "35.543991", lon: "139.768744", url: "/back.jpeg")
    #FactoryGirl.create(:area, areaid: "13", lat: "34.435031", lon: "135.244226", url: "/back.jpeg")
    #FactoryGirl.create(:area, areaid: "14", lat: "33.584829", lon: "130.444292", url: "/back.jpeg")
    #FactoryGirl.create(:area, areaid: "15", lat: "34.859319", lon: "136.814591", url: "/back.jpeg")
    #FactoryGirl.create(:area, areaid: "16", lat: "34.796149", lon: "138.179726", url: "/back.jpeg")
    #FactoryGirl.create(:area, areaid: "17", lat: "42.787467", lon: "141.678402", url: "/back.jpeg")
    
    #FactoryGirl.create(:venue, areaId: "1", venueId: "1", country: "JP", business: "Shopping Mall", lat: "35.674597", lon: "139.763549", zipCode: "100-0006", imageUrl: "/test.jpeg")
    #FactoryGirl.create(:venue, areaId: "1", venueId: "2", country: "JP", business: "Shopping Mall", lat: "35.673631", lon: "139.763493", zipCode: "100-8488", imageUrl: "/test.jpeg")
    #FactoryGirl.create(:venue, areaId: "2", venueId: "3", country: "JP", business: "Shopping Mall", lat: "35.660903", lon: "139.701078", zipCode: "150-0041", imageUrl: "/test.jpeg")
    #FactoryGirl.create(:venue, areaId: "2", venueId: "4", country: "JP", business: "Shopping Mall", lat: "35.65862",  lon: "139.701869", zipCode: "150-8319", imageUrl: "/test.jpeg")
    #FactoryGirl.create(:venue, areaId: "3", venueId: "5", country: "JP", business: "Shopping Mall", lat: "35.688595", lon: "139.697929", zipCode: "160-0023", imageUrl: "/test.jpeg")
    #FactoryGirl.create(:venue, areaId: "2", venueId: "6", country: "JP", business: "Shopping Mall", lat: "35.65955",  lon: "139.699065", zipCode: "150-0043", imageUrl: "/test.jpeg")
    #FactoryGirl.create(:venue, areaId: "2", venueId: "7", country: "JP", business: "Shopping Mall", lat: "35.659825", lon: "139.698176", zipCode: "150-0043", imageUrl: "/test.jpeg")
    
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  "1", name: "phone", value: "81353390511")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  "1", name: "icname", value: "hoge")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  "3", name: "phone", value: "81353390511")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  "3", name: "icname", value: "piyo")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  "5", name: "phone", value: "81353390511")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  "5", name: "icname", value: "fuga")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  "7", name: "phone", value: "81353390511")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  "7", name: "icname", value: "hogera")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  "9", name: "dutyfree", value: "foo")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  "9", name: "chconcierge", value: "bar")
    #FactoryGirl.create(:attribute, venueId: "5", shopId: "11", name: "chconcierge", value: "baz")
    
    #actoryGirl.create(:shop, venueId: "5", drowingId:  "1", floorId: "39277", shopId: "1")
    #FactoryGirl.create(:shop, venueId: "5", drowingId:  "1", floorId: "39277", shopId: "2")
    #FactoryGirl.create(:shop, venueId: "5", drowingId:  "3", floorId: "39277", shopId: "3")
    #FactoryGirl.create(:shop, venueId: "5", drowingId:  "3", floorId: "39277", shopId: "4")
    #FactoryGirl.create(:shop, venueId: "5", drowingId:  "5", floorId: "39277", shopId: "5")
    #FactoryGirl.create(:shop, venueId: "5", drowingId:  "5", floorId: "39277", shopId: "6")
    #FactoryGirl.create(:shop, venueId: "5", drowingId:  "7", floorId: "39277", shopId: "7")
    #FactoryGirl.create(:shop, venueId: "5", drowingId:  "7", floorId: "39277", shopId: "8")
    #FactoryGirl.create(:shop, venueId: "5", drowingId:  "9", floorId: "39277", shopId: "9")
    #FactoryGirl.create(:shop, venueId: "5", drowingId:  "9", floorId: "39277", shopId: "10")
    
   
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
    
    FactoryGirl.create(:venue, areaId: "1", venueId: "9686", country: "JP", business: "Shopping Mall", lat: "35.674597", lon: "139.763549", zipCode: "100-0006", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "1", venueId: "9696", country: "JP", business: "Shopping Mall", lat: "35.673631", lon: "139.763493", zipCode: "100-8488", imageUrl: "/test.jpeg")
    
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  "13680027", name: "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  "13680204", name: "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  "13680027", name: "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  "13680027", name: "image", value: "image.jpeg")
    
    FactoryGirl.create(:shop, venueId: "9686", drowingId:  "1", floorId: "39277", shopId: "13680027")
    FactoryGirl.create(:shop, venueId: "9686", drowingId:  "3", floorId: "39277", shopId: "13680204")
    FactoryGirl.create(:shop, venueId: "9686", drowingId:  "5", floorId: "39277", shopId: "13680027")
  end
  
  private
  def getShopImage(shopId)
    ret = nil
    attributes = Attribute.where(shopId: shopId,name: 'image')
    if attributes.presence then
      ret = attributes[0].value
    end 
    return ret
  end
  private
  def getCategory(shopId,lang)
    ret = nil
    jmapi = JmapI18n::ApiClient.new
    data = jmapi.get({type: 'shop', id: shopId ,attr: 'category' , lang: lang})
    if data.presence then
      ret = data[0][:attrs][:category]
    end
    return ret    
  end
end
