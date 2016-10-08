# -*- coding: utf-8 -*-



module JmapI18n

  # def self.entry_point=(url)
  #   @entry_point = url
  # end
  #
  # def self.entry_point
  #  # @entry_point || 'http://api.indoor-map.jp/i18n/'
  #   @entry_point || '/'
  # end


  class ApiClient
    include TextsHelper
    # 指定された識別子に一致する文章エンティティを取得する
    # @param criteria [Hash] 取得条件
    # @option criteria [String] :type データ種別 (必須)
    # @option criteria [String or Array[String]] :id エンティティ識別
    # @option criteria [String or Array[String]] :attr 属性種別
    # @option criteria [String or Array[String]] :lang 言語指定
    # @return [Array[Hash]] 対応する文章エンティティ配列
    # @since 1.0
    def get(criteria = {})
      raise ArgumentError, 'criteria[:type] must not be blank' if criteria[:type].blank?

      criteria = criteria.slice(:type, :id, :attr, :lang)
      rename_attr_to_name! criteria

      # response = post 'query', criteria
      # flatten_attr_values parse_body(response)[:texts]

      response = queryPost ( criteria )
      returnValue = flatten_attr_values response
      return returnValue
    end

    # 指定された単語を翻訳した単語を取得する
    # @param [String] words 元の単語 (必須)
    # @param criteria [Hash] 取得条件
    # @option criteria [String or Array[String]] :type データ種別
    # @option criteria [String or Array[String]] :attr 属性種別
    # @option criteria [String] :from 元の単語の記述言語 (省略時 'ja')
    # @option criteria [String] :to 取得する言語指定 (必須)
    # @return [String] 対応する単語
    # @since 1.0
    def translate(words, criteria = {})
      raise ArgumentError, 'words must not be blank' if words.blank?
      raise ArgumentError, 'criteria[:to] must not be blank' if criteria[:to].blank?

      criteria = criteria.slice(:type, :attr, :from, :to)
      criteria[:word] = words
      criteria[:to] ||= 'ja'
      rename_attr_to_name! criteria

      # response = post 'translate', criteria
      # parse_body(response)[:word]

      response = translatePost ( criteria )
      # parse_body(response)[:word]
      return response
    end

    # 指定された文字列を含む文章エンティティを取得する
    # @param [Array[String]] query 元の単語 (必須)
    # @param criteria [Hash] 取得条件
    # @option criteria [String or Array[String]] :type データ種別
    # @option criteria [String or Array[String]] :attr 属性種別
    # @option criteria [String or Array[String]] :lang 言語指定
    # @return [Array[Hash]] 対応する文章エンティティ配列
    # @since 1.0
    def search(query, criteria = {})
      raise ArgumentError, 'query must not be blank' if query.blank?

      criteria = criteria.slice(:type, :attr, :lang)
      criteria[:value] = query
      rename_attr_to_name! criteria

      # response = post 'query', criteria
      # flatten_attr_values parse_body(response)[:texts]

      response = queryPost ( criteria )
      return flatten_attr_values response
    end

    private
    def rename_attr_to_name!(criteria)
      if criteria.key? :attr
        criteria[:name] ||= criteria[:attr]
        criteria.delete :attr
      end
      criteria
    end

    # def post(function, params)
    #   uri = URI("#{JmapI18n.entry_point}#{function}")
    #   request = Net::HTTP::Post.new uri, initheader = {'Content-Type' =>'application/json'}
    #   request.body = params.to_json
    #   Net::HTTP.start(uri.host, uri.port) do |http|
    #     http.request request
    #   end
    # end
    #
    # def parse_body(response)
    #   body = JSON.parse response.body, symbolize_names: true
    #   body[:response][:info]
    # end

    def flatten_attr_values(texts)
      texts.each do |text|
        (attrs = text[:attrs]).each do |k,v|
          case v
          when Hash
            (lang = v).each do |k, v|
              lang[k] = v[0] if v.kind_of? Array
            end
          when Array
            attrs[k] = v[0]
          end
        end
      end
    end

    # Controller method
    # GET/POST query
    def queryPost (params)
      criteria = {}
      [:type, :id, :name, :lang, :value].each do |key|
        if params[key].present?
          ckey = key == :id ? :entity_id : key
          criteria[ckey] = params[key]
        end
      end

      if criteria.key? :value
        value = criteria[:value]
        criteria[:value] = if value.kind_of? Array
                             value.map { |v| "%#{v}%" }
                           else
                             "%#{value}%"
                           end
      end

      @texts = Text.query criteria
      @options = { ignore_lang: params[:lang].kind_of?(String) }

      # Code from view
      return  texts_to_tree(@texts, @options).to_array

    end

    # GET/POST translate
    def translatePost (params)
      criteria = {}
      [:type, :name, :from, :to].each do |key|
        criteria[key] = params[key] if params[key]
      end
      return Text.translate params[:word], criteria
    end
  end
end
