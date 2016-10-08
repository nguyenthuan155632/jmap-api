require 'jmap-i18n/api_client'
class GetIndoorMapController < ApplicationController
  def get_indoor_map
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
    
    # ログ出力用の連想配列
    log_hash = Hash.new

    # ログ出力
    log_hash[:building_id] = params[:building_id]
    log_hash[:lang] = params[:lang]
    log_hash[:controller] = params[:controller]
    send(:log_output, 'JB006', log_hash)

    # jsonのパーツとなるinfoハッシュを作成
    begin
      info = create_info(params)
    rescue => err
      output = create_json(code: 501, message: err.to_s)#"DB処理に失敗しました。")
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
    if id == '' then
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
  # jsonのパーツとなるinfoハッシュを作成
  ##############################
  private
  def create_info(params)

    # 店舗情報配列を作成
    shop_info = Array.new

    # 免税店情報配列を作成
    duty_free_info = Array.new

    # コンシェルジュ情報配列を作成
    concierge_info = Array.new

    # 施設情報からショップ情報を取得
    # 取得したショップ情報の件数分だけループ処理
    shops = Shop.joins(
        'LEFT OUTER JOIN category_set ON category_set.shopId = shops.shopId
        LEFT OUTER JOIN category_master ON category_master.category_id = category_set.category_id'
    ).select('shops.*, category_set.category_id, category_master.category_parentId'
    ).where('shops.venueId = ?', params[:building_id]
    ).order('shops.floorId ASC')

    # Thuan added 20160705
    cate_master = CategoryMaster.select('category_id, category_parentId')
    taxfree = Attribute.joins(
      'LEFT OUTER JOIN shops ON shops.shopId = attributes.shopId'
      ).select(
      'attributes.shopId, name, value, floorId'
      ).where('name = ? and attributes.venueId = ?', 'dutyfree', params[:building_id])

    concierge = Attribute.joins(
      'LEFT OUTER JOIN shops ON shops.shopId = attributes.shopId'
      ).select(
      'attributes.shopId, name, value, floorId'
      ).where('name = ? and attributes.venueId = ?', 'chconcierge', params[:building_id])
    #End

    # entity_ids = Array.new
    # for shop in shops do
    #   entity_ids << shop.shopId
    # end
    entity_ids = shops.all.collect {|shop| shop.shopId}

    # texts_by_entity_ids = Texts.with_entity_ids(entity_ids)

    lang_where = Texts.arel_table[:lang].eq(params[:lang])
    name_where = Texts.arel_table[:name].in(["name", "icname", "dutyfree", "chconcierge"])
    entity_ids_where = Texts.arel_table[:entity_id].in(entity_ids)
    texts_by_entity_ids = Texts.where (lang_where.and(name_where).and(entity_ids_where))

    # text_list = {}
    # texts_by_entity_ids.each do |t|
    #   if t['lang'] == params[:lang] && (t['name'] == 'name' || t['name'] == 'icname' || t['name'] == 'dutyfree' || t['name'] == 'chconcierge')
    #     text_list[t['entity_id']] = t
    #   end
    # end

    text_list = {}
    texts_by_entity_ids.each do |t|
        text_list[t['entity_id']] = t
      end


    drawingIds = Array.new
    shops.each do |s|

      if text_list[s['shopId']] then
        itemTextList = text_list[s['shopId']]
        if (itemTextList.name == 'name' || itemTextList.name == 'icname') #&& text_list[s['shopId']].lang == params[:lang]
          if !drawingIds.index(s['drowingId']) then
            drawingIds << s['drowingId']
          end

          fragment = {
              drawing_id:         s['drowingId'],
              drawing_index:      drawingIds.index(s['drowingId']),
              shop_id:            s['shopId'],
              shop_name:          itemTextList.value,
              floor_number:       s['floor_number'],
              floor_id:           s['floorId'],
              category_parentId:  s['category_parentId'],
              category_id:        s['category_id']
          }
          shop_info << fragment
        end
        if itemTextList.name == 'dutyfree' #&& text_list[s['shopId']].lang == params[:lang]
          fragment = {
              :duty_free_id => s['shopId'],
              :duty_free_name => itemTextList.name,
              :duty_free_description => itemTextList.value
          }
          duty_free_info << fragment
        elsif itemTextList.name == 'chconcierge' #&& text_list[s['shopId']].lang == params[:lang]
          fragment = {
              :concierge_id => s['shopId'],
              :concierge_name => itemTextList.name,
              :concierge_description => itemTextList.value
          }
          concierge_info << fragment
        end
      end
    end

    lang_where = Texts.arel_table[:lang].eq(params[:lang])
    name_where = Texts.arel_table[:name].eq("name")
    entity_ids_where = Texts.arel_table[:entity_id].eq(params[:building_id])
    v_item = Texts.where (lang_where.and(name_where).and(entity_ids_where))

    #v_item = Texts.where("`name` = 'name' and entity_id ='"+params[:building_id]+"'")
    building = ''
    v_item.each do |a|
      if a['lang'] == params[:lang]
        building =  a['value']
      end
    end

    venue_info = Venue.find_by_venueId(params[:building_id])
    if venue_info.business == 'airport' then
      info = {
          building_id: params[:building_id],
          building_name: building,
          drawing_ids: drawingIds,
          last_updated: venue_info.last_updated,
          shop_info: shop_info,
          duty_free_info: duty_free_info,
          concierge_info: concierge_info,
          category_master: cate_master,
          taxfree: taxfree,
          concierge: concierge
      }
    else
      info = {
          building_id: params[:building_id],
          building_name: building,
          last_updated: venue_info.last_updated,
          shop_info: shop_info,
          duty_free_info: duty_free_info,
          concierge_info: concierge_info,
          category_master: cate_master,
          taxfree: taxfree,
          concierge: concierge
      }
    end
    return info
  end

  ########################################
  # jsonの元になるハッシュを生成する
  ########################################
  private
  def create_json(args = {})
    args = {
      code:    0,
      message: '取得しました。',
      info: {}
    }.merge(args)
    
    output = {
      response: args
    }
    return output
  end
end
