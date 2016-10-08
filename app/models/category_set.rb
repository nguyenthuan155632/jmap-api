# ## Schema Information
#
# Table name: `category_set`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `integer`          | `not null, primary key`
# **`catset_id`**   | `string(255)`      |
# **`category_id`** | `string(255)`      | `not null`
# **`shopId`**      | `string(255)`      | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#

class CategorySet < ActiveRecord::Base
    self.table_name = 'category_set'
end
