class InquiryController < ApplicationController
  def create

    # res_hash = chk_value(params)
    # unless res_hash[:is_success] then
    #   if  res_hash[:failed_code] == 0 then
    #     output = create_json(code: 102, message: "パラメータの値が不正です。")
    #     render :json => output
    #     return
    #   end
    # end



    # jsonのパーツとなるinfoハッシュを作成
    begin
      info = insert_data(params)
      # info = {
      #     status: 0,
      #     message: params[:emailaddress],
      #     msg: params[:content]
      # }
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

  ##chk_value
  private
  def chk_value(vals)
    unless vals[:emailaddress] then
      res_hash = {
          is_success:  false,
          failed_code: 1
      }
      return res_hash
    end

    if vals[:emailaddress] == '' then
      res_hash = {
          is_success:  false,
          failed_code: 1
      }
      return res_hash
    end

    unless vals[:content] then
      res_hash = {
          is_success:  false,
          failed_code: 1
      }
      return res_hash
    end

    if vals[:content] == '' then
      res_hash = {
          is_success:  false,
          failed_code: 1
      }
      return res_hash
    end
  end

  private
  def insert_data(vals)
    inq = Inquiry.new
    inq.emailaddress = vals[:emailaddress]
    inq.content = vals[:content]
    if inq.save!
      info = {
          status: 0,
          message: 'saved.'
      }
      return info
    end

  end

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
