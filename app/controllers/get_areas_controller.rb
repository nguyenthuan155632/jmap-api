require 'jmap-i18n/api_client'

class GetAreasController < ApplicationController
  def get_areas
    # 入力チェック
    res_hash = chk_input(lang: params[:lang])
    unless res_hash[:is_success] then
      # 出力言語指定不正エラー
      output = create_json(code: 102, message: "出力言語指定が不正です。", info: {})
      render :json => output
      return
    end
    
    # # ログ出力用の連想配列
    log_hash = Hash.new

    # ログ出力
    log_hash[:lang] = params[:lang]
    log_hash[:controller] = params[:controller]
    send(:log_output, 'JB001', log_hash)

    # 多言語対応APIを叩く
    jmapi = JmapI18n::ApiClient.new
    names = jmapi.get(type: "area", lang: params[:lang])
    # エリア情報の全件取得
    begin
      areas = Area.joins(
        'LEFT OUTER JOIN venues ON venues.areaId = areas.areaId
         LEFT OUTER JOIN attributes ON attributes.venueId = venues.venueId and attributes.name IN ("dutyfree","chconcierge")'
        ).select("areas.areaid,areas.lat,areas.lon,areas.url,attributes.name,count(attributes.name) as cname"
        ).where("attributes.name is not null"
        ).group("areas.areaId,attributes.name")
      disareas = editSQLdata(areas)

      info   = create_info(disareas, names)
      output = create_json(code: 0, message: "取得しました。", info: info)
    rescue => err
      # DB処理エラー
      output = create_json(code: 501, message: "DB処理で例外が発生しました。", info: {})
      render :json => output
      return
    end
    
    # 何事もなくjsonの元になるハッシュが作成されたら、json出力して終了
    render :json => output
  end

  ########################################
  # SQL返却値Hash変換処理
  #     return 配列  
  ########################################
  def editSQLdata(areas)
    
    #work変数の作成
    disareas = Array.new
    hareas = Hash.new
    
    #AcctiveRecord型からHash型へ変換
    hareas = ActiveSupport::JSON.decode(areas.to_json)
    
    #　取得したデータ分の繰り返し処理（同一エリアが最大２レコード含まれる：dutyfree,chconcierge）
    for area in hareas do
      darea = disareas.find(ifnone = nil){|item| item["areaid"] == area["areaid"]}
      pois = Hash.new 
      if darea.nil? then
        area["dutyfree"] = 0
        area["chconcierge"] = 0
        darea = Hash.new
        pois = setpoi(darea,area)
        disareas.push(area)
      else
        pois = setpoi(darea,area)
      end
      area = pois[:area]
      darea = pois[:darea]
    end
    return disareas;
  end

  ########################################
  # POIの設定
  #     return 配列  
  ########################################
  def setpoi(darea,area)
    if area["name"] == "dutyfree" then
      darea["dutyfree"] = area["cname"]
      area["dutyfree"] = area["cname"]
    elsif area["name"] == "chconcierge" then
      darea["chconcierge"] = area["cname"]
      area["chconcierge"] = area["cname"]
    end
    return {:darea => darea,:area => area}
  end

  
  ########################################
  # 入力チェック
  #     チェック成功時
  #       result_hash["is_success"] => true
  #     チェック失敗時
  #       result_hash["is_success"] => false  
  ########################################
  def chk_input(args = {})
    # 対応している言語の配列
    # 対応している言語が増えた場合は以下の配列に要素を足すこと。
#    lang_array = ['ja', 'zh-cn']
    
    # - - - - - - - - ▽入力言語チェック▽ - - - - - - - - 
#    unless lang_array.any? {|ln| ln == args[:lang]} then
#      res_hash = {
#        is_success: false,
#        failed_code: 0
#      }
#      return res_hash
#    end
    # - - - - - - - - △入力言語チェック△ - - - - - - - - 
    
    # - - - - - - - - ▽その他のチェック▽ - - - - - - - -
    # 現在、チェックすべき項目は特にありません。
    # - - - - - - - - △その他のチェック△ - - - - - - - -
    
    #すべてのチェックに成功したら
    res_hash = {
      is_success: true
    }
    return res_hash
  end
  
  ########################################
  # 連想配列「info」の生成
  ########################################
  def create_info(areas, names)
    info = {
      area_count: areas.count,
      area_info:  create_area_info(areas, names)
    }
    return info
  end
  
  ########################################
  # 配列「area_info」の生成
  ########################################
  def create_area_info(areas, names)
    # リザルト用の配列を準備。
    # もし一度もループが発生しなければ、空の配列が返る。
    area_info = Array.new
    
    # areasの要素数だけループする
    for area in areas do
      # エリア名を検索し、取得
      name_item = names.find(ifnone = nil){|item| item[:id] == area["areaid"]}

      # Thuan added 20160704

      if(name_item != nil)
        name = name_item[:attrs]["name"]
      else
        name = ""
      end 

      # 配列の要素になるハッシュ
      item = {
        :id               => area["areaid"],                                # ID    --- idとすればオートインクリメントされるIDになる。
        :name             => name,                      # name
        :latitude         => area["lat"],                                   # 緯度
        :longitude        => area["lon"],                                   # 経度
        :duty_free_count  => area["dutyfree"],                              # 免税店の件数
        :concierge_count  => area["chconcierge"],                           # コンシェルジュの件数
        :background_image => area["url"]                                    # 背景画像URL
      }
      
      #値をセット
      area_info << item
    end
    
    return area_info
  end
  
  ########################################
  # 免税店の件数を返す
  ########################################
  #def get_dfs_count(area_id)
  #  # 取得した免税店情報の総数を代入する変数。
  #  # 初期値はゼロ。
  #  dfs_count = 0
  #  
  #  # タイプマスタから免税店のタイプコードを取得。
  #  # 記述時の免税店のタイプコードは「"dutyfree"」
  #  # name = Attribute.find_by(name: "dutyfree").name
  #  
  #  # 施設情報テーブルからIDの合致する施設情報を全件取得
  #  buildings = Venue.where(areaId: area_id)
  #  
  #  # 取得した施設情報の件数ぶんループを行い、
  #  # 店舗属性情報テーブルから、施設IDが合致しており、かつタイプコードが免税店のものである情報をすべて取得。
  #  # その件数を変数に加算後、次のループに移る。
  #  for building in buildings do
  #    store_attributes = Attribute.where(["venueId = ? and name = ?", building.venueId, "dutyfree"])
  #    dfs_count += store_attributes.count
  #  end
  #  
  #  # すべての処理が終了したら、取得していた件数を返す。
  #  return dfs_count
  #end
  
  ########################################
  # 免税店の件数を返す
  ########################################
  #def get_concierge_count(area_id)
  #  # 取得した中国人コンシェルジュ情報の総数を代入する変数。
  #  # 初期値はゼロ。
  #  concierge_count = 0
  #  
  #  # タイプマスタから中国人コンシェルジュのタイプコードを取得。
  #  # 記述時の中国人コンシェルジュのタイプコードは「"dutyfree"」
  #  # name = Attribute.find_by(name: "chconcierge").name
  #  
  #  # 施設情報テーブルからIDの合致する施設情報を全件取得
  #  buildings = Venue.where(areaId: area_id)
  #  
  #  # 取得した施設情報の件数ぶんループを行い、
  #  # 店舗属性情報テーブルから、施設IDが合致しており、かつタイプコードが中国人コンシェルジュのものである情報をすべて取得。
  #  # その件数を変数に加算後、次のループに移る。
  #  for building in buildings do
  #    store_attributes = Attribute.where(["venueId = ? and name = ?", building.venueId, "chconcierge"])
  #    concierge_count += store_attributes.count
  #  end
  #  
  #  # すべての処理が終了したら、取得していた件数を返す。
  #  return concierge_count
  #end
  
  ########################################
  # 免税店の件数を返す
  ########################################
  #def get_count_from_kind(area_id, name)
  #  # 取得した免税店情報の総数を代入する変数。
  #  # 初期値はゼロ。
  #  count = 0
  #  
  #  # 施設情報テーブルからIDの合致する施設情報を全件取得
  #  venueInfo = Venue.select("venueId").where(areaId: area_id)
  #  
  #  venueIds = Array.new
  #  # areasの要素数だけループする
  #  for venue in venueInfo do
  #    #logger.debug venue.venueId
  #    venueIds.push(venue.venueId)
  #  end
  #  
  #  # 取得した施設情報の件数ぶんループを行い、
  #  # 店舗属性情報テーブルから、施設IDが合致しており、かつタイプコードが免税店のものである情報をすべて取得。
  #  # その件数を変数に加算後、次のループに移る。
  #  #for building in buildings do
  #  count = Attribute.where(["venueId in (?) and name = ?", venueIds, name]).count("id")
  #  #  count += store_attributes.count
  #  #end
  #  
  #  # すべての処理が終了したら、取得していた件数を返す。
  #  return count
  #end
  
  ########################################
  # jsonを作成し、返す
  ########################################
  def create_json(args)
    output = {
      response: resp ={
        code:    args[:code],
        message: args[:message],
        info:    args[:info]
      }
    }
  end
end
