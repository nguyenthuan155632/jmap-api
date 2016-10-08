require 'jmap-i18n/api_client'

class GetAirportsController < ApplicationController
  def get_airports
    # 多言語APIを叩く
    jmapi      = JmapI18n::ApiClient.new
    lang_array = jmapi.get(type: 'venue', lang: params[:lang])
    logger.info(params[:lang])

    # jsonのパーツとなるinfoハッシュを作成
    info = create_info(lang_array: lang_array)

    # jsonの元になるハッシュを作成
    output = create_json(info: info)
    render :json => output
    return
  end

  ##############################
  # jsonのパーツとなるinfoハッシュを作成
  ##############################
  private
  def create_info(values)
    # 施設情報用の配列
    building_info = Array.new
    airportIds = Array.new
    venues = Venue.where('venues.areaId  = 11')
    for venue in venues do
      airportIds.push(venue.venueId)
    end

    #施設情報を取得する
    venues = Venue.joins(
        'LEFT OUTER JOIN attributes ON attributes.venueId = venues.venueId and attributes.name IN ("dutyfree","chconcierge")'
    ).select('venues.last_updated, venues.display_flag, venues.venueId,venues.lat,venues.lon,venues.business,venues.zipCode,venues.officialUrl,attributes.name,count(attributes.name) as cname'
    ).where('venues.venueId IN (?)', airportIds
    ).group('venues.venueId,attributes.name')

    dvenue = editSQLdata(venues)

    #施設情報を作成する
    for venue in dvenue do
      b_info = create_building_info(venue, values[:lang_array])
      if !b_info.nil? then
        building_info << create_building_info(venue, values[:lang_array])
      end
    end

    info = {
        building_count: building_info.count,
        building_info:  building_info
    }
    return info
  end

  ##############################
  # jsonのパーツとなるinfoハッシュを構成するbuilding_info配列を作成する
  ##############################
  def create_building_info(venue, lang_array)
    lang_item = lang_array.find(ifnone = nil){|item| item[:id] == venue["venueId"]}
    if lang_item.nil? then
      return nil
    else
      item = {
          id:              venue["venueId"],
          last_updated:     venue['last_updated'],
          display_flag:    venue['display_flag'],
          name:            lang_item[:attrs]["name"],
          zip:             venue["zipCode"],
          address:         lang_item[:attrs]["address"],
          content:         lang_item[:attrs].has_key?("content") ? lang_item[:attrs]["content"] : '',
          url:             venue["officialUrl"],
          exist_duty_free: isPoi(venue,"dutyfree"),
          exist_concierge: isPoi(venue,"chconcierge"),
          latitude: venue["lat"],
          longitude: venue["lon"],
          business: venue["business"]
      }
      return item
    end
  end

  ########################################
  # SQL返却値Hash変換処理
  #     return 配列
  ########################################
  def editSQLdata(venues)

    #work変数の作成
    disvenues = Array.new
    hvenues = Hash.new

    #AcctiveRecord型からHash型へ変換
    hvenues = ActiveSupport::JSON.decode(venues.to_json)

    #　取得したデータ分の繰り返し処理（同一エリアが最大２レコード含まれる：dutyfree,chconcierge）
    for venue in hvenues do
      dvenue = disvenues.find(ifnone = nil){|item| item['venueId'] == venue['venueId']}
      pois = Hash.new
      if dvenue.nil? then
        venue['dutyfree'] = 0
        venue['chconcierge'] = 0
        dvenue = Hash.new
        pois = setpoi(dvenue,venue)
        disvenues.push(venue)
      else
        pois = setpoi(dvenue,venue)
      end
      venue = pois[:venue]
      dvenue = pois[:dvenue]
    end
    return disvenues;
  end

  ##############################
  # jsonの元になるハッシュを生成
  ##############################
  def create_json(args = {})
    args = {
        code:    0,
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


  ########################################
  # POIの設定
  #     return 配列
  ########################################
  def setpoi(dvenue,venue)
    if venue['name'] == 'dutyfree' then
      dvenue['dutyfree'] = venue['cname']
      venue['dutyfree'] = venue['cname']
    elsif venue['name'] == 'chconcierge' then
      dvenue['chconcierge'] = venue['cname']
      venue['chconcierge'] = venue['cname']
    end
    return {:dvenue => dvenue,:venue => venue}
  end

  ##############################
  # jspoiの存在有無を返却する。
  ##############################
  def isPoi(venue,name)

    if name == "dutyfree" then
      if venue["dutyfree"] > 0 then
        return 1
      end
    elsif name == "chconcierge" then
      if venue["chconcierge"] > 0 then
        return 1
      end
    end
    return 0
  end

end