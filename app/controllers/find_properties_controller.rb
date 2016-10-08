require 'jmap-i18n/api_client'

class FindPropertiesController < ApplicationController
  def find_properties
    lang = params[:lang]
#    if lang != 'ja' && lang != 'zh-cn' then
#      code = 102
#      message = "出力言語の指定が不正です。"
#      output = create_json(code: 102, message: message)
#      render :json => output
#      return
#    end

    # 入力チェック
    # 成功したら整数に変えたIDを返す。失敗したらそのことをJSONにして表示
    res_hash = chk_input(entity_id: params[:entity_id])
    unless res_hash[:is_success] then
      # 弾かれコード : 1 => 未入力エラー
      if res_hash[:failed_code] === 1 then
        code = 101
        message = "IDが未入力です。"
        
      # 弾かれコード : 2 => IDが数値以外
      elsif res_hash[:failed_code] === 2 then
        code = 101
        message = "IDの値が不正です。"
        
      # 弾かれコード : 4 => 未定
      # 弾かれコード : 5 => 未定
      # 弾かれコード : 6 => 未定
      # 弾かれコード : ? => なんかよくわからんけどとりあえずエラー
      else
        code = 101
        message = "unknown error"
      end
      
      # JSONを生成して出力し、処理を終える。
      output = create_json(code: code, message: message)
      render :json => output
      return
    end
    
    # ログ出力用の連想配列
    log_hash = Hash.new

    # ログ出力
    log_hash[:lang] = lang
    log_hash[:entity_id] = params[:entity_id]
    log_hash[:controller] = params[:controller]
    send(:log_output, 'JB007', log_hash)

    # エラーを発生させずに処理を終えたら、数値化されたIDを取得
    entity_id = res_hash[:entity_id]
    
    # モデルから配列を作成。該当するデータがなければ空の配列を返す。
    begin
      attribute = get_attribute(shop_id: entity_id, lang: lang)
    rescue
      output = create_json(code: 502, message: "DBの処理に失敗しました。")
      render :json => output
      return
    end
    
    # JSONを生成し、出力して終了。
    output = create_json(code: 0, message: "取得しました。", entity_properties: attribute)
    render :json => output
  end
  
  #------------------------------
  # 入力チェックメソッド
  # pass
  #   is_success => true
  #   entity_id  => 文字列で入ってきたentity_idを数値化したもの
  # 
  # failed
  #   is_success => false
  #   failed_code => 1.未入力, 2.値が不正
  #------------------------------
  private
  def chk_input(args = {})
    # 未入力チェック
    unless args[:entity_id] then
      res_hash = {
        is_success: false,
        failed_code: 1
      }
      return res_hash
    end
    
    # 未入力チェックに成功していたら、
    begin
      id_int = Integer(args[:entity_id])
    rescue
      res_hash = {
        is_success: false,
        failed_code: 2
      }
      return res_hash
    end
    
    # idの正数化にも成功したら
    res_hash = {
      is_success: true,
      entity_id: id_int
    }
  end
  
  #------------------------------
  # entity_idから店舗属性を取得
  # 数がゼロだった場合は空の配列を返す。
  #------------------------------
  def get_attribute(args={})
    attributes = Attribute.where(shopId: args[:shop_id])

    res_hash = Hash.new

    # 多言語対応APIを叩く
    jmapi = JmapI18n::ApiClient.new
    shop_attr = jmapi.get(type: "shop", id: args[:shop_id], lang: args[:lang])

    # attrsの要素を取得
    shop_attr_item = shop_attr[0][:attrs].stringify_keys

    for attr_item in attributes do

      if attr_item.value == '' || attr_item.value == nil then
        attr_value = shop_attr_item[attr_item.name]
      else
        attr_value = attr_item.value
      end
      res_hash[attr_item.name] = attr_value
    end
    
    return res_hash
  end

  #------------------------------
  # JSONを生成する
  #------------------------------
  def create_json(args = {})
    args = {
      entity_properties: Array.new,
      jmap_entities: Array.new
    }.merge(args)
    
    output = {
      response: resp = {
        code: args[:code],
        message: args[:message],
        entity_properties: args[:entity_properties]
      }
    }
    return output
  end
end
