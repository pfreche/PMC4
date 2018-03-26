FROM ruby:2.3.0

# Install node for asset building
# RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
# Create and switch to a user called app
# RUN useradd -ms /bin/bash app


RUN mkdir /myapp
WORKDIR /myapp

# Copy across dependencies and install them
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

#RUN chown -R app:app /home/app
#USER app
#CMD ["bundle", "exec", "rackup", "-s", "puma"]
CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0"]