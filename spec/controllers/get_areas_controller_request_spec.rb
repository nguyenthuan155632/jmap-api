require 'rails_helper'

RSpec.describe GetAreasController, :type => :controller do
  before(:each) do
    create_dummy
  end
  
  describe GetAreasController, :type => :controller do
    it "とりあえず正常に動作する" do
      post :get_areas, lang: 'ja'
      expect(response.status).to eq(200)
      puts response.body
    end
    
    it "正常系（日本語）" do
      post :get_areas, lang: 'ja'
      expect(response.status).to eq(200)
      
      json = JSON.parse(response.body)
      
      # response
      response = json["response"]
      expect(response["code"]).to eq(0)
      expect(response["message"]).to eq("取得しました。")
      
      # info
      info = response["info"]
      # venueエンティティに存在するエリアの数
      expect(info["area_count"]).to eq(3)
      
      # area_info
      area_info = info["area_info"]
      for item in area_info do
        expect(item["id"]).to               eq(item["id"])
        expect(item["latitude"]).to         eq(Area.find_by(areaid: item["id"]).lat)
        expect(item["longitude"]).to        eq(Area.find_by(areaid: item["id"]).lon)
        expect(item["duty_free_count"]).to  eq(get_count_from_kind_name(item["id"],    "dutyfree"))
        expect(item["concierge_count"]).to  eq(get_count_from_kind_name(item["id"], "chconcierge"))
        expect(item["background_image"]).to eq(Area.find_by(areaid: item["id"]).url)
      end
    end
    
    it "出力言語指定コードが未入力" do
      post :get_areas
      expect(response.status).to eq(200)
      
      json = JSON.parse(response.body)
      
      # response
      response = json["response"]
      expect(response["code"]).to eq(0)
      expect(response["message"]).to eq("取得しました。")
      #expect(response["info"]).to eq({})
    end
    
    it "言語指定が不正なときに例外を発生させず処理を抜けられるか（1.言語コードに異常な値を入れた場合）" do
      post :get_areas, :lang => 'hoge'
      expect(response.status).to eq(200)
      
      json = JSON.parse(response.body)
      
      # response
      response = json["response"]
      # 変換するテーブル情報がないのでDBエラー
      expect(response["code"]).to eq(501)
      expect(response["message"]).to eq("DB処理で例外が発生しました。")
      expect(response["info"]).to eq({})
    end
    
    it "正常系（中国語）" do
      post :get_areas, lang: 'zh-cn'
      expect(response.status).to eq(200)
      
      json = JSON.parse(response.body)
      
      # response
      response = json["response"]
      expect(response["code"]).to eq(0)
      expect(response["message"]).to eq("取得しました。")
      
      # info
      info = response["info"]
      # venueエンティティに存在するエリアの数
      expect(info["area_count"]).to eq(3)
      
      # area_info
      area_info = info["area_info"]
      for item in area_info do
        expect(item["id"]).to               eq(item["id"])
        expect(item["latitude"]).to         eq(Area.find_by(areaid: item["id"]).lat)
        expect(item["longitude"]).to        eq(Area.find_by(areaid: item["id"]).lon)
        expect(item["duty_free_count"]).to  eq(get_count_from_kind_name(item["id"],    "dutyfree"))
        expect(item["concierge_count"]).to  eq(get_count_from_kind_name(item["id"], "chconcierge"))
        expect(item["background_image"]).to eq(Area.find_by(areaid: item["id"]).url)
      end
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
    
    FactoryGirl.create(:venue, areaId: "1", venueId: "1", country: "JP", business: "Shopping Mall", lat: "35.674597", lon: "139.763549", zipCode: "100-0006", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "1", venueId: "2", country: "JP", business: "Shopping Mall", lat: "35.673631", lon: "139.763493", zipCode: "100-8488", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "2", venueId: "3", country: "JP", business: "Shopping Mall", lat: "35.660903", lon: "139.701078", zipCode: "150-0041", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "2", venueId: "4", country: "JP", business: "Shopping Mall", lat: "35.65862",  lon: "139.701869", zipCode: "150-8319", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "3", venueId: "5", country: "JP", business: "Shopping Mall", lat: "35.688595", lon: "139.697929", zipCode: "160-0023", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "2", venueId: "6", country: "JP", business: "Shopping Mall", lat: "35.65955",  lon: "139.699065", zipCode: "150-0043", imageUrl: "/test.jpeg")
    FactoryGirl.create(:venue, areaId: "2", venueId: "7", country: "JP", business: "Shopping Mall", lat: "35.659825", lon: "139.698176", zipCode: "150-0043", imageUrl: "/test.jpeg")
    
    FactoryGirl.create(:attribute, venueId: "5", shopId:  1, name: "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  1, name: "icname", value: "hoge")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  3, name: "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  3, name: "icname", value: "piyo")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  5, name: "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  5, name: "icname", value: "fuga")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  7, name: "phone", value: "81353390511")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  7, name: "icname", value: "hogera")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  9, name: "dutyfree", value: "foo")
    FactoryGirl.create(:attribute, venueId: "5", shopId:  9, name: "chconcierge", value: "bar")
    FactoryGirl.create(:attribute, venueId: "5", shopId: 11, name: "chconcierge", value: "baz")
    FactoryGirl.create(:attribute, venueId: "1", shopId:  9, name: "dutyfree", value: "foo")
    FactoryGirl.create(:attribute, venueId: "1", shopId:  9, name: "chconcierge", value: "bar")
    FactoryGirl.create(:attribute, venueId: "3", shopId:  9, name: "dutyfree", value: "foo")
    FactoryGirl.create(:attribute, venueId: "3", shopId:  9, name: "chconcierge", value: "bar")
  end
  
  def get_count_from_kind_name(area_id, kind_name)
    # 取得した免税店情報の総数を代入する変数。
    # 初期値はゼロ。
    count = 0
    
    # タイプマスタから免税店のタイプコードを取得。
    # 記述時の免税店のタイプコードは「20000201」
    # types = Attribute.find_by(types: kind_name).types
    
    # 施設情報テーブルからIDの合致する施設情報を全件取得
    buildings = Venue.where(areaid: area_id)
    # puts(buildings.inspect)
    
    # 取得した施設情報の件数ぶんループを行い、
    # 店舗属性情報テーブルから、施設IDが合致しており、かつタイプコードが免税店のものである情報をすべて取得。
    # その件数を変数に加算後、次のループに移る。
    for building in buildings do
      store_attributes = Attribute.where(["venueId = ? and name = ?", building.venueId, kind_name])
      count += store_attributes.count
    end
    
    # すべての処理が終了したら、取得していた件数を返す。
    return count
  end
end