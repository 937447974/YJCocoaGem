#
#  git_branch.rb
#  YJCocoa
#
#  https://github.com/937447974
#  YJ技术支持群:557445088
#
#  Created by 阳君 on 17/8/26.
#  Copyright © 2017年 YJCocoa. All rights reserved.
#

module YJCocoa
    
    class GitBranch < Git
        
        self.command = 'branch'
        self.summary = 'git branch'
        self.description = <<-DESC
        操作 branch 并同步到服务器
        
        1. 增加branch develop：yjcocoa git Branch --branch=develop
        
        2. 删除多个branch develop 和 fixbug：yjcocoa git Branch --branch=develop,fixbug
        DESC
        
        def self.options
            [['--add', '增加branch并推送到服务器'],
            ['--delete', '删除多个branch并推送到服务器'],]
        end
        
        # property
        attr_accessor :addBranch
        attr_accessor :deleteBranchs
        
        # 初始化
        def initialize(argv)
            super
            self.addBranch = argv.option('add')
            self.deleteBranchs = argv.option('delete')
            self.deleteBranchs = self.deleteBranchs.split(",").reject {|i| i.empty? } if self.deleteBranchs
        end
        
        # businrss
        def validate!
            exit 0 unless self.gitExist?
            self.banner! unless self.addBranch || self.deleteBranchs
        end
        
        def run
            if self.addBranch
                self.gitBranchAdd
                puts
            end
            self.gitBranchDelete if self.deleteBranchs && !self.deleteBranchs.empty?
        end
        
        def gitBranchAdd
            puts "YJCocoa git add branch #{self.addBranch}".green
            system("git push --set-upstream origin #{self.addBranch}") if system("git checkout -b #{self.addBranch}")
        end
        
        def gitBranchDelete
            puts "YJCocoa git delete branchs #{self.deleteBranchs}".green
            self.deleteBranchs.each { |branch|
                system("git branch -d #{branch}")
                system("git push origin --delete #{branch}")
            }
        end
        
    end

end