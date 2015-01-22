module Githole
  class Git

    def initialize(version)
      @version = version
    end

    def respond_to?(cmd)
      ['add','update','push','remove'].include?(cmd)
    end

    def add
      fetch
      create remote
      if branches.include?("remotes/origin/#{remote}")
        pull remote
      end
      push remote
      create local
    end

    def update
      checkout master
      pull master
      checkout remote
      pull remote
      rebase master
      checkout local
      rebase remote
    end

    def push
      update
      checkout remote
      merge local
      push remote
      checkout local
    end

    def remove
      checkout master
      delete remote
      delete local
    end

    private

      def git(cmd)
        system("git #{cmd}")
      end

      def fetch
        git "fetch"
      end

      def branches
        # `git branch --list`.split("\n").collect { |b| b.split(' ').last }
        branches = `git branch -a`.split("\n").collect { |b| b.split(' ').last }
        branches = branches.collect { |b| b.split(' ').first }
      end

      def checkout(branch, options = '')
        git "checkout #{options} #{branch}"
      end

      def create(branch)
        if branches.include?(branch)
          checkout branch
        else
          checkout branch, '-b'
        end
      end

      def delete(branch)
        git "branch -D #{branch}"
      end

      def push(branch)
        git "push origin #{branch}"
      end

      def pull(branch)
        git "pull origin #{branch}"
      end

      def rebase(branch)
        git "rebase #{branch}"
      end

      def merge(branch)
        git "merge #{branch}"
      end

      def master
        "master"
      end

      def remote
        "v#{@version}"
      end

      def local
        "local-v#{@version}"
      end

  end
end
