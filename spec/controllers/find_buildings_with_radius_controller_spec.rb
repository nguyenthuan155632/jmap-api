require 'rails_helper'

RSpec.describe FindBuildingsWithRadiusController, :type => :controller do
  
  before(:each) do
    create_dummy
  end

  describe "POST buildings_with_radius" do
    it "とりあえず動作する" do
      post :find_buildings_with_radius
      expect(response.status).to eq(200)
    end
    
    it "正常系（日本語）" do
      post :find_buildings_with_radius, :latitude => "35.672194", :longitude => "139.763954", :radius => "10", :lang => "ja"
      expect(response.status).to eq(200)
      puts(response.body)
      
      expect(response.body).to have_json_path("response")
      expect(response.body).to have_json_path("response/code")
      expect(response.body).to have_json_path("response/message")
      expect(response.body).to have_json_path("response/info")
      expect(response.body).to have_json_path("response/info/building_count")
      expect(response.body).to have_json_path("response/info/building_info")
      expect(response.body).to have_json_path("response/info/building_info/0/id")
      expect(response.body).to have_json_path("response/info/building_info/0/id")
      expect(response.body).to have_json_path("response/info/building_info/0/name")
      expect(response.body).to have_json_path("response/info/building_info/0/exist_duty_free")
      expect(response.body).to have_json_path("response/info/building_info/0/exist_concierge")
      expect(response.body).to have_json_path("response/info/building_info/0/latitude")
      expect(response.body).to have_json_path("response/info/building_info/0/longitude")
      expect(response.body).to have_json_path("response/info/building_info/0/business")
    end
    
    it "正常系（中国語）" do
      post :find_buildings_with_radius, :latitude => "35.672194", :longitude => "139.763954", :radius => "10", :lang => "zh-cn"
      expect(response.status).to eq(200)
      puts(response.body)
      
      expect(response.body).to have_json_path("response")
      expect(response.body).to have_json_path("response/code")
      expect(response.body).to have_json_path("response/message")
      expect(response.body).to have_json_path("response/info")
      expect(response.body).to have_json_path("response/info/building_count")
      expect(response.body).to have_json_path("response/info/building_info")
      expect(response.body).to have_json_path("response/info/building_info/0/id")
      expect(response.body).to have_json_path("response/info/building_info/0/id")
      expect(response.body).to have_json_path("response/info/building_info/0/name")
      expect(response.body).to have_json_path("response/info/building_info/0/exist_duty_free")
      expect(response.body).to have_json_path("response/info/building_info/0/exist_concierge")
      expect(response.body).to have_json_path("response/info/building_info/0/latitude")
      expect(response.body).to have_json_path("response/info/building_info/0/longitude")
      expect(response.body).to have_json_path("response/info/building_info/0/business")
    end
  end
  
  # - - - - - - - - - - - - - - - - - - - -
  # ダミーデータの生成
  # - - - - - - - - - - - - - - - - - - - -
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
    
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  1, name:       "phone", value: "81353390511")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  1, name:     "address", value: "hoge")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  3, name:       "phone", value: "81353390511")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  3, name:     "address", value: "piyo")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  5, name:       "phone", value: "81353390511")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  5, name:     "address", value: "fuga")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  7, name:       "phone", value: "81353390511")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  7, name:     "address", value: "hogera")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  9, name:    "dutyfree", value: "foo")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  9, name: "chconcierge", value: "bar")
    #FactoryGirl.create(:attribute, venueId: "5", shopId: 11, name: "chconcierge", value: "baz")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  5, name:    "entrance", value: "http://www.hogehogehoge.com")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  5, name:    "entrance", value: "http://www.fugafugafuga.com")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  7, name:    "entrance", value: "http://www.piyopiyopiyo.com")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  7, name:    "entrance", value: "http://www.hogerahogera.com")
    
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
    
    FactoryGirl.create(:shop, venueId: "9686", drowingId:  "1", floorId: "39277", shopId: "13680027")
    FactoryGirl.create(:shop, venueId: "9686", drowingId:  "3", floorId: "39277", shopId: "13680204")
    FactoryGirl.create(:shop, venueId: "9686", drowingId:  "5", floorId: "39277", shopId: "13680027")
  end
end
