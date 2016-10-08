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

FactoryGirl.define do
  factory :attribute do
    venueId "23557"
    shopId  "13608536"
    name    "10000001"
    value   "81353390511"
  end

end
