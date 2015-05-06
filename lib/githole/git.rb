module Githole
  class Git

    def initialize(version)
      @version = version
    end

    def respond_to?(cmd)
      ['add','update','push','remove','tag','release','count'].include?(cmd)
    end

    def add
      checkout master
      fetch
      create remote
      pull remote if branch_exists?("remotes/origin/#{remote}")
      git_push remote
      create local
    end

    def update
      verify remote
      verify local
      # rebase master onto local
      checkout master
      pull master
      checkout local
      rebase master
      # rebase remote onto local
      checkout remote
      pull remote
      checkout local
      rebase remote
    end

    def push
      update
      checkout remote
      merge local
      git_push remote
      checkout local
    end

    def remove
      checkout master
      delete remote
      delete local
    end

    def tag
      checkout master
      pull master
      git "tag -a #{@version} -m #{@version}"
      git_push "--tags"
    end

    def release
      tag
      create "release"
      pull "release"
      merge master
      git_push "release"
      checkout master
    end

    def count
      git "rev-list HEAD --count"
    end

    private

      def git(cmd)
        system("git #{cmd}")
      end

      def fetch
        git "fetch"
      end

      def branches
        `git branch -a`
          .split("\n")
          .collect { |b| b.split(' ').last }
          .collect { |b| b.split(' ').first }
      end

      def checkout(branch, options = '')
        git "checkout #{options} #{branch}"
      end

      def create(branch)
        branch_exists?(branch) ? checkout(branch) : checkout(branch, '-b')
      end

      def delete(branch)
        git "branch -D #{branch}"
      end

      def git_push(branch)
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
        "#{@version}"
      end

      def local
        "local-#{@version}"
      end

      def branch_exists?(branch)
        branches.include?(branch)
      end

      def remote_exists?
        branch_exists?(remote)
      end

      def local_exists?
        branch_exists?(local)
      end

      def verify(branch)
        create(branch) unless branch_exists?(branch)
      end

  end
end
