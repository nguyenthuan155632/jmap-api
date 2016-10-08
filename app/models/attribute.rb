# ## Schema Information
#
# Table name: `attributes`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `integer`          | `not null, primary key`
# **`venueId`**     | `string(255)`      | `not null`
# **`shopId`**      | `string(255)`      | `not null`
# **`name`**        | `string(255)`      |
# **`value`**       | `text(65535)`      |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#

class Attribute < ActiveRecord::Base
end
