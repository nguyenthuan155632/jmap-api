class OutputLogController < ApplicationController
  #---------------------
  # ログ出力(経路案内)
  #---------------------
  def output_log_route_guidance
    lang = params[:lang]

    # ログ出力用の連想配列
    log_hash = Hash.new

    # ログ出力
    log_hash[:lang] = lang

    # パラメータチェック処理
    check_result = check_route_guidance_param(params)
    if check_result then
      log_hash[:from_geometry_id] = params[:from_geometry_id]
      log_hash[:from_floor_id] = params[:from_floor_id]
      log_hash[:to_geometry_id] = params[:to_geometry_id]
      log_hash[:to_floor_id] = params[:to_floor_id]
      log_hash[:controller] = params[:controller]
      log_hash[:action] = params[:action]
      log_output('JB009-1', log_hash)
    end

    render :nothing => true
  end
  
  #---------------------
  # ログ出力(中国人コンシェルジュ利用率)
  #---------------------
  def output_log_chinese_concierge
    lang = params[:lang]

    # ログ出力用の連想配列
    log_hash = Hash.new

    # ログ出力
    log_hash[:lang] = lang

    # パラメータチェック処理
    check_result = check_chinese_concierge_param(params)
    if check_result then
      log_hash[:cc_narrow_num] = params[:cc_narrow_num]
      log_hash[:controller] = params[:controller]
      log_hash[:action] = params[:action]
      log_output('JB009-2', log_hash)
    end

    render :nothing => true
  end

  #---------------------
  # ログ出力(免税店検索利用率)
  #---------------------
  def output_log_dfs_search
    lang = params[:lang]

    # ログ出力用の連想配列
    log_hash = Hash.new

    # ログ出力
    log_hash[:lang] = lang

    # パラメータチェック処理
    check_result = check_dfs_search_param(params)
    if check_result then
      log_hash[:dfs_narrow_num] = params[:dfs_narrow_num]
      log_hash[:controller] = params[:controller]
      log_hash[:action] = params[:action]
      log_output('JB009-3', log_hash)
    end
    render :nothing => true
  end

  #---------------------
  # パラメータチェック処理(経路案内)
  #---------------------
  private
  def check_route_guidance_param(params)
    check_result = true
    # 経路案内ログ出力パラメータチェック
    if params[:from_geometry_id].empty?
      check_result = false
    end

    if params[:from_floor_id].empty?
      check_result = false
    end

    if params[:to_geometry_id].empty?
      check_result = false
    end

    if params[:to_floor_id].empty?
      check_result = false
    end
    return check_result
  end

  #---------------------
  # パラメータチェック処理(中国人コンシェルジュ利用率)
  #---------------------
  private
  def check_chinese_concierge_param(params)
    check_result = true
    # 中国人コンシェルジュ利用率パラメータチェック
    if params[:cc_narrow_num].empty?
      check_result = false
    end
    return check_result
  end

  #---------------------
  # パラメータチェック処理(免税店検索利用率)
  #---------------------
  private
  def check_dfs_search_param(params)
    check_result = true
    # 免税店検索利用率パラメータチェック
    if params[:dfs_narrow_num].empty?
     check_result = false
    end
    return check_result
  end
end
