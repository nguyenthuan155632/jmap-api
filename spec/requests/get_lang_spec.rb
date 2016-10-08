# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe 'get_lang', type: :request do
  
  # init
  before(:each) do
    create_test_data
  end
  
  # create_test_data
  def create_test_data
    FactoryGirl.create(:conversion_locale, locale:  "en-au", lang: "en")
    FactoryGirl.create(:conversion_locale, locale:  "en-bz", lang: "en")
    FactoryGirl.create(:conversion_locale, locale:  "en-ca", lang: "en")
    FactoryGirl.create(:conversion_locale, locale:  "en-ie", lang: "en")
    FactoryGirl.create(:conversion_locale, locale:  "en-jm", lang: "en")
    FactoryGirl.create(:conversion_locale, locale:  "en-nz", lang: "en")
    FactoryGirl.create(:conversion_locale, locale:  "en-za", lang: "en")
    FactoryGirl.create(:conversion_locale, locale:  "en-tt", lang: "en")
    FactoryGirl.create(:conversion_locale, locale:  "en-gb", lang: "en")
    FactoryGirl.create(:conversion_locale, locale:  "en-us", lang: "en")
    FactoryGirl.create(:conversion_locale, locale:  "ja", lang: "ja")
    FactoryGirl.create(:conversion_locale, locale:  "ja-jp", lang: "ja")
    FactoryGirl.create(:conversion_locale, locale:  "ja-jp-mac", lang: "ja")
    FactoryGirl.create(:conversion_locale, locale:  "ja-jpm", lang: "ja")
    FactoryGirl.create(:conversion_locale, locale:  "zh-cn", lang: "zh-cn")
    FactoryGirl.create(:conversion_locale, locale:  "zh-hk", lang: "zh-tw")
    FactoryGirl.create(:conversion_locale, locale:  "zh-sg", lang: "zh-cn")
    FactoryGirl.create(:conversion_locale, locale:  "zh-tw", lang: "zh-tw")
  end
  
  describe 'POST /v1/get_lang', :type => :request do
    
    it "en-au" do
      post "/v1/get_lang", {locale: "en-au"}
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["response"]["info"]).to eq("en")
    end
    
    it "en-bz" do
      post "/v1/get_lang", {locale: "en-bz"}
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["response"]["info"]).to eq("en")
    end
    
    it "en-ca" do
      post "/v1/get_lang", {locale: "en-ca"}
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["response"]["info"]).to eq("en")
    end
    
    it "en-ie" do
      post "/v1/get_lang", {locale: "en-ie"}
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["response"]["info"]).to eq("en")
    end
    
    it "en-jm" do
      post "/v1/get_lang", {locale: "en-jm"}
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["response"]["info"]).to eq("en")
    end
    
    it "en-nz" do
      post "/v1/get_lang", {locale: "en-nz"}
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["response"]["info"]).to eq("en")
    end
    
    it "en-za" do
      post "/v1/get_lang", {locale: "en-za"}
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["response"]["info"]).to eq("en")
    end
    
    it "en-tt" do
      post "/v1/get_lang", {locale: "en-tt"}
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["response"]["info"]).to eq("en")
    end
    
    it "en-gb" do
      post "/v1/get_lang", {locale: "en-gb"}
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["response"]["info"]).to eq("en")
    end
    
    it "en-us" do
      post "/v1/get_lang", {locale: "en-us"}
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["response"]["info"]).to eq("en")
    end
    
    it "ja" do
      post "/v1/get_lang", {locale: "ja"}
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["response"]["info"]).to eq("ja")
    end
    
    it "ja-jp" do
      post "/v1/get_lang", {locale: "ja-jp"}
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["response"]["info"]).to eq("ja")
    end
    
    it "ja-jp-mac" do
      post "/v1/get_lang", {locale: "ja-jp-mac"}
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["response"]["info"]).to eq("ja")
    end
    
    it "ja-jpm" do
      post "/v1/get_lang", {locale: "ja-jpm"}
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["response"]["info"]).to eq("ja")
    end
    
    it "zh-cn" do
      post "/v1/get_lang", {locale: "zh-cn"}
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["response"]["info"]).to eq("zh-cn")
    end
    
    it "zh-hk" do
      post "/v1/get_lang", {locale: "zh-hk"}
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["response"]["info"]).to eq("zh-tw")
    end
    
    it "zh-sg" do
      post "/v1/get_lang", {locale: "zh-sg"}
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["response"]["info"]).to eq("zh-cn")
    end
    
    it "zh-tw" do
      post "/v1/get_lang", {locale: "zh-tw"}
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["response"]["info"]).to eq("zh-tw")
    end
    
    it "dummy" do
      post "/v1/get_lang", {locale: "dummy"}
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["response"]["info"]).to eq("en")
    end
  end

end

