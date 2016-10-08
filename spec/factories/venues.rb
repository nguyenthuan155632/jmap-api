# ## Schema Information
#
# Table name: `venues`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `integer`          | `not null, primary key`
# **`areaId`**      | `string(255)`      | `not null`
# **`venueId`**     | `string(255)`      | `not null`
# **`country`**     | `string(255)`      |
# **`business`**    | `text(65535)`      |
# **`lat`**         | `text(65535)`      |
# **`lon`**         | `text(65535)`      |
# **`zipCode`**     | `string(255)`      |
# **`imageUrl`**    | `text(65535)`      |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#

FactoryGirl.define do
  factory :venue do
    sequence(:id)         {|n|           n + 1 }
    sequence(:venueId)    {|n|           n + 1 }
    sequence(:areaId)     {|n|           n + 1 }
    sequence(:lat)        {|n|  "35.67219#{n}" }
    sequence(:lon)        {|n| "139.76395#{n}" }
    sequence(:zipCode)    {|n|   "100-000#{n}" }
    sequence(:imageUrl)   {|n| "img/#{n}.jpeg" }
    
    country "JP"
    business "Shopping Mall"
  end

end
