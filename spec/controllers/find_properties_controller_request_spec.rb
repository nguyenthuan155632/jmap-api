require 'rails_helper'

RSpec.describe FindPropertiesController, :type => :controller do
  before(:each) do
      request.env["HTTP_ACCEPT"] = 'application/json'
      create_dummy
    end
  describe "POST find_entity" do
    it "正常系テスト(日本語)" do
      post :find_properties, entity_id: 13680027, lang: 'ja'
      puts response.body
      expect(response.status).to eq(200)
      
      json = JSON.parse(response.body)
      
      # response
      response = json["response"]
      expect(response["code"]).to eq(0)
      expect(response["message"]).to eq("取得しました。")
      
      # 多言語対応APIを叩く
      jmapi = JmapI18n::ApiClient.new
      shop_attr = jmapi.get(type: "shop", id: 13680027, lang: 'ja')

      # attrsの要素を取得
      shop_attr_item = shop_attr[0][:attrs].stringify_keys

      items = response["entity_properties"]

      # entity_properties
      #entity_property = response["entity_properties"]
      #for items in entity_property do
        #expect(items["property_name"]).to   eq(Attribute.find_by(shopId: 5, name: items["property_name"]).name)
        #if items["property_name"] == 'phone' then
        #  expect(items["property_value"]).to  eq(Attribute.find_by(venueId: 5, shopId: 5, name: 'phone').value)
        #elsif items["property_name"] == 'email' then
        #  expect(items["property_value"]).to  eq(Attribute.find_by(venueId: 5, shopId: 5, name: 'email').value)
        #elsif items["property_name"] == 'url' then
        #  expect(items["property_value"]).to  eq(Attribute.find_by(venueId: 5, shopId: 5, name: 'url').value)
        #elsif items["property_name"] == 'entrance' then
        #  expect(items["property_value"]).to  eq(Attribute.find_by(venueId: 5, shopId: 5, name: 'entrance').value)
        #else
        #  expect(items["property_value"]).to  eq(shop_attr_item[items["property_name"]])
        #end
        
        if items["phone"].present?
          expect(items["phone"]).to  eq(Attribute.find_by(venueId: 5, shopId: 5, name: 'phone').value)
        end
        if items["email"].present?
          expect(items["email"]).to  eq(Attribute.find_by(venueId: 5, shopId: 5, name: 'email').value)
        end
        if items["url"].present?
          expect(items["url"]).to  eq(Attribute.find_by(venueId: 5, shopId: 5, name: 'url').value)
        end
        if items["entrance"].present?
          expect(items["entrance"]).to  eq(Attribute.find_by(venueId: 5, shopId: 5, name: 'entrance').value)
        end

        
      #end
    end
    
    it "正常系テスト(中国語)" do
      post :find_properties, entity_id: 13680027, lang: 'zh-cn'
      puts response.body
      expect(response.status).to eq(200)
      
      json = JSON.parse(response.body)
      
      # response
      response = json["response"]
      expect(response["code"]).to eq(0)
      expect(response["message"]).to eq("取得しました。")
      
      # 多言語対応APIを叩く
      jmapi = JmapI18n::ApiClient.new
      shop_attr = jmapi.get(type: "shop", id: 13680027, lang: 'zh-cn')

      # attrsの要素を取得
      shop_attr_item = shop_attr[0][:attrs].stringify_keys

      items = response["entity_properties"]

      # entity_properties
      #entity_property = response["entity_properties"]
      #for items in entity_property do
        #expect(items["property_name"]).to   eq(Attribute.find_by(shopId: 5, name: items["property_name"]).name)
        #if items["property_name"] == 'phone' then
        #  expect(items["property_value"]).to  eq(Attribute.find_by(venueId: 5, shopId: 5, name: 'phone').value)
        #elsif items["property_name"] == 'email' then
        #  expect(items["property_value"]).to  eq(Attribute.find_by(venueId: 5, shopId: 5, name: 'email').value)
        #elsif items["property_name"] == 'url' then
        #  expect(items["property_value"]).to  eq(Attribute.find_by(venueId: 5, shopId: 5, name: 'url').value)
        #elsif items["property_name"] == 'entrance' then
        #  expect(items["property_value"]).to  eq(Attribute.find_by(venueId: 5, shopId: 5, name: 'entrance').value)
        #else
        #  expect(items["property_value"]).to  eq(shop_attr_item[items["property_name"]])
        #end
        
        if items["phone"].present?
          expect(items["phone"]).to  eq(Attribute.find_by(venueId: 5, shopId: 5, name: 'phone').value)
        end
        if items["email"].present?
          expect(items["email"]).to  eq(Attribute.find_by(venueId: 5, shopId: 5, name: 'email').value)
        end
        if items["url"].present?
          expect(items["url"]).to  eq(Attribute.find_by(venueId: 5, shopId: 5, name: 'url').value)
        end
        if items["entrance"].present?
          expect(items["entrance"]).to  eq(Attribute.find_by(venueId: 5, shopId: 5, name: 'entrance').value)
        end

      #end
    end
    
    it "出力言語指定コードが未入力" do
      post :find_properties, entity_id: 13680027
      expect(response.status).to eq(200)
      
      json = JSON.parse(response.body)
      
      # response
      response = json["response"]
      expect(response["code"]).to eq(0)
      expect(response["message"]).to eq("取得しました。")
      #expect(response["entity_properties"]).to eq([])
    end
    
    it "entity_idが未入力" do
      post :find_properties, lang: 'zh-cn'
      expect(response.status).to eq(200)
      
      json = JSON.parse(response.body)
      
      # response
      response = json["response"]
      expect(response["code"]).to eq(101)
      expect(response["message"]).to eq("IDが未入力です。")
      expect(response["entity_properties"]).to eq([])
    end

    it "entity_idが不正値" do
      post :find_properties, entity_id: '日本', lang: "ja"
      expect(response.status).to eq(200)
      
      json = JSON.parse(response.body)
      
      # response
      response = json["response"]
      expect(response["code"]).to eq(101)
      expect(response["message"]).to eq("IDの値が不正です。")
      expect(response["entity_properties"]).to eq([])
    end
  end
    
  private
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
    
    FactoryGirl.create(:venue, areaId: "1", venueId: "9686", country: "JP", business: "Shopping Mall", lat: "35.674597", lon: "139.763549", zipCode: "100-0006", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "1", venueId: "2", country: "JP", business: "Shopping Mall", lat: "35.673631", lon: "139.763493", zipCode: "100-8488", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "2", venueId: "3", country: "JP", business: "Shopping Mall", lat: "35.660903", lon: "139.701078", zipCode: "150-0041", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "2", venueId: "4", country: "JP", business: "Shopping Mall", lat: "35.65862",  lon: "139.701869", zipCode: "150-8319", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "3", venueId: "5", country: "JP", business: "Shopping Mall", lat: "35.688595", lon: "139.697929", zipCode: "160-0023", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "2", venueId: "6", country: "JP", business: "Shopping Mall", lat: "35.65955",  lon: "139.699065", zipCode: "150-0043", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "2", venueId: "7", country: "JP", business: "Shopping Mall", lat: "35.659825", lon: "139.698176", zipCode: "150-0043", imageUrl: "/test.jpeg")
    
    FactoryGirl.create(:attribute, venueId: "9686", shopId: "13680027", name: "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "9686", shopId: "13680027", name: "email", value: "abcde@example.jp")
    FactoryGirl.create(:attribute, venueId: "9686", shopId: "13680027", name: "url", value: "http://test.co.jp")
    FactoryGirl.create(:attribute, venueId: "9686", shopId: "13680027", name: "entrance", value: "http://aaa/bbb.jpg")
    FactoryGirl.create(:attribute, venueId: "9686", shopId: "13680027", name: "name", value: "")
    FactoryGirl.create(:attribute, venueId: "9686", shopId: "13680027", name: "icname", value: "")
    FactoryGirl.create(:attribute, venueId: "9686", shopId: "13680027", name: "address", value: "")
    FactoryGirl.create(:attribute, venueId: "9686", shopId: "13680027", name: "hours", value: "")
    FactoryGirl.create(:attribute, venueId: "9686", shopId: "13680027", name: "dutyfree", value: "")
    FactoryGirl.create(:attribute, venueId: "9686", shopId: "13680027", name: "chconcierge", value: "")
    FactoryGirl.create(:attribute, venueId: "9686", shopId: "13680027", name: "chstaff", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "2", name: "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "2", name: "email", value: "abcde@example.jp")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "2", name: "url", value: "http://test.co.jp")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "2", name: "entrance", value: "http://aaa/bbb.jpg")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "2", name: "name", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "2", name: "icname", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "2", name: "address", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "2", name: "hours", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "2", name: "dutyfree", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "2", name: "chconcierge", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "2", name: "chstaff", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "3", name: "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "3", name: "email", value: "abcde@example.jp")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "3", name: "url", value: "http://test.co.jp")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "3", name: "entrance", value: "http://aaa/bbb.jpg")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "3", name: "name", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "3", name: "icname", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "3", name: "address", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "3", name: "hours", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "3", name: "dutyfree", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "3", name: "chconcierge", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "3", name: "chstaff", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "4", name: "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "4", name: "email", value: "abcde@example.jp")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "4", name: "url", value: "http://test.co.jp")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "4", name: "entrance", value: "http://aaa/bbb.jpg")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "4", name: "name", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "4", name: "icname", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "4", name: "address", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "4", name: "hours", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "4", name: "dutyfree", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "4", name: "chconcierge", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "4", name: "chstaff", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "5", name: "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "5", name: "email", value: "abcde@example.jp")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "5", name: "url", value: "http://test.co.jp")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "5", name: "entrance", value: "http://aaa/bbb.jpg")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "5", name: "name", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "5", name: "icname", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "5", name: "address", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "5", name: "hours", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "5", name: "dutyfree", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "5", name: "chconcierge", value: "")
    FactoryGirl.create(:attribute, venueId: "5", shopId: "5", name: "chstaff", value: "")
    
    FactoryGirl.create(:shop, venueId: "9686", drowingId:  "1", floorId: "39277", shopId: "13680027")
    FactoryGirl.create(:shop, venueId: "5", drowingId:  "1", floorId: "39277", shopId: "2")
    FactoryGirl.create(:shop, venueId: "5", drowingId:  "3", floorId: "39277", shopId: "3")
    FactoryGirl.create(:shop, venueId: "5", drowingId:  "3", floorId: "39277", shopId: "4")
    FactoryGirl.create(:shop, venueId: "5", drowingId:  "4", floorId: "39277", shopId: "5")
  end
end
