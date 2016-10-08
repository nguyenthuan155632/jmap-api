require 'rails_helper'

RSpec.describe FindAreasBuildingsController, :type => :controller do
  before(:each) do
    create_dummy
  end

  describe "GET find_areas_buildings" do
    it "returns http success" do
      post :find_areas_buildings
      expect(response.status).to eq(200)
    end
    
    it "正常系（日本語）" do
      search_word = "銀"
      lang        = "ja"
      post :find_areas_buildings, :lang => lang, :search_word => search_word
      expect(response.status).to eq(200)
      puts response.body
      json = JSON.parse(response.body)
      
      # responseの下
      expect(json["response"]["code"]).to    eq(0)
      expect(json["response"]["message"]).to eq("取得しました。")
      
      # response -> infoの下
      info = json["response"]["info"]
      expect(info["object_count"]).to eq(info["object"].count)
      
      # 多言語APIを叩く（エリア情報用）
      jmapi           = JmapI18n::ApiClient.new
      lang_array_area = jmapi.search("%#{search_word}%", type: "area", attr: [:name], lang: lang)
      
      # 多言語APIを叩く（施設情報用）
      jmapi            = JmapI18n::ApiClient.new
      lang_array       = jmapi.get(type: "venue", lang: lang)
      lang_array_venue = jmapi.search("%#{search_word}%", type: "venue", attr: [:name], lang: lang)
      
      # response -> info -> objectの件数分だけループ
      object = info["object"]
      for item in object do
        # response -> info -> object -> itemの下
        if    item["object_type"] == 1 then
          # jsonに含まれるIDから多言語APIから持ってきたデータの中を検索。
          area = lang_array_area.find(ifnone = nil){|lang_item| lang_item[:id] == item["id"]}
          
          # 以下、照合
          expect(item["name"]).to             eq(area[:attrs][:name])
          expect(item["latitude"]).to         eq(Area.find_by(areaid: item["id"]).lat)
          expect(item["longitude"]).to        eq(Area.find_by(areaid: item["id"]).lon)
          expect(item["duty_free_count"]).to  eq(get_count_from_kind(area[:id], "dutyfree"))
          expect(item["concierge_count"]).to  eq(get_count_from_kind(area[:id], "chconcierge"))
          expect(item["background_image"]).to eq(Area.find_by(areaid: item["id"]).url)
          
        elsif item["object_type"] == 2 then
          # jsonに含まれるIDから多言語APIから持ってきたデータの中を検索。
          lavenue = lang_array.find(ifnone = nil){|lang_item| lang_item[:id] == item["id"]}
          venue = lang_array_venue.find(ifnone = nil){|lang_item| lang_item[:id] == item["id"]}
          
          # 以下、照合
          expect(item["name"]).to             eq(venue[:attrs][:name])
          expect(item["latitude"]).to         eq(Venue.find_by(venueId: item["id"]).lat)
          expect(item["longitude"]).to        eq(Venue.find_by(venueId: item["id"]).lon)
          expect(item["duty_free_count"]).to  eq(get_count_from_kind_venue(venue[:id], "dutyfree"))
          expect(item["concierge_count"]).to  eq(get_count_from_kind_venue(venue[:id], "chconcierge"))
          expect(item["background_image"]).to eq(Venue.find_by(venueId: item["id"]).imageUrl)
          expect(item["zip"]).to              eq(Venue.find_by(venueId: item["id"]).zipCode)
          expect(item["address"]).to          eq(lavenue[:attrs][:address])
          expect(item["content"]).to          eq(lavenue[:attrs].has_key?(:content) ? lavenue[:attrs][:content] : '')
          expect(item["url"]).to              eq(Venue.find_by(venueId: item["id"]).officialUrl)
          
        end
      end
    end
    
    it "正常系（一つも合致しない検索ワード、日本語）" do
      search_word = "23"
      lang        = "ja"
      post :find_areas_buildings, :lang => lang, :search_word => search_word
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      
      # responseの下
      expect(json["response"]["code"]).to    eq(0)
      expect(json["response"]["message"]).to eq("取得しました。")
      
      # response -> infoの下
      info = json["response"]["info"]
      expect(info["object_count"]).to eq(info["object"].count)
      
      # 多言語APIを叩く（エリア情報用）
      jmapi           = JmapI18n::ApiClient.new
      lang_array_area = jmapi.search("%#{search_word}%", type: "area", attr: [:name], lang: lang)
      
      # 多言語APIを叩く（施設情報用）
      jmapi            = JmapI18n::ApiClient.new
      lang_array       = jmapi.get(type: "venue", lang: lang)
      lang_array_venue = jmapi.search("%#{search_word}%", type: "venue", attr: [:name], lang: lang)
      
      # response -> info -> objectの件数分だけループ
      object = info["object"]
      for item in object do
        # response -> info -> object -> itemの下
        if    item["object_type"] == 1 then
          # jsonに含まれるIDから多言語APIから持ってきたデータの中を検索。
          area = lang_array_area.find(ifnone = nil){|lang_item| lang_item[:id] == item["id"]}
          
          # 以下、照合
          expect(item["name"]).to             eq(area[:attrs][:name])
          expect(item["latitude"]).to         eq(Area.find_by(areaid: item["id"]).lat)
          expect(item["longitude"]).to        eq(Area.find_by(areaid: item["id"]).lon)
          expect(item["duty_free_count"]).to  eq(get_count_from_kind(area[:id], "dutyfree"))
          expect(item["concierge_count"]).to  eq(get_count_from_kind(area[:id], "chconcierge"))
          expect(item["background_image"]).to eq(Area.find_by(areaid: item["id"]).url)
          
        elsif item["object_type"] == 2 then
          # jsonに含まれるIDから多言語APIから持ってきたデータの中を検索。
          lavenue = lang_array.find(ifnone = nil){|lang_item| lang_item[:id] == item["id"]}
          venue = lang_array_venue.find(ifnone = nil){|lang_item| lang_item[:id] == item["id"]}
          
          # 以下、照合
          expect(item["name"]).to             eq(venue[:attrs][:name])
          expect(item["latitude"]).to         eq(Venue.find_by(venueId: item["id"]).lat)
          expect(item["longitude"]).to        eq(Venue.find_by(venueId: item["id"]).lon)
          expect(item["duty_free_count"]).to  eq(get_count_from_kind_venue(venue[:id], "dutyfree"))
          expect(item["concierge_count"]).to  eq(get_count_from_kind_venue(venue[:id], "chconcierge"))
          expect(item["background_image"]).to eq(Venue.find_by(venueId: item["id"]).imageUrl)
          expect(item["zip"]).to              eq(Venue.find_by(venueId: item["id"]).zipCode)
          expect(item["address"]).to          eq(lavenue[:attrs][:address])
          expect(item["content"]).to          eq(lavenue[:attrs].has_key?(:content) ? lavenue[:attrs][:content] : '')
          expect(item["url"]).to              eq(Venue.find_by(venueId: item["id"]).officialUrl)
          
        end
      end
    end
    
    it "正常系（中国語）" do
      search_word = "銀"
      lang        = "zh-cn"
      post :find_areas_buildings, :lang => lang, :search_word => search_word
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      
      # responseの下
      expect(json["response"]["code"]).to    eq(0)
      expect(json["response"]["message"]).to eq("取得しました。")
      
      # response -> infoの下
      info = json["response"]["info"]
      expect(info["object_count"]).to eq(info["object"].count)
      
      # 多言語APIを叩く（エリア情報用）
      jmapi           = JmapI18n::ApiClient.new
      lang_array_area = jmapi.search("%#{search_word}%", type: "area", attr: [:name], lang: lang)
      
      # 多言語APIを叩く（施設情報用）
      jmapi            = JmapI18n::ApiClient.new
      lang_array       = jmapi.get(type: "venue", lang: lang)
      lang_array_venue = jmapi.search("%#{search_word}%", type: "venue", attr: [:name], lang: lang)
      
      # response -> info -> objectの件数分だけループ
      object = info["object"]
      for item in object do
        # response -> info -> object -> itemの下
        if    item["object_type"] == 1 then
          # jsonに含まれるIDから多言語APIから持ってきたデータの中を検索。
          area = lang_array_area.find(ifnone = nil){|lang_item| lang_item[:id] == item["id"]}
          
          # 以下、照合
          expect(item["name"]).to             eq(area[:attrs][:name])
          expect(item["latitude"]).to         eq(Area.find_by(areaid: item["id"]).lat)
          expect(item["longitude"]).to        eq(Area.find_by(areaid: item["id"]).lon)
          expect(item["duty_free_count"]).to  eq(get_count_from_kind(area[:id], "dutyfree"))
          expect(item["concierge_count"]).to  eq(get_count_from_kind(area[:id], "chconcierge"))
          expect(item["background_image"]).to eq(Area.find_by(areaid: item["id"]).url)
          
        elsif item["object_type"] == 2 then
          # jsonに含まれるIDから多言語APIから持ってきたデータの中を検索。
          lavenue = lang_array.find(ifnone = nil){|lang_item| lang_item[:id] == item["id"]}
          venue = lang_array_venue.find(ifnone = nil){|lang_item| lang_item[:id] == item["id"]}
          
          # 以下、照合
          expect(item["name"]).to             eq(venue[:attrs][:name])
          expect(item["latitude"]).to         eq(Venue.find_by(venueId: item["id"]).lat)
          expect(item["longitude"]).to        eq(Venue.find_by(venueId: item["id"]).lon)
          expect(item["duty_free_count"]).to  eq(get_count_from_kind_venue(venue[:id], "dutyfree"))
          expect(item["concierge_count"]).to  eq(get_count_from_kind_venue(venue[:id], "chconcierge"))
          expect(item["background_image"]).to eq(Venue.find_by(venueId: item["id"]).imageUrl)
          expect(item["zip"]).to              eq(Venue.find_by(venueId: item["id"]).zipCode)
          expect(item["address"]).to          eq(lavenue[:attrs][:address])
          expect(item["content"]).to          eq(lavenue[:attrs].has_key?(:content) ? lavenue[:attrs][:content] : '')
          expect(item["url"]).to              eq(Venue.find_by(venueId: item["id"]).officialUrl)
          
        end
      end
    end
    
    it "正常系（一つも合致しない検索ワード、中国語）" do
      search_word = "23"
      lang        = "zh-cn"
      post :find_areas_buildings, :lang => lang, :search_word => search_word
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      
      # responseの下
      expect(json["response"]["code"]).to    eq(0)
      expect(json["response"]["message"]).to eq("取得しました。")
      
      # response -> infoの下
      info = json["response"]["info"]
      expect(info["object_count"]).to eq(info["object"].count)
      
      # 多言語APIを叩く（エリア情報用）
      jmapi           = JmapI18n::ApiClient.new
      lang_array_area = jmapi.search("%#{search_word}%", type: "area", attr: [:name], lang: lang)
      
      # 多言語APIを叩く（施設情報用）
      jmapi            = JmapI18n::ApiClient.new
      lang_array       = jmapi.get(type: "venue", lang: lang)
      lang_array_venue = jmapi.search("%#{search_word}%", type: "venue", attr: [:name], lang: lang)
      
      # response -> info -> objectの件数分だけループ
      object = info["object"]
      for item in object do
        # response -> info -> object -> itemの下
        if    item["object_type"] == 1 then
          # jsonに含まれるIDから多言語APIから持ってきたデータの中を検索。
          area = lang_array_area.find(ifnone = nil){|lang_item| lang_item[:id] == item["id"]}
          
          # 以下、照合
          expect(item["name"]).to             eq(area[:attrs][:name])
          expect(item["latitude"]).to         eq(Area.find_by(areaid: item["id"]).lat)
          expect(item["longitude"]).to        eq(Area.find_by(areaid: item["id"]).lon)
          expect(item["duty_free_count"]).to  eq(get_count_from_kind(area[:id], "dutyfree"))
          expect(item["concierge_count"]).to  eq(get_count_from_kind(area[:id], "chconcierge"))
          expect(item["background_image"]).to eq(Area.find_by(areaid: item["id"]).url)
          
        elsif item["object_type"] == 2 then
          # jsonに含まれるIDから多言語APIから持ってきたデータの中を検索。
          lavenue = lang_array.find(ifnone = nil){|lang_item| lang_item[:id] == item["id"]}
          venue = lang_array_venue.find(ifnone = nil){|lang_item| lang_item[:id] == item["id"]}
          
          # 以下、照合
          expect(item["name"]).to             eq(venue[:attrs][:name])
          expect(item["latitude"]).to         eq(Venue.find_by(venueId: item["id"]).lat)
          expect(item["longitude"]).to        eq(Venue.find_by(venueId: item["id"]).lon)
          expect(item["duty_free_count"]).to  eq(get_count_from_kind_venue(venue[:id], "dutyfree"))
          expect(item["concierge_count"]).to  eq(get_count_from_kind_venue(venue[:id], "chconcierge"))
          expect(item["background_image"]).to eq(Venue.find_by(venueId: item["id"]).imageUrl)
          expect(item["zip"]).to              eq(Venue.find_by(venueId: item["id"]).zipCode)
          expect(item["address"]).to          eq(lavenue[:attrs][:address])
          expect(item["content"]).to          eq(lavenue[:attrs].has_key?(:content) ? lavenue[:attrs][:content] : '')
          expect(item["url"]).to              eq(Venue.find_by(venueId: item["id"]).officialUrl)
          
        end
      end
    end
    
    it "異常系（検索文字列なし、日本語）" do
      post :find_areas_buildings, :lang => "ja"
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      
      # responseの下
      expect(json["response"]["code"]).to    eq(101)
      expect(json["response"]["message"]).to eq("検索ワードが入力されておりません。")
      expect(json["response"]["info"]).to    eq({})
    end
    
    it "異常系（検索文字列なし、中国語）" do
      post :find_areas_buildings, :lang => "zh-cn"
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      
      # responseの下
      expect(json["response"]["code"]).to    eq(101)
      expect(json["response"]["message"]).to eq("検索ワードが入力されておりません。")
      expect(json["response"]["info"]).to    eq({})
    end
    
    it "異常系（出力言語の指定なし）" do
      post :find_areas_buildings, :search_word => "銀"
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      
      # responseの下
      expect(json["response"]["code"]).to    eq(0)
      expect(json["response"]["message"]).to eq("取得しました。")
      #expect(json["response"]["info"]).to    eq({})
    end
    
    it "異常系（出力言語の指定が不正）" do
      post :find_areas_buildings, :lang => "hoge", :search_word => "銀"
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      
      # responseの下
      expect(json["response"]["code"]).to    eq(0)
      expect(json["response"]["message"]).to eq("取得しました。")
      #expect(json["response"]["info"]).to    eq({})
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
    
    #FactoryGirl.create(:venue, areaId: "1", venueId:  "1", country: "JP", business: "Shopping Mall", lat: "35.674597", lon: "139.763549", zipCode: "100-0006", imageUrl: "/test.jpeg")
    #FactoryGirl.create(:venue, areaId: "1", venueId:  "2", country: "JP", business: "Shopping Mall", lat: "35.673631", lon: "139.763493", zipCode: "100-8488", imageUrl: "/test.jpeg")
    #FactoryGirl.create(:venue, areaId: "2", venueId:  "3", country: "JP", business: "Shopping Mall", lat: "35.660903", lon: "139.701078", zipCode: "150-0041", imageUrl: "/test.jpeg")
    #FactoryGirl.create(:venue, areaId: "2", venueId:  "4", country: "JP", business: "Shopping Mall", lat: "35.65862",  lon: "139.701869", zipCode: "150-8319", imageUrl: "/test.jpeg")
    #FactoryGirl.create(:venue, areaId: "3", venueId:  "5", country: "JP", business: "Shopping Mall", lat: "35.688595", lon: "139.697929", zipCode: "160-0023", imageUrl: "/test.jpeg")
    #FactoryGirl.create(:venue, areaId: "2", venueId:  "6", country: "JP", business: "Shopping Mall", lat: "35.65955",  lon: "139.699065", zipCode: "150-0043", imageUrl: "/test.jpeg")
    #FactoryGirl.create(:venue, areaId: "2", venueId:  "7", country: "JP", business: "Shopping Mall", lat: "35.659825", lon: "139.698176", zipCode: "150-0043", imageUrl: "/test.jpeg")
    #FactoryGirl.create(:venue, areaId: "3", venueId:  "8", country: "JP", business: "Shopping Mall", lat: "35.688595", lon: "139.697929", zipCode: "160-0023", imageUrl: "/test.jpeg")
    #FactoryGirl.create(:venue, areaId: "2", venueId:  "9", country: "JP", business: "Shopping Mall", lat: "35.65955",  lon: "139.699065", zipCode: "150-0043", imageUrl: "/test.jpeg")
    #FactoryGirl.create(:venue, areaId: "2", venueId: "10", country: "JP", business: "Shopping Mall", lat: "35.659825", lon: "139.698176", zipCode: "150-0043", imageUrl: "/test.jpeg")
    
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
    
    FactoryGirl.create(:venue, areaId: "1", venueId:  "9686", country: "JP", business: "Shopping Mall", lat: "35.674597", lon: "139.763549", zipCode: "100-0006", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "2", venueId:  "9696", country: "JP", business: "Shopping Mall", lat: "35.660903", lon: "139.701078", zipCode: "150-0041", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "2", venueId:  "9695", country: "JP", business: "Shopping Mall", lat: "35.660903", lon: "139.701078", zipCode: "150-0041", imageUrl: "/test.jpeg")
    
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  13680027, name:       "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  13680027, name:     "address", value: "hoge")
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  13680204, name:       "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  13680204, name:     "address", value: "piyo")
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  13680027, name:    "dutyfree", value: "foo")
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  13680027, name: "chconcierge", value: "bar")
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  13680027, name:    "entrance", value: "http://www.hogehogehoge.com")
    FactoryGirl.create(:attribute, venueId: "9686", shopId:  13680204, name:    "entrance", value: "http://www.fugafugafuga.com")
    FactoryGirl.create(:attribute, venueId: "9696", shopId:  13680027, name:     "dutyfree", value: "piyo")
    FactoryGirl.create(:attribute, venueId: "9696", shopId:  13680027, name:    "chconcierge", value: "foo")
    FactoryGirl.create(:attribute, venueId: "9695", shopId:  13680027, name:     "dutyfree", value: "piyo")
    FactoryGirl.create(:attribute, venueId: "9695", shopId:  13680027, name:    "chconcierge", value: "foo")

    
  end
  
  ########################################
  # タイプとエリアIDから、そのエリアに存在する、そのタイプの店舗の数を調べる。
  ########################################
  def get_count_from_kind(area_id, name)
    # 取得した免税店情報の総数を代入する変数。
    # 初期値はゼロ。
    count = 0
    
    # 施設情報テーブルからIDの合致する施設情報を全件取得
    buildings = Venue.where(areaId: area_id)
    
    # 取得した施設情報の件数ぶんループを行い、
    # 店舗属性情報テーブルから、施設IDが合致しており、かつタイプコードが免税店のものである情報をすべて取得。
    # その件数を変数に加算後、次のループに移る。
    for building in buildings do
      store_attributes = Attribute.where(["venueId = ? and name = ?", building.venueId, name])
      count += store_attributes.count
    end
    
    # すべての処理が終了したら、取得していた件数を返す。
    return count
  end
  
  ########################################
  # タイプと施設IDから、その施設のIDに合致する店舗情報を調べる
  ########################################
  def get_count_from_kind_venue(venueId, name)
    store_attributes = Attribute.where(["venueId = ? and name = ?", venueId, name])
    return store_attributes.count
  end
end
