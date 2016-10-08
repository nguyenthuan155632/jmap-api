require 'jmap-i18n/api_client'

class GetLangController < ApplicationController
  def get_lang
    # デフォルトlang
    default_locale = "en"
    default_lang = "en"
    select_locale = params[:locale]
    result_lang = ""
    
    # nullが入っているとき
    unless select_locale then
      select_locale = default_locale
    end
    
    # 空文字が入っているとき
    if select_locale == "" then
      select_locale = default_locale
    end
    
    # DBからデータ取得
    result = ConversionLocale.where("locale = :locale", locale: select_locale.downcase)

    # DBになければ
    unless result[0] then
        # なにもしない
    # あれば
    else
        result_lang = result[0].lang
    end
    
    if result_lang == "" then
      result_lang = default_lang
    end
    
    output = create_json(code: 0, message: "処理が正常に完了しました。", info: result_lang)
    
    # 何事もなくjsonの元になるハッシュが作成されたら、json出力して終了
    render :json => output
  end
  
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
