# ## Schema Information
#
# Table name: `shops`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `integer`          | `not null, primary key`
# **`venueId`**     | `string(255)`      | `not null`
# **`drowingId`**   | `string(255)`      | `not null`
# **`floorId`**     | `string(255)`      | `not null`
# **`shopId`**      | `string(255)`      | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`shop_type`**   | `string(255)`      |
#

class Shop < ActiveRecord::Base
end
