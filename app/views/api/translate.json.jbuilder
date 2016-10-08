# -*- mode: ruby -*-
# vi: set ft=ruby :

json.response do
  json.code @error_code || 0
  json.message @message || 'Success'
  json.info do
    json.word @word
  end
end
