#
#  git_pull.rb
#  YJCocoa
#
#  https://github.com/937447974
#  YJ技术支持群:557445088
#
#  Created by 阳君 on 17/8/22.
#  Copyright © 2017年 YJCocoa. All rights reserved.
#

module YJCocoa

    # Usage
    class GitPull < Git

        self.command = 'pull'
        self.summary = 'git pull'
        self.description = 'git pull 当前文件夹下所有 gits 和 branchs'

        attr_accessor :currentBranch #是否只拉取当前分支
        attr_accessor :gits # git array

        # Options
        def self.options
            [['--current-branch', '只拉取当前分支'],]
        end

        def initialize(argv)
            super
            self.currentBranch = argv.flag?('current-branch', false)
        end

        def run
            self.buildGitPaths
            if self.gits.empty?
                if self.gitExist?
                    self.gitPullRun
                end
            else
                self.gits.each { |path|
                    self.gitPullRun(path)
                }
            end
        end

        def buildGitPaths
            self.gits = Dir["**/.git"]
            self.gits.map! { |path|
                File.dirname(path)
            }
        end

        def gitPullRun(path=".")
            thread = Thread.new {
                Dir.chdir(path) {
                    puts "YJCocoa git pull #{path}/.git".green
                    localChanges = !(`git stash` =~ /No local changes to save/)
                    system("git pull")
                    unless self.currentBranch
                        list = (`git branch`).split("\n")
                        if list.size >= 2
                            headBranch = "master"
                            list.each { |item|
                                if item =~ /\* /
                                    headBranch = item.gsub(/\* /, "")
                                else
                                    `git checkout #{item}`
                                    system("git pull")
                                end
                            }
                            `git checkout #{headBranch}`
                        end
                    end
                    `git stash pop` if localChanges
                    puts
                }
            }
            thread.join
        end

    end

end
