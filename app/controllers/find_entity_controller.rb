#FindEntityController2

require 'jmap-i18n/api_client'

class FindEntityController < ApplicationController
  def find_entity
    building_id = params[:building_id]
    search_word = params[:search_word]
    
    #入力チェックを行う
    lang = params[:lang]
#    if lang != 'ja' && lang != 'zh-cn' then
#      output = create_json(code: 102, message: "出力言語の指定が不正です。")
#      render :json => output
#      return
#    end

    res_chk = chk_input(id: building_id, word: search_word)
    unless res_chk[:is_success] then
      #弾かれコードが０ ---> 未入力の値があった
      if res_chk[:failed_code] == 0 then
        output = create_json(code: 101, message: "#{res_chk[:not_input]}が未入力です。")
        render :json => output
        return
        
      #弾かれコードが１ ---> 不正な値が入っていた
      elsif res_chk[:failed_code] == 1 then
        output = create_json(code: 101, message: "#{res_chk[:issue_val]}に不正な値が入力されています。")
        render :json => output
        return
      end
    end
    
    #入力チェックで弾かれなかったら
    venue_id = res_chk[:building_id]
    
    # ログ出力用の連想配列
    log_hash = Hash.new

    # ログ出力
    log_hash[:lang] = lang
    log_hash[:building_id] = venue_id
    log_hash[:search_word] = search_word
    log_hash[:controller] = params[:controller]
    send(:log_output, 'JB008', log_hash)

    # 多言語対応APIを叩く
    jmapi = JmapI18n::ApiClient.new
    names = jmapi.search(search_word, type: 'shop', attr: [:name, :icname], lang: lang)

    #検索
    begin
      shops = Shop.where(venueId: venue_id)
    rescue => ex
      output = create_json(code: 501, message: "DBの処理中に問題が発生しました。#{ex}")
      render :json => output
      return
    end
    
    # infoにするために整形して出力
    info = create_infoarray(shops, names)
    output = create_json(code: 0, message: "取得しました。", entity_info: info)
    render :json => output
  end
  
  #----------------------------------------
  #      入力チェックを行う
  #      ---入力が正常----
  #       is_success ---> true
  #      building_id ---> 数値化されたID
  #      search_word ---> そのままの値
  #      
  #      ---入力が異常---
  #       is_success ---> false
  #      failed_code ---> 0...未入力、1...想定していない値
  #----------------------------------------
  private
  def chk_input(args = {})
    #building_idが入力されているか否かを確かめる
    unless args[:id] then
      result = {
        is_success: false,
        failed_code: 0,
        not_input: "building_id"
      }
      return result
    end
    
    #search_wordが入力されているか否かを確かめる
    unless args[:word] then
      result = {
        is_success: false,
        failed_code: 0,
        not_input: "search_word"
      }
      return result
    end
    
    #どっちにも引っかからなかった場合は、building_idを整数にして返す
    begin
      result = {
        is_success: true,
        building_id: Integer(args[:id])
      }
      return result
    rescue
      result = {
        is_success: false,
        failed_code: 1,
        issue_val: "building_id"
      }
      return result
    end
  end
  
  #----------------------------------------
  #      検索結果を配列に整形して出力
  #----------------------------------------
  private
  def create_infoarray(shops, shop_names)
    # Get array of shop id
    entity_ids =  getValidShopId(shops, shop_names)

    shop_images = getShopImages(entity_ids)
    shop_categories = getCategories(entity_ids, params[:lang])

    res_array = Array.new
    for shop_info in shops do
      name_item = shop_names.find(ifnone = nil){|item| item[:id] == shop_info.shopId}
      if name_item.presence then
        hash = {
          :building_id => shop_info.venueId,
          :floor_id => shop_info.floorId,
          :shop_id => shop_info.shopId,
          :drowing_id => shop_info.drowingId,
            :shop_name => name_item[:attrs]["name"].presence || '',
            :icon_name => name_item[:attrs]["icname"].presence || '',
            :shop_image => getShopImage(shop_info.shopId, shop_images) || '',
            :shop_category => getCategory(shop_info.shopId,params[:lang], shop_categories) || ''
        }
        
        res_array << hash
      
      end
    end
    
    return res_array
  end
  
  #----------------------------------------
  #      店舗の画像・ロゴ情報を返却
  #----------------------------------------
  private
  def getShopImages(entity_ids)
    image_where = Attribute.arel_table[:name].eq("image")
    entity_ids_where = Attribute.arel_table[:shopId].in(entity_ids)
    shop_images = Attribute.where (image_where.and(entity_ids_where))
    return shop_images
  end
  
  #----------------------------------------
  #      店舗の画像・ロゴ情報を返却
  #----------------------------------------
  private
  def getShopImage(shopId, shop_images)
    ret = nil
    # attributes = Attribute.where(shopId: shop_info.shopId,name: 'image')
    # if attributes.presence then
    #   ret = attributes[0].value
    # end
    attributes = shop_images.find(ifnone = nil){|item| item['shopId'] == shopId}
    if !attributes.nil? then
      ret = attributes['value']
    end 
    return ret
  end

  #----------------------------------------
  #      店舗のカテゴリを取得
  #----------------------------------------
  private
  def getCategory(shopId, lang, shop_categories)
    ret = nil
    # jmapi = JmapI18n::ApiClient.new
    # data = jmapi.get({type: 'shop', id: shopId ,attr: 'category' , lang: lang})
    # if data.presence then
    #    ret = data[0][:attrs]["category"]
    # end
    data = shop_categories.find(ifnone = nil){|item| item['entity_id'] == shopId}
    if !data.nil? then
      ret = data['value']
    end
    return ret
  end

  private
  def getValidShopId(shops, shop_names)
    entity_ids = Array.new
    for shop_info in shops do
      # entity_ids.push(item[:id])
      name_item = shop_names.find(ifnone = nil){|item| item[:id] == shop_info.shopId}
      if name_item.presence then
        entity_ids.push(shop_info.shopId)
      end
    end
    return entity_ids
    end


  #----------------------------------------
  #      店舗のカテゴリを取得
  #----------------------------------------
  private
  def getCategories(entity_ids, lang)
    type_where = Texts.arel_table[:type].eq("shop")
    lang_where = Texts.arel_table[:lang].eq(lang)
    name_where = Texts.arel_table[:name].eq("category")
    entity_ids_where = Texts.arel_table[:entity_id].in(entity_ids)
    shop_categories = Texts.where (type_where.and(lang_where.and(name_where).and(entity_ids_where)))
    return shop_categories
  end

  
  
  #----------------------------------------
  #      json用の連想配列を作成する
  #----------------------------------------
  private
  def create_json(args = {})
    args = {
      entity_info: Array.new
    }.merge(args)
    
    output = {
      response: resp = {
        code: args[:code],
        message: args[:message],
        entity_info_count: args[:entity_info].count,
        entity_info: args[:entity_info]
      }
    }
  end
end
