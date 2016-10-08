# ## Schema Information
#
# Table name: `areas`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `integer`          | `not null, primary key`
# **`areaid`**      | `string(255)`      |
# **`lat`**         | `text(65535)`      |
# **`lon`**         | `text(65535)`      |
# **`url`**         | `text(65535)`      |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`area_type`**   | `string(255)`      |
#

class Area < ActiveRecord::Base
end
