require 'jmap-i18n/api_client'

class FindBuildingsController < ApplicationController
  def find_buildings
    res_hash = chk_input(lang: params[:lang], area_id: params[:area_id])
    
    # 入力チェック処理
    unless res_hash[:is_success] then
      if res_hash[:failed_code] == 0 then
        output = create_json(code: 101, message: "エリアIDが未入力です。")
        render :json => output
        return
        
      elsif res_hash[:failed_code] == 1 then
        output = create_json(code: 101, message: "エリアIDが値が不正です。")
        render :json => output
        return
        
      elsif res_hash[:failed_code] == 2 then
        output = create_json(code: 102, message: "出力言語指定コードが不正です。")
        render :json => output
        return
      end
    end

    # ログ出力用の連想配列
    log_hash = Hash.new

    # ログ出力
    log_hash[:lang] = params[:lang]
    log_hash[:area_id] = params[:area_id]
    log_hash[:controller] = params[:controller]
    send(:log_output, 'JB002', log_hash)

    # 多言語APIを叩く
    jmapi = JmapI18n::ApiClient.new
    names = jmapi.get(type: "venue", lang: params[:lang])

    # チェックが終了したらjsonのパーツになるハッシュ「info」を作成
    info = create_info(Area.find_by(areaid: res_hash[:area_id]), names)
    output = create_json(code: 0, message: "取得しました。", info: info)
    render :json => output
    return
  end
  
  # - - - - - - - - - - - - - - - - - - - -
  # 入力チェック
  #   チェック成功時
  #     res_hash[:is_success] => true
  #     res_hash[:area_id]    => 整数化されたエリアID
  #
  #   チェック失敗時
  #     res_hash[:is_success]  => false
  #     res_hash[:failed_code] => （0.エリアIDが未入力  1.エリアIDの値が不正  ２.出力言語指定コードが未入力、または不正）
  # - - - - - - - - - - - - - - - - - - - -
  private
  def chk_input (input_value)
    # 出力言語指定コードに不正がないかチェック
    unless chk_lang(input_value[:lang]) then
      res_hash = {
        is_success: false,
        failed_code: 2
      }
      return res_hash
    end
    
    # エリアIDが未入力でないかチェック
    unless input_value[:area_id] then
      res_hash = {
        is_success: false,
        failed_code: 0
      }
      return res_hash
    end
    
    # エリアIDの値を整数に変えて出力
    # 例外が発生したら、エリアIDの値に数字以外が入ってきている
    begin
      area_id = Integer(input_value[:area_id])
    rescue
      res_hash = {
        is_success: false,
        faile_code: 1
      }
      return res_hash
    end
    
    # すべてのエラーをチェックし終えて問題は発生していなかったら
    res_hash = {
      is_success: true,
      area_id: area_id
    }
    return res_hash
  end
  
  # - - - - - - - - - - - - - - - - - - - -
  # 出力言語指定コードのチェック
  #   チェック成功時
  #     res_chk => true
  #
  #   チェック失敗時
  #     res_chk => false
  # - - - - - - - - - - - - - - - - - - - -
  private
  def chk_lang(lang)
    # 対応している言語の配列
    # 対応している言語が増えた場合は以下の配列に要素を足すこと。
#    lang_array = ['ja', 'zh-cn']
    
    # langが対応している言語のいずれかと合致するならtrueを、ひとつも合致しない場合はfalseを返す
#    return lang_array.any? {|ln| ln == lang}
    return true
  end
  
  # - - - - - - - - - - - - - - - - - - - -
  # jsonのパーツとなるinfoハッシュを作成
  # - - - - - - - - - - - - - - - - - - - -
  def create_info(area, names)
    # 施設情報格納用の配列を準備
    building_info = Array.new
    
    # エリア情報から緯度・経度を取得
    a_lat = Float(area.lat)
    a_lng = Float(area.lon)
    
    # 多言語APIを叩いて情報を取得
    jmapi = JmapI18n::ApiClient.new
    
    # 施設情報を全件取得
    buildings = Venue.all
    
    # 施設情報の件数分だけループ
    for building in buildings do
      # 施設の緯度・経度を取得
      b_lat = Float(building.lat)
      b_lng = Float(building.lon)
      
      # 2点間の距離を算出
      distance = calc_distanse(a_lat, a_lng, b_lat, b_lng)

      # エリアの緯度経度と計算を行い、10km圏内であれば登録
      if calc_distanse(a_lat, a_lng, b_lat, b_lng) <= 10 then
        building_info << create_building_info(building, names)
      end
    end
    
    info = {
      latitude:      a_lat,
      longitude:     a_lng,
      building_info: building_info
    }
    return info
  end
  
  # - - - - - - - - - - - - - - - - - - - -
  # 緯度・経度から２点間の距離を計算
  # - - - - - - - - - - - - - - - - - - - -
  private
  def calc_distanse(a_lat, a_lng, b_lat, b_lng)
    # 赤道半径[km]
    r = 6378.137

    # 引数の値をdigree角からradian角へ
    a_latr = dig_to_rad(a_lat)
    b_latr = dig_to_rad(b_lat)
    a_lngr = dig_to_rad(a_lng)
    b_lngr = dig_to_rad(b_lng)

    out = [Math::sin(a_latr), Math::sin(b_latr), Math::cos(a_latr),Math::cos(b_latr)]

    # 2点間の距離を計算
    cosine = Math::acos((Math::sin(a_latr) * Math::sin(b_latr)) + (Math::cos(a_latr) * Math::cos(b_latr) * Math::cos(b_lngr - a_lngr)))
    distance = r * cosine

    logger.debug([a_lat, a_lng, b_lat, b_lng, distance].inspect)

    # 返り値を設定
    return distance
  end
  
  # - - - - - - - - - - - - - - - - - - - -
  # jsonの一部であるbuilding_info配列のアイテムを作成
  # - - - - - - - - - - - - - - - - - - - -
  def create_building_info(building, names)
    lang_item = names.find(ifnone = nil){|item| item[:id] == building.venueId}

    item = {
      id: building.venueId,
      name:            lang_item[:attrs]["name"],
      exist_duty_free: boolean_to_binary(Attribute.exists?(venueId: building.venueId, name: "dutyfree")),
      exist_concierge: boolean_to_binary(Attribute.exists?(venueId: building.venueId, name: "chconcierge")),
      latitude: building.lat,
      longitude: building.lon
    }
    
    return item
  end
  
  # - - - - - - - - - - - - - - - - - - - -
  # jsonの元になるハッシュを生成
  # - - - - - - - - - - - - - - - - - - - -
  def create_json(args = {})
    args = {
      code: 0,
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
end
