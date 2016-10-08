require 'rails_helper'

RSpec.describe FindBuildingsWithRadiusController, :type => :controller do
  
  before(:each) do
    request.env["HTTP_ACCEPT"] = 'application/json'
    create_dummy
  end

  describe "POST buildings_with_radius" do
    it "正常系（日本語）" do
      lang = 'ja'
      latitude = "35.672194"
      longitude = "139.763954"
      radius = "10"
      post :find_buildings_with_radius, :latitude => "35.672194", :longitude => "139.763954", :radius => "10", :lang => lang, :category => "", :icon => ""
      expect(response.status).to eq(200)
      puts(response.body)
      
      json = JSON.parse(response.body)
      expect(json["response"]["code"]).to    eq(0)
      expect(json["response"]["message"]).to eq("取得しました。")
      
      jmapi      = JmapI18n::ApiClient.new
      lang_array = jmapi.get(type: "venue", lang: lang)

      # 施設情報を全件取得
      venues = Venue.all

      # 施設情報用の配列
      building_info = Array.new

      a_lat = Float(latitude)
      a_lng = Float(longitude)
      rad = Float(radius)
    
      for venue in venues do
        b_lat    = Float(venue.lat)
        b_lng    = Float(venue.lon)
        distance = calc_distance(a_lat, a_lng, b_lat, b_lng)

        # 二点間の距離が、指定された半径以下ならば配列にセット
        if distance <= rad then
          building_info << create_building_info(venue, lang_array)
        end
      end
      expect(json["response"]["info"]["building_count"]).to eq(building_info.count)
      building_info = json["response"]["info"]["building_info"]

      for building in building_info do
        lang_item = lang_array.find(ifnone = nil){|item| item[:id] == building["id"]}
        expect(building["id"]).to               eq(building["id"])
        expect(building["name"]).to             eq(lang_item[:attrs][:name])
        expect(building["exist_duty_free"]).to  eq(boolean_to_binary(Attribute.exists?(venueId: building["id"], name: "dutyfree")))
        expect(building["exist_concierge"]).to  eq(boolean_to_binary(Attribute.exists?(venueId: building["id"], name: "chconcierge")))
        expect(building["business"]).to         eq(building["business"])
        expect(building["zip"]).to              eq(Venue.find_by(venueId: building["id"]).zipCode)
        expect(building["address"]).to          eq(lang_item[:attrs][:address])
        expect(building["content"]).to          eq(lang_item[:attrs].has_key?(:content) ? lang_item[:attrs][:content] : '')
        expect(building["url"]).to              eq(Venue.find_by(venueId: building["id"]).officialUrl)
      end
    end
    
    it "正常系（中国語）" do
      lang = 'zh-cn'
      latitude = "35.672194"
      longitude = "139.763954"
      radius = "10"
      post :find_buildings_with_radius, :latitude => "35.672194", :longitude => "139.763954", :radius => "10", :lang => lang, :category => "", :icon => ""
      expect(response.status).to eq(200)
      puts(response.body)
      
      json = JSON.parse(response.body)
      expect(json["response"]["code"]).to    eq(0)
      expect(json["response"]["message"]).to eq("取得しました。")
      
      jmapi      = JmapI18n::ApiClient.new
      lang_array = jmapi.get(type: "venue", lang: lang)

      # 施設情報を全件取得
      venues = Venue.all

      a_lat = Float(latitude)
      a_lng = Float(longitude)
      rad = Float(radius)

      # 施設情報用の配列
      building_info = Array.new

      for venue in venues do
        b_lat    = Float(venue.lat)
        b_lng    = Float(venue.lon)
        distance = calc_distance(a_lat, a_lng, b_lat, b_lng)

        # 二点間の距離が、指定された半径以下ならば配列にセット
        if distance <= rad then
          building_info << create_building_info(venue, lang_array)
        end
      end
      expect(json["response"]["info"]["building_count"]).to eq(building_info.count)
      building_info = json["response"]["info"]["building_info"]

      for building in building_info do
        lang_item = lang_array.find(ifnone = nil){|item| item[:id] == building["id"]}
        expect(building["id"]).to               eq(building["id"])
        expect(building["name"]).to             eq(lang_item[:attrs][:name])
        expect(building["exist_duty_free"]).to  eq(boolean_to_binary(Attribute.exists?(venueId: building["id"], name: "dutyfree")))
        expect(building["exist_concierge"]).to  eq(boolean_to_binary(Attribute.exists?(venueId: building["id"], name: "chconcierge")))
        expect(building["business"]).to         eq(building["business"])
        expect(building["zip"]).to              eq(Venue.find_by(venueId: building["id"]).zipCode)
        expect(building["address"]).to          eq(lang_item[:attrs][:address])
        expect(building["content"]).to          eq(lang_item[:attrs].has_key?(:content) ? lang_item[:attrs][:content] : '')
        expect(building["url"]).to              eq(Venue.find_by(venueId: building["id"]).officialUrl)
      end
    end
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
    
    FactoryGirl.create(:venue, areaId: "1", venueId: "9686", country: "JP", business: "Shopping Mall", lat: "35.674597", lon: "139.763549", zipCode: "100-0006", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "1", venueId: "9696", country: "JP", business: "Shopping Mall", lat: "35.673631", lon: "139.763493", zipCode: "100-8488", imageUrl: "/test.jpeg")
    #FactoryGirl.create(:venue, areaId: "2", venueId: "3", country: "JP", business: "Shopping Mall", lat: "35.660903", lon: "139.701078", zipCode: "150-0041", imageUrl: "/test.jpeg")
    #FactoryGirl.create(:venue, areaId: "2", venueId: "4", country: "JP", business: "Shopping Mall", lat: "35.65862",  lon: "139.701869", zipCode: "150-8319", imageUrl: "/test.jpeg")
    #FactoryGirl.create(:venue, areaId: "3", venueId: "5", country: "JP", business: "Shopping Mall", lat: "35.688595", lon: "139.697929", zipCode: "160-0023", imageUrl: "/test.jpeg")
    #FactoryGirl.create(:venue, areaId: "2", venueId: "6", country: "JP", business: "Shopping Mall", lat: "35.65955",  lon: "139.699065", zipCode: "150-0043", imageUrl: "/test.jpeg")
    #FactoryGirl.create(:venue, areaId: "2", venueId: "7", country: "JP", business: "Shopping Mall", lat: "35.659825", lon: "139.698176", zipCode: "150-0043", imageUrl: "/test.jpeg")
    
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  13680027, name: "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  13680027, name: "icname", value: "hoge")
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  13680204, name: "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  13680204, name: "icname", value: "piyo")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  13680027, name: "phone", value: "81353390511")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  13680027, name: "icname", value: "fuga")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  7, name: "phone", value: "81353390511")
    #FactoryGirl.create(:attribute, venueId: "5", shopId:  7, name: "icname", value: "hogera")
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  13680027, name: "dutyfree", value: "foo")
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  13680027, name: "chconcierge", value: "bar")
    FactoryGirl.create(:attribute, venueId: "9686", shopId: 13680204, name: "chconcierge", value: "baz")
  end
  
  private
  def calc_distance(a_lat, a_lng, b_lat, b_lng)
    # 赤道半径[km]
    r = 6378.137
  
    # 引数の値をdigree角からradian角へ
    a_latr = dig_to_rad(a_lat)
    b_latr = dig_to_rad(b_lat)
    a_lngr = dig_to_rad(a_lng)
    b_lngr = dig_to_rad(b_lng)

    # 2点間の距離を計算
    cosine = Math::acos((Math::sin(a_latr) * Math::sin(b_latr)) + (Math::cos(a_latr) * Math::cos(b_latr) * Math::cos(b_lngr - a_lngr)))
    distance = r * cosine
  
    # 返り値を設定
    return distance
  end
  
  # - - - - - - - - - - - - - - - - - - - -
  # degree角をradian角に変換する
  # - - - - - - - - - - - - - - - - - - - -
  def dig_to_rad(dig)
    rad = (dig * Math::PI) / 180.0
    return rad 
  end

  # - - - - - - - - - - - - - - - - - - - -
  # true,falseを1,0に変換する
  # - - - - - - - - - - - - - - - - - - - -
  def boolean_to_binary(bool)
    res = if bool then
      1
    else
      0
    end
    return res
  end
  
  def create_building_info(venue, lang_array)
    lang_item = lang_array.find(ifnone = nil){|item| item[:id] == venue.venueId}

    item = {
      id:              venue.venueId,
      name:            lang_item[:attrs][:name],
      exist_duty_free: boolean_to_binary(Attribute.exists?(venueId: venue.venueId, name: "dutyfree")),
      exist_concierge: boolean_to_binary(Attribute.exists?(venueId: venue.venueId, name: "chconcierge"))
    }
    return item
  end
  def boolean_to_binary(bool)
    res = if bool then
      1
    else
      0
    end
    return res
  end
end
