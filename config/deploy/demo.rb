server 'biz.indoor-navi.jp', user: 'ec2-user', roles: %w(app db web)

set :ssh_options, {
  keys: %(../.ssh/jmapdev.pem)
}

set :repo_url, 'git@52.69.46.99:/var/data/git/jmap-api.git'

set :rails_env, :development

set :default_env, {
  jmapi18n_internal_location: 'http://biz.indoor-navi.jp/i18n/'
}
