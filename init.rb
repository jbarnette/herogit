def herogit
  return @herogit if defined? @herogit
  @herogit = {}

  `git config --get-regexp '^heroku\.'`.each_line do |line|
    key, value = line.chomp.split /\s+/
    @herogit[key] = Array(value).join " "
  end

  @herogit
end

module Herogit
  module Auth
    def get_credentials_with_git
      if File.directory? ".git"
        creds = herogit.values_at("heroku.email", "heroku.password").compact
        @credentials = creds if 2 == creds.size
      end

      get_credentials_without_git
    end
  end

  if defined? Heroku::Auth # heroku > v2.0
    Heroku::Auth.extend(Herogit::Auth)
    class << Heroku::Auth
      alias_method :get_credentials_without_git, :get_credentials
      alias_method :get_credentials, :get_credentials_with_git
    end
  else
    Heroku::Command::Auth.class_eval do 
      include Herogit::Auth
      alias_method :get_credentials_without_git, :get_credentials
      alias_method :get_credentials, :get_credentials_with_git
    end
  end
end

class Heroku::Command::Base
  def extract_app_in_dir_with_git dir
    Dir.chdir dir do
      if /^\* (\S+)/ =~ `git branch`
        app = herogit["heroku.app.#$1"]
        return app if app
      end
    end

    extract_app_in_dir_without_git dir
  end

  alias_method :extract_app_in_dir_without_git, :extract_app_in_dir
  alias_method :extract_app_in_dir, :extract_app_in_dir_with_git
end
