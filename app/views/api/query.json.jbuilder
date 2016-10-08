# -*- mode: ruby -*-
# vi: set ft=ruby :

json.ignore_nil!

json.response do
  json.code @error_code || 0
  json.message @message || 'Success'
  json.info do
    json.texts texts_to_tree(@texts, @options).to_array
  end
end
