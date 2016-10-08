class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  #--------------------------------------------
  # ログ出力
  # ログ出力内容
  # 共通項目:利用言語
  # 個別項目
  # JB001:なし
  # JB002:エリアID
  # JB003:検索ワード
  # JB004:なし
  # JB005:施設ID
  # JB006:施設ID
  # JB007:エンティティID
  # JB008:検索ワード、施設ID
  # JB009:
  #--------------------------------------------
  def log_output(api_no, output_data)
    case api_no
     when 'JB001'#get_areas_controller.rb
      Rails.application.config.another_logger.info("controller:#{output_data[:controller]}　lang:#{output_data[:lang]}")
     when 'JB002'#find_buildings_controller.rb
      Rails.application.config.another_logger.info("controller:#{output_data[:controller]}　lang:#{output_data[:lang]} area_id:#{output_data[:area_id]}")
     when 'JB003'#find_areas_buildings_controller.rb
      Rails.application.config.another_logger.info("controller:#{output_data[:controller]}　lang:#{output_data[:lang]} search_word:#{output_data[:search_word]}")
     when 'JB004'#find_buildings_with_radius_controller.rb
      Rails.application.config.another_logger.info("controller:#{output_data[:controller]}　lang:#{output_data[:lang]} latitude:#{output_data[:latitude]} longitude:#{output_data[:longitude]} radius:#{output_data[:radius]}")
     when 'JB005', 'JB006' #get_buildings_entrance_image_url_controller.rb,get_indoor_map_controller.rb
      Rails.application.config.another_logger.info("controller:#{output_data[:controller]}　lang:#{output_data[:lang]} building_id:#{output_data[:building_id]}")
     when 'JB007'#find_properties_controller.rb
      Rails.application.config.another_logger.info("controller:#{output_data[:controller]}　lang:#{output_data[:lang]} entity_id:#{output_data[:entity_id]}")
     when 'JB008'#find_entity_controller.rb
      Rails.application.config.another_logger.info("controller:#{output_data[:controller]}　lang:#{output_data[:lang]} search_word:#{output_data[:search_word]}　building_id:#{output_data[:building_id]}")
     when 'JB009-1'#output_log_controller.rb output_log_route_guidance
      Rails.application.config.another_logger.info("controller:#{output_data[:controller]}　action:#{output_data[:action]}　lang:#{output_data[:lang]} from_geometry_id:#{output_data[:from_geometry_id]} from_floor_id:#{output_data[:from_floor_id]} to_geometry_id:#{output_data[:to_geometry_id]} to_floor_id:#{output_data[:to_floor_id]}")
     when 'JB009-2'#output_log_controller.rb output_log_chinese_concierge
      Rails.application.config.another_logger.info("controller:#{output_data[:controller]}　action:#{output_data[:action]}　lang:#{output_data[:lang]} cc_narrow_num:#{output_data[:cc_narrow_num]}")
     when 'JB009-3'#output_log_controller.rb output_log_dfs_search
      Rails.application.config.another_logger.info("controller:#{output_data[:controller]}　action:#{output_data[:action]}　lang:#{output_data[:lang]} dfs_narrow_num:#{output_data[:dfs_narrow_num]}")
    end
  end
end
