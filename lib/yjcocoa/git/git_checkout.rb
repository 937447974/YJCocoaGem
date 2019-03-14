#
#  git_checkout.rb
#  YJCocoa
#
#  https://github.com/937447974
#  YJ技术支持群:557445088
#
#  Created by 阳君 on 2019/03/18.
#  Copyright © 2017年 YJCocoa. All rights reserved.
#

module YJCocoa

    class GitCheckout < Git

        self.command = 'checkout'
        self.summary = 'git checkout'
        self.description = 'git checkout 当前文件夹下所有 gits'

        def self.options
            [['--branch', '切换 branch'],]
        end
    
        # property
        attr_accessor :branch
        attr_accessor :gits

        # 初始化
        def initialize(argv)
            super
            self.branch = argv.option('branch')
        end

        # businrss
        def validate!
            self.banner! unless self.branch
        end

        def run
            self.buildGitPaths
            if self.gits.empty?
                if self.gitExist?
                    self.gitCheckout
                end
            else
                self.gits.each { |path|
                    self.gitCheckout(path)
                }
            end
        end

        def buildGitPaths
            self.gits = Dir["**/.git"]
            self.gits.map! { |path|
                File.dirname(path)
            }
        end

        def gitCheckout(path=".")
            Dir.chdir(path) {
                puts "YJCocoa git checkout #{path}/.git".green
                localChanges = !(`git stash` =~ /No local changes to save/)
                system("git checkout -b #{self.branch}") unless system("git checkout #{self.branch}")
                `git stash pop` if localChanges
                puts
            }
        end

    end

end
