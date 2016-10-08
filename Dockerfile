FROM ruby:2.2.2

RUN bundle config --global frozen 1

RUN mkdir -p /var/app
WORKDIR /var/app

COPY Gemfile ./
COPY Gemfile.lock ./
RUN bundle --deployment --without development:test:doc:deployment --jobs 4

COPY . .
COPY config/database_aws.yml config/database.yml
RUN bundle exec rake tmp:create RAILS_ENV=production

CMD sh bin/start
