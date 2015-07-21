module ProjectMonitorStat
  class GitEmailParser
    SOLO_USERNAME_REGEX = /\A[^+]+(?=@)/
    PAIR_USERNAME_REGEX = /(?<=[\+^])\w+(?=[\+@])/

    attr_reader :git_email

    def initialize
      @git_email = Util.x('git config --get user.email')
    end

    def username_tags
      solo_usernames | pair_usernames
    end

    private

    def solo_usernames
      git_email.scan(SOLO_USERNAME_REGEX)
    end

    def pair_usernames
      git_email.scan(PAIR_USERNAME_REGEX)
    end
  end
end