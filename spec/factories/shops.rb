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
#

FactoryGirl.define do
  factory :shop do
    sequence(:id)       {|n| n + 1}
    sequence(:venueId)  {|n| n + 1}
    sequence(:floorId)  {|n| n + 43098}
    sequence(:shopId)   {|n| n + 13608536}
    
    drowingId 26138
  end

end
