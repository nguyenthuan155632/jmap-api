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
# **`venue_type`**  | `string(255)`      |
# **`officialUrl`** | `string(255)`      |
#

class Venue < ActiveRecord::Base
end
