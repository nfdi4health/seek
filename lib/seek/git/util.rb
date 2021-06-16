module Seek
  module Git
    module Util
      mattr_accessor :git_author

      def git_author
        @@git_author || default_git_author
      end

      def default_git_author
        { email: git_user_email, name: git_user_name, time: Time.now }
      end

      def git_user_name
        User.current_user&.person&.name || Seek::Config.application_name
      end

      def git_user_email
        User.current_user&.person&.email || Seek::Config.noreply_sender
      end

      def with_git_author(name: git_user_name, email: git_user_email, time: Time.now)
        orig_git_author = git_author
        self.git_author = { email: email, name: name, time: time }
        yield
      ensure
        self.git_author = orig_git_author
      end
    end
  end
end