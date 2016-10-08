require 'arel'

class Texts < ActiveRecord::Base
  self.inheritance_column = :_type
  scope :with_type, ->(type) {where(Texts.arel_table[:_type].in(type))}
  scope :with_entity_ids, ->(entity_ids) {where(Texts.arel_table[:entity_id].in(entity_ids))}

  #Category.arel_table[:id].in(category_ids)
end