FROM ruby:2.7.4-slim

# Install essentials for running gems and app
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    postgresql-client \
    git \
    git-core \
    curl \ 
    zlib1g-dev \ 
    libssl-dev \
    libreadline-dev \
    libyaml-dev \
    libsqlite3-dev \
    sqlite3 \
    libxml2-dev \ 
    libxslt1-dev \
    libcurl4-openssl-dev \
    software-properties-common \ 
    libffi-dev \ 
    dirmngr \
    gnupg \ 
    apt-transport-https \ 
    ca-certificates \ 
    imagemagick \ 
    tzdata \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Update Gems and install Bundler
RUN gem update --system
RUN gem install bundler
RUN gem install rubocop

# Setup workdir and copy code from local machine to container working directory
WORKDIR /app
COPY . /app/

# Add Bundle to $PATH
ENV BUNDLE_PATH /gems

# Copy Gemfile to container
COPY Gemfile Gemfile.lock /app/

# Run Bundler and install gems
RUN bundle install

# Expose PORT for running application
# ENTRYPOINT ["bin/rails"]
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000"]

# Expose port to defined
EXPOSE 3000