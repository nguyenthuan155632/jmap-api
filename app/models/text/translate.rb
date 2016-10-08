# -*- coding: utf-8 -*-

class Text

  # 指定された単語を翻訳した単語を取得する
  # @overload translate(word, criteria)
  #   @param [String] word 元の単語 (必須)
  #   @param [Hash] criteria (必須)
  #   @option criteria [String or Array[String]] :type データ種別
  #   @option criteria [String or Array[String]] :name 属性名
  #   @option criteria [String] :from 元の単語の記述言語
  #   @option criteria [String] :to 取得する言語指定 (必須)
  #   @return [String] 対応する単語
  # @overload translate(words, criteria)
  #   @param [Array[String]] word 元の単語 (必須)
  #   @param [Hash] criteria (必須)
  #   @return [Array[String]] 対応する単語
  # @since 1.0
  def self.translate(word, criteria)
    raise ArgumentError, 'word must not be nil' unless word
    raise ArgumentError, 'criteria must not be nil' if criteria.nil?
    raise ArgumentError, 'criteria[:to] must not be nil' unless criteria[:to]

    _translate = ->(word) {
      query = Text.where(value: word)
      query = query.where(type: criteria[:type]) if criteria[:type]
      query = query.where(name: criteria[:name]) if criteria[:name]
      query = query.where(lang: criteria[:from]) if criteria[:from]
      found = query.first

      # TODO: 1クエリで実行できるようにすること
      if found
        Text.where(type: found.type, entity_id: found.entity_id, name: found.name, lang: criteria[:to])
          .pluck(:value).first
      end
    }

    if word.kind_of? Array
      word.map { |word| _translate.call word }
    else
      _translate.call word
    end
  end

end
