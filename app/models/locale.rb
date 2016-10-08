# ## Schema Information
#
# Table name: `locales`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id`**           | `integer`          | `not null, primary key`
# **`lang`**         | `string(10)`       | `not null`
# **`description`**  | `string(255)`      |
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_locales_on_lang` (_unique_):
#     * **`lang`**
#

class Locale < ActiveRecord::Base
end
