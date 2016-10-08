require 'jmap-i18n/api_client'

class FindAreasBuildingsController < ApplicationController
  def find_areas_buildings
    # ▽▼▽▼▽▼▽▼▽▼▽▼▽▼▽▼▽▼▽▼  ここから入力チェック処理  ▽▼▽▼▽▼▽▼▽▼▽▼▽▼▽▼▽▼▽▼
    res_hash = chk_input(
      search_word: params[:search_word],
      lang:        params[:lang]
    )
    
    unless res_hash[:is_success] then
      if    res_hash[:failed_code] == 0 then
        output = create_json(code: 102, message: "出力言語の指定が不正です。")
        render :json => output
        return
        
      elsif res_hash[:failed_code] == 1 then
        output = create_json(code: 101, message: "検索ワードが入力されておりません。")
        render :json => output
        return
        
      else
        output = create_json(code: 999, message: "不明なエラー。要検証")
        render :json => output
        return
      end
    end
    # △▲△▲△▲△▲△▲△▲△▲△▲△▲△▲  ここまで入力チェック処理  △▲△▲△▲△▲△▲△▲△▲△▲△▲△▲
    
    # チェックが終わったらJsonのパーツとなるinfoハッシュを作成
    info = create_info(
      params[:search_word], 
      params[:lang]
    )
    
    # ログ出力用の連想配列
    log_hash = Hash.new

    # ログ出力
    log_hash[:lang] = params[:lang]
    log_hash[:search_word] = params[:search_word]
    log_hash[:controller] = params[:controller]
    send(:log_output, 'JB003', log_hash)

    # チェックが終わったらJsonのパーツとなるinfoハッシュを作成
    info = create_info(
      params[:search_word], 
      params[:lang]
    )
    
    # infoハッシュの作成が終了したらjsonを生成し、出力
    output = create_json(info: info)
    render :json => output
    return
  end
  
  ##############################
  # 入力チェック
  #   成功時
  #     res_hash[:is_success] #=> true
  # 
  #   失敗時
  #     res_hash[:is_success]  #=> false
  #     res_hash[:failed_code] #=> チェック失敗コード（0.lang, 1.search_word
  ##############################
  def chk_input(input_values)
    res_chk_lang = chk_lang(input_values[:lang])
    res_chk_word = chk_word(input_values[:search_word])
    
    unless res_chk_lang then
      res_hash = {
        is_success: false,
        failed_code: 0
      }
      return res_hash
    end
    
    unless res_chk_word then
      res_hash = {
        is_success: false,
        failed_code: 1
      }
      return res_hash
    end
    
    # 成功時
    res_hash = {
      is_success: true
    }
    return res_hash
  end
  
  ##############################
  # 出力言語指定チェック
  #   成功時
  #     result #=> true
  #
  #   失敗時
  #     result #=> false
  ##############################
  private
  def chk_lang(lang)
#    lang_array = ["ja", "zh-cn"]
#    if lang_array.find(ifnone = nil){|lng| lng == lang}
#      return true
#    else
#      return false
#    end
     return true
  end
  
  ##############################
  # 検索文字列チェック
  #   成功時
  #     result #=> true
  #
  #   失敗時
  #     result #=> false
  ##############################
  private
  def chk_word(word)
    if word && word != "" then
      return true
      
    else
      return false
      
    end
  end
  
  ##############################
  # jsonのパーツとなるinfoハッシュを作成
  ##############################
  private
  def create_info(search_word, lang)
    # アイテム格納用の配列
    object_array = Array.new
    
    # 多言語APIを叩く（エリア情報用）
    jmapi           = JmapI18n::ApiClient.new
    # lang_array_area = jmapi.search("%#{search_word}%", type: "area", attr: [:name], lang: lang)
    lang_array_area = jmapi.search(search_word, type: "area", attr: [:name], lang: lang)
    
    # エリアのアイテム数だけループさせる
    for area_item in lang_array_area do
      area_name = area_item[:attrs]["name"]
      area_id   = area_item[:id]
      areas = Area.joins(
        'LEFT OUTER JOIN venues ON venues.areaId = areas.areaId
         LEFT OUTER JOIN attributes ON attributes.venueId = venues.venueId and attributes.name IN ("dutyfree","chconcierge")'
        ).select("areas.areaid,areas.lat,areas.lon,areas.url,attributes.name,count(attributes.name) as cname"
        ).where("areas.areaId = ?", area_id
        ).group("areas.areaId,attributes.name")
      area = editSQLdata(areas)
      
      item = {
        object_type:      1,
        id:               area[0]["areaid"],
        name:             area_name,
        latitude:         area[0]["lat"],
        longitude:        area[0]["lon"],
        duty_free_count:  area[0]["dutyfree"],
        concierge_count:  area[0]["chconcierge"],
        background_image: area[0]["url"]
      }
      object_array << item;
    end

    # 多言語APIを叩く（施設情報用）
    jmapi            = JmapI18n::ApiClient.new
    # lang_array_venue = jmapi.search("%#{search_word}%", type: "venue", attr: [:name], lang: lang)
    lang_array = jmapi.get(type: "venue", lang: lang)
    lang_array_venue = jmapi.search(search_word, type: "venue", attr: [:name], lang: lang)
    # venueId配列を作成する
    venueIds = Array.new
    for venue_item in lang_array_venue do
      venueIds.push(venue_item[:id])
    end
    # venue情報を取得する
    venues = Venue.joins(
       'LEFT OUTER JOIN attributes ON attributes.venueId = venues.venueId and attributes.name IN ("dutyfree","chconcierge")'
      ).select("venues.last_updated, venues.venueId,venues.lat,venues.lon,venues.imageUrl,venues.zipCode,venues.officialUrl,attributes.name,count(attributes.name) as cname"
      ).where("venues.venueId IN (?)", venueIds
      ).group("venues.venueId,attributes.name")
    dvenue = editSQLdata(venues)

    # 取得できたアイテム数だけ繰り返す
    for venue in dvenue do
      lavenue = lang_array.find(ifnone = nil){|item| item[:id] == venue["venueId"]}
      venue_name = lavenue[:attrs][:name]
      
      # 配列用のハッシュを作成
      item_hash = {
        object_type:      2,
        id:               venue["venueId"],
        last_updated:     venue['last_updated'],
        name:             venue_name,
        zip:              venue["zipCode"],
        address:          lavenue[:attrs][:address],
        content:          lavenue[:attrs].has_key?(:content) ? lavenue[:attrs][:content] : '',
        url:              venue["officialUrl"],
        latitude:         venue["lat"],
        longitude:        venue["lon"],
        duty_free_count:  venue["dutyfree"],
        concierge_count:  venue["chconcierge"],
        background_image: venue["imageUrl"]
      }
      object_array << item_hash
    end
    
    info = {
      object_count: object_array.count,
      object:       object_array
    }
    return info
  end
  
  ##############################
  # jsonの元になるハッシュを作成
  ##############################
  private
  def create_json(args = {})
    args = {
      code: 0,
      message: "取得しました",
      info: {}
    }.merge(args)
    
    output = {
      response: args
    }
    return output
  end
  
  ########################################
  # jsonの元になるハッシュを生成する
  ########################################
  private
  def create_json(args = {})
    args = {
      code:    0,
      message: "取得しました。",
      info: {}
    }.merge(args)
    
    output = {
      response: {
        code:    args[:code],
        message: args[:message],
        info:    args[:info]
      }
    }
    return output
  end
  
  ########################################
  # タイプとエリアIDから、そのエリアに存在する、そのタイプの店舗の数を調べる。
  ########################################
  #def get_count_from_kind(area_id, name)
  #  # 取得した免税店情報の総数を代入する変数。
  #  # 初期値はゼロ。
  #  count = 0
  #  
  #  # 施設情報テーブルからIDの合致する施設情報を全件取得
  #  buildings = Venue.where(areaId: area_id)
  #  
  #  # 取得した施設情報の件数ぶんループを行い、
  #  # 店舗属性情報テーブルから、施設IDが合致しており、かつタイプコードが免税店のものである情報をすべて取得。
  #  # その件数を変数に加算後、次のループに移る。
  #  for building in buildings do
  #    store_attributes = Attribute.where(["venueId = ? and name = ?", building.venueId, name])
  #    count += store_attributes.count
  #  end
  #  
  #  # すべての処理が終了したら、取得していた件数を返す。
  #  return count
  #end
  
  ########################################
  # タイプと施設IDから、その施設のIDに合致する店舗情報を調べる
  ########################################
  #def get_count_from_kind_venue(venueId, name)
  #  store_attributes = Attribute.where(["venueId = ? and name = ?", venueId, name])
  #  return store_attributes.count
  #end

  ########################################
  # SQL返却値Hash変換処理
  #     return 配列  
  ########################################
  def editSQLdata(venues)
    
    #work変数の作成
    disvenues = Array.new
    hvenues = Hash.new
    
    #AcctiveRecord型からHash型へ変換
    hvenues = ActiveSupport::JSON.decode(venues.to_json)
    
    #取得したデータ分の繰り返し処理（同一エリアが最大２レコード含まれる：dutyfree,chconcierge）
    for venue in hvenues do
      dvenue = disvenues.find(ifnone = nil){|item| item["venueId"] == venue["venueId"]}
      pois = Hash.new 
      if dvenue.nil? then
        venue["dutyfree"] = 0
        venue["chconcierge"] = 0
        dvenue = Hash.new
        pois = setpoi(dvenue,venue)
        disvenues.push(venue)
      else
        pois = setpoi(dvenue,venue)
      end
      venue = pois[:venue]
      dvenue = pois[:dvenue]
    end
    return disvenues;
  end

  ########################################
  # POIの設定
  #     return 配列  
  ########################################
  def setpoi(dvenue,venue)
    if venue["name"] == "dutyfree" then
      dvenue["dutyfree"] = venue["cname"]
      venue["dutyfree"] = venue["cname"]
    elsif venue["name"] == "chconcierge" then
      dvenue["chconcierge"] = venue["cname"]
      venue["chconcierge"] = venue["cname"]
    end
    return {:dvenue => dvenue,:venue => venue}
  end
end