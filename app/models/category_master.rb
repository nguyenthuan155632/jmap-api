# ## Schema Information
#
# Table name: `category_master`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`id`**                | `integer`          | `not null, primary key`
# **`category_id`**       | `string(255)`      | `not null`
# **`category_parentId`** | `string(255)`      |
# **`categoryAttr1`**     | `string(255)`      |
# **`created_at`**        | `datetime`         | `not null`
# **`updated_at`**        | `datetime`         | `not null`
#

class CategoryMaster < ActiveRecord::Base
    self.table_name = 'category_master'
end
