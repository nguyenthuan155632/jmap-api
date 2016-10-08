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
#

FactoryGirl.define do
  factory :area do
    sequence(:id)       {|n| "#{n + 1}"}
    sequence(:areaid)   {|n| "#{n + 1}"}
    sequence(:lat)      {|n| "35.67219#{n}"}
    sequence(:lon)      {|n| "139.76395#{n}"}
    sequence(:url)      {|n| "img/#{n}.jpeg"} 
  end

end
