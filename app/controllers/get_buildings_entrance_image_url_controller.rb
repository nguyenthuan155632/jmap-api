require 'jmap-i18n/api_client'
class GetBuildingsEntranceImageUrlController < ApplicationController
  def get_buildings_entrance_image_url
    # ▽▼▽▼▽▼▽▼▽▼▽▼▽▼▽▼▽▼▽▼  ここから入力チェック処理  ▽▼▽▼▽▼▽▼▽▼▽▼▽▼▽▼▽▼▽▼
    res_hash = chk_input(params)
    
    unless res_hash[:is_success] then
      if    res_hash[:failed_code] == 0 then
        output = create_json(code: 102, message: "出力言語の指定が不正です。")
        render :json => output
        return
        
      elsif res_hash[:failed_code] == 1 then
        output = create_json(code: 101, message: "施設IDが入力されておりません。")
        render :json => output
        return
        
      end
    end
    # △▲△▲△▲△▲△▲△▲△▲△▲△▲△▲  ここまで入力チェック処理  △▲△▲△▲△▲△▲△▲△▲△▲△▲△▲

    # # ログ出力用の連想配列
    log_hash = Hash.new

    # ログ出力
    log_hash[:building_id] = params[:building_id]
    log_hash[:lang] = params[:lang]
    log_hash[:controller] = params[:controller]
    send(:log_output, 'JB005', log_hash)

    # jsonのパーツとなるinfoハッシュを作成
    begin
      info = create_info(params)
    rescue => err
      output = create_json(code: 501, message: "DB処理に失敗しました。")
      render :json => output
      return
    end
    
    # jsonの元になるハッシュを作成し、出力して終了
    output = create_json(info: info)
    render :json => output
    return
  end
  
  ##############################
  # 入力チェック
  #   チェック成功時
  #     res_hash[:is_success] #=> true
  # 
  #   チェック失敗時
  #     res_hash[:is_success]  #=> false
  #     res_hash[:failed_code] #=> 0.lang, 1.venueId
  ##############################
  private
  def chk_input(input_values)
    # 言語チェック
    unless chk_lang(input_values[:lang]) then
      res_hash = {
        is_success:  false,
        failed_code: 0
      }
      return res_hash
    end
    
    # idチェック
    unless chk_id(input_values[:building_id]) then
      res_hash = {
        is_success:  false,
        failed_code: 1
      }
      return res_hash
    end
    
    # すべてのチェックをパスしたら
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
  # 施設IDチェック
  #   成功時
  #     result #=> true
  #
  #   失敗時
  #     result #=> false
  ##############################
  private
  def chk_id(id)
    # idが未入力であるとき
    unless id then
      return false
    end
    
    # idに空文字が入っているとき
    if id == "" then
      return false
    end
    
    # idに数字以外が入っているとき
    begin
      Integer(id)
    rescue
      return false
    end
    
    # すべてのチェックを通ったのであれば
    return true
  end
  
  ##############################
  # jsonのパーツになるinfoハッシュを作成
  ##############################
  private
  def create_info(params)
    # idから施設情報を取得
    venue = Venue.find_by(venueId: params[:building_id])
    
    # 施設情報が空だったら
    unless venue then
      info = {
        building_id:     params[:building_id],
        building_name:   "NO DATA",
        latitude:        "NO DATA",
        longitude:       "NO DATA",
        duty_free_count: "NO DATA",
        concierge_count: "NO DATA",
        bg_image_url:    "NO DATA",
        entrance_info:   "NO DATA"
      }
      return info
    end
    
    # 多言語APIをたたき、該当する施設の名前を取得
    jmapi      = JmapI18n::ApiClient.new
    lang_array = jmapi.get(type: "venue", lang: params[:lang], id: venue.venueId)
    
    # infoハッシュ
    info = {
      building_id:     venue.venueId,
      building_name:   lang_array[0][:attrs]["name"],
      latitude:        venue.lat,
      longitude:       venue.lon,
      duty_free_count: get_count_from_type_venue(venue.venueId,    "dutyfree"),
      concierge_count: get_count_from_type_venue(venue.venueId, "chconcierge"),
      bg_image_utl:    venue.imageUrl,
      entrance_info:   create_entrance_info(venue.venueId)
    }
    return info
  end
  
  ########################################
  # タイプと施設IDから、その施設のIDに合致する店舗情報を調べる
  ########################################
  def get_count_from_type_venue(venueId, name)
    store_attributes = Attribute.where(["venueId = ? and name = ?", venueId, name])
    return store_attributes.count
  end
  
  ########################################
  # 施設IDからエントランス画像と、その画像の所属する店舗IDのセットアイテムをもった配列を作成する
  ########################################
  def create_entrance_info(venueId)
    entrance_info = Array.new
    
    attributes = Attribute.where(venueId: venueId, name: "entrance")
    for attribute in attributes do
      info_item = {
        entrance_image: attribute.value,
        shop_id:        attribute.shopId
      }
      entrance_info << info_item
    end
    
    return entrance_info
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
      response: args
    }
    return output
  end
end
