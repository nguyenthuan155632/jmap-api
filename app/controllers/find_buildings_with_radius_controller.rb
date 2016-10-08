require 'jmap-i18n/api_client'

class FindBuildingsWithRadiusController < ApplicationController
  def find_buildings_with_radius
    # ▽▼▽▼▽▼▽▼▽▼▽▼▽▼▽▼▽▼▽▼  ここから入力チェック処理  ▽▼▽▼▽▼▽▼▽▼▽▼▽▼▽▼▽▼▽▼
    res_hash = chk_input(
      latitude:  params[:latitude],
      longitude: params[:longitude],
      category:  params[:category],
      icon:      params[:icon],
      radius:    params[:radius],
      lang:      params[:lang],
    )
    
    unless res_hash[:is_success] then
      if    res_hash[:failed_code] == 0 then
        output = create_json(code: 101, message: "出力言語指定が不正です。")
        render :json => output
        return
        
      elsif res_hash[:failed_code] == 1 then
        output = create_json(code: 101, message: "緯度の値が不正です。")
        render :json => output
        return
        
      elsif res_hash[:failed_code] == 2 then
        output = create_json(code: 101, message: "経度の値が不正です。")
        render :json => output
        return
        
      elsif res_hash[:failed_code] == 3 then
        output = create_json(code: 101, message: "半径の値が不正です。")
        render :json => output
        return
        
      else
        output = create_json(code: 101, message: "不明なエラー、用件証")
        render :json => output
        return
      end
    end
    # △▲△▲△▲△▲△▲△▲△▲△▲△▲△▲  ここまで入力チェック処理  △▲△▲△▲△▲△▲△▲△▲△▲△▲△▲

    # ログ出力用の連想配列
    log_hash = Hash.new

    # ログ出力
    log_hash[:latitude] = params[:latitude]
    log_hash[:longitude] = params[:longitude]
    log_hash[:radius] = params[:radius]
    log_hash[:lang] = params[:lang]
    log_hash[:controller] = params[:controller]
    send(:log_output, 'JB004', log_hash)

    # 多言語APIを叩く
    jmapi      = JmapI18n::ApiClient.new
    lang_array = jmapi.get(type: "venue", lang: params[:lang])
    
    # jsonのパーツとなるinfoハッシュを作成
    info = create_info(
      latitude:   res_hash[:latitude],
      longitude:  res_hash[:longitude],
      category:   res_hash[:category],
      icon:       res_hash[:icon],
      radius:     res_hash[:radius],
      lang_array: lang_array
    )
    
    # jsonの元になるハッシュを作成
    output = create_json(info: info)
    render :json => output
    return
  end
  
  ##############################
  # 入力チェック
  #   成功時
  #     res_hash[:is_success] #=> true
  #     res_hash[:latitude]   #=> 文字列から実数に変換された緯度
  #     res_hash[:longitude]  #=> 文字列から実数に変換された経度
  #     res_hash[:radius]     #=> 文字列から実数に変換された半径
  # 
  #   失敗時
  #     res_hash[:is_success]  #=> false
  #     res_hash[:failed_code] #=> チェック失敗コード（0.lang, 1.latitude, 2.longitude, 3.radius）
  ##############################
  private
  def chk_input(input_values)
    res_chk_lang = chk_lang(input_values[:lang])
    res_chk_lat  = chk_value(input_values[:latitude])
    res_chk_lng  = chk_value(input_values[:longitude])
    res_chk_rad  = chk_value(input_values[:radius])
    
    # p res_chk_lang
    # p res_chk_lat.inspect
    # p res_chk_lng.inspect
    # p res_chk_rad.inspect
    
    # 出力言語の指定は？
    unless res_chk_lang then
      res_hash = {
        is_success:  false,
        failed_code: 0
      }
      return res_hash
    end
    
    # 緯度は？
    unless res_chk_lat[:is_success] then
      res_hash = {
        is_success:  false,
        failed_code: 1
      }
      return res_hash
    end
    
    # 経度は？
    unless res_chk_lng[:is_success] then
      res_hash = {
        is_success:  false,
        failed_code: 2
      }
      return res_hash
    end
    
    # 半径は？
    unless res_chk_rad[:is_success] then
      res_hash = {
        is_success:  false,
        failed_code: 3
      }
      return res_hash
    end
    
    # すべてのチェックを通ったら
    res_hash = {
        is_success: true,
        latitude:   res_chk_lat[:float_value],
        longitude:  res_chk_lng[:float_value],
        category:   input_values[:category],
        icon:       input_values[:icon],
        radius:     res_chk_rad[:float_value]
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
  # 緯度・経度・半径チェック
  #   成功時
  #     res_hash[:is_success]  #=>true
  #     res_hash[:float_value] #=>実数化された引数の値
  # 
  #   失敗時
  #     res_hash[:is_success]  #=>false
  ##############################
  private
  def chk_value(value)
    # 入力ナシを弾く
    unless value then
      res_hash = {
        is_success: false
      }
      return res_hash
    end
    
    # 実数に変換できない値を弾く
    begin
      float_value = Float(value)
    rescue
      res_hash = {
        is_success: false
      }
      return res_hash
    end
    
    # 全部通ったら
    res_hash = {
      is_success:  true,
      float_value: float_value
    }
    return res_hash
  end
  
  ##############################
  # jsonのパーツとなるinfoハッシュを作成
  ##############################
  private
  def create_info(values)
    # 施設情報用の配列
    building_info = Array.new
    
    # 緯度・経度・半径を引数から取得し、保持
    a_lat = values[:latitude]
    a_lng = values[:longitude]
    rad   = values[:radius]
    
    radbuildingvneuIds = Array.new
    if (values[:icon].size === 0) then
        # 施設情報を全件取得
        venues = Venue.all
        
    else
        # 指定されたアイコンに紐付く施設情報を取得
        venues = CategorySet.joins(
           'LEFT OUTER JOIN shops ON shops.shopId = category_set.shopId
            LEFT OUTER JOIN venues ON venues.venueId = shops.venueId'
          ).select("venues.*"
          ).where("venues.venueId is NOT NULL AND category_set.category_id = ?", values[:icon]
          ).group("venues.venueId")
    end
    for venue in venues do
      b_lat    = Float(venue.lat)
      b_lng    = Float(venue.lon)
      distance = calc_distance(a_lat, a_lng, b_lat, b_lng)
      # 二点間の距離が、指定された半径以下ならば配列にセット
      if distance <= rad then
        radbuildingvneuIds.push(venue.venueId)
      end
    end
    
    #施設情報を取得する
    if (values[:category].size === 0) then
      venues = Venue.joins(
         'LEFT OUTER JOIN attributes ON attributes.venueId = venues.venueId and attributes.name IN ("dutyfree","chconcierge")'
        ).select("venues.last_updated, venues.display_flag, venues.venueId,venues.lat,venues.lon,venues.business,venues.zipCode,venues.officialUrl,attributes.name,count(attributes.name) as cname"
        ).where("venues.venueId IN (?)", radbuildingvneuIds
        ).group("venues.venueId,attributes.name")
    else
      venues = Venue.joins(
         'LEFT OUTER JOIN attributes ON attributes.venueId = venues.venueId and attributes.name IN ("dutyfree","chconcierge")'
        ).select("venues.last_updated, venues.display_flag, venues.venueId,venues.lat,venues.lon,venues.business,venues.zipCode,venues.officialUrl,attributes.name,count(attributes.name) as cname"
        ).where("venues.venueId IN (?) and venues.business IN (?)", radbuildingvneuIds, values[:category]
        ).group("venues.venueId,attributes.name")
    end
    dvenue = editSQLdata(venues)
    
    #施設情報を作成する
    for venue in dvenue do
      b_info = create_building_info(venue, values[:lang_array])
      if !b_info.nil? then
        building_info << create_building_info(venue, values[:lang_array])
      end
    end

    info = {
      building_count: building_info.count,
      building_info:  building_info
    }
    return info
  end
  
  ##############################
  # jsonのパーツとなるinfoハッシュを構成するbuilding_info配列を作成する
  ##############################
  def create_building_info(venue, lang_array)
    lang_item = lang_array.find(ifnone = nil){|item| item[:id] == venue["venueId"]}
    if lang_item.nil? then
      return nil
    else
      item = {
        id:              venue["venueId"],
        last_updated:     venue['last_updated'],
        display_flag:    venue['display_flag'],
        name:            lang_item[:attrs]["name"],
        zip:             venue["zipCode"],
        address:         lang_item[:attrs]["address"],
        content:         lang_item[:attrs].has_key?("content") ? lang_item[:attrs]["content"] : '',
        url:             venue["officialUrl"],
        exist_duty_free: isPoi(venue,"dutyfree"),
        exist_concierge: isPoi(venue,"chconcierge"),
        latitude: venue["lat"],
        longitude: venue["lon"],
        business: venue["business"]
      }
      return item
    end
  end
  
  ##############################
  # jspoiの存在有無を返却する。
  ##############################
  def isPoi(venue,name)
    
    if name == "dutyfree" then
        if venue["dutyfree"] > 0 then
          return 1
        end
    elsif name == "chconcierge" then
      if venue["chconcierge"] > 0 then
        return 1
      end
    end
    return 0
  end
  
  ##############################
  # 緯度・経度から２点間の距離を計算
  ##############################
  private
  def calc_distance(a_lat, a_lng, b_lat, b_lng)
    # 赤道半径[km]
    r = 6378.137
    
    # p a_lat
    # p a_lng
    # p b_lat
    # p b_lng

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
  
  ##############################
  # jsonの元になるハッシュを生成
  ##############################
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
  # SQL返却値Hash変換処理
  #     return 配列  
  ########################################
  def editSQLdata(venues)
    
    #work変数の作成
    disvenues = Array.new
    hvenues = Hash.new
    
    #AcctiveRecord型からHash型へ変換
    hvenues = ActiveSupport::JSON.decode(venues.to_json)
    
    #　取得したデータ分の繰り返し処理（同一エリアが最大２レコード含まれる：dutyfree,chconcierge）
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
