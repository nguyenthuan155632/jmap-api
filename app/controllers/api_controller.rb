class ApiController < ApplicationController

  # GET/POST query
  def query
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
  end

  # GET/POST translate
  def translate
    criteria = {}
    [:type, :name, :from, :to].each do |key|
      criteria[key] = params[key] if params[key]
    end
    @word = Text.translate params[:word], criteria
  end

 end
