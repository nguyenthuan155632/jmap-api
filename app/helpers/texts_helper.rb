# -*- coding: utf-8 -*-
module TextsHelper

  # Text配列をキー値に基づいたツリー構造のハッシュに変換する
  # @param texts [Array[Text]]
  # @options options :ignore_lang [bool] 言語コードをハッシュに含めない(false)
  # @return [HASH] 言語コードあり { type => entity_id => name => lang => [ values... ] }
  # @return [HASH] 言語コードなし { type => entity_id => name => [ values... ] }　
  def texts_to_tree(texts, options = {})
    ignore_lang = options[:ignore_lang] || false

    types = {}
    texts.each do |t|
      ids = (types[t.type] ||= {})
      names = (ids[t.entity_id] ||= {})
      if ignore_lang or t.lang.blank?
        names[t.name] ||= []
      else
        langs = (names[t.name] ||= {})
        langs[t.lang] ||= []
      end << t.value
    end

    def types.to_array
      TextsHelper.texttree_to_array self
    end

    types
  end

  # to_treeで生成されたハッシュツリーを基に、typeとentity_idを集約した配列を生成する
  # @param [Hash]
  # @return [Array] 言語コードあり [ { type: type, id: entity_id, attrs: { name => lang => [ values... ] } }... ]
  # @return [Array] 言語コードなし [ { type: type, id: entity_id, attrs: { name => [ values... ] } }... ]
  def self.texttree_to_array(tree)
    tree.map do |type, ids|
      ids.map do |id, names|
        { type: type, id: id, attrs: names }
      end
    end.flatten
  end

end
