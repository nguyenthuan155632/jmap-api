# ## Schema Information
#
# Table name: `texts`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `integer`          | `not null, primary key`
# **`type`**        | `string(10)`       | `not null`
# **`entity_id`**   | `string(20)`       | `not null`
# **`name`**        | `string(20)`       | `not null`
# **`lang`**        | `string(10)`       | `not null`
# **`value`**       | `text(65535)`      | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_texts_on_type_and_entity_id_and_name_and_lang` (_unique_):
#     * **`type`**
#     * **`entity_id`**
#     * **`name`**
#     * **`lang`**
#

class Text < ActiveRecord::Base

  self.inheritance_column = :_type_disabled

  concerned_with :query, :translate

end
