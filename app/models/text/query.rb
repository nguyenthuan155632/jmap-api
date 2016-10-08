# -*- coding: utf-8 -*-

class Text

  # 指定された検索条件に一致する文章エンティティを取得する
  # @param criteria [Hash] (必須)
  # @option criteria [String or Array[String]] :type データ種別
  # @option criteria [String or Array[String]] :entity_id エンティティ識別
  # @option criteria [String or Array[String]] :name 属性名
  # @option criteria [String or Array[String]] :lang 言語指定
  # @option criteria [String Array[String]] :value 単語（部分一致）
  # @return [Array[Hash]] 対応する文章エンティティ配列
  # @since 1.0
  def self.query(criteria)
    raise ArgumentError, 'criteria must not be nil' if criteria.nil?
    query = Text.where(criteria.slice(:type, :entity_id, :name, :lang))

    if criteria.key? :value
      value = criteria[:value]
      like = '(value like ? )'
      if value.kind_of? Array
        query = query.where(([like] * value.size).join(' OR '), *value)
      else
        query = query.where(like, value)
      end
    end

    query.all
  end

end
