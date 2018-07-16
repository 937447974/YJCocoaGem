#
#  git_cache.rb
#  YJCocoa
#
#  https://github.com/937447974
#  YJ技术支持群:557445088
#
#  Created by 阳君 on 17/8/26.
#  Copyright © 2017年 YJCocoa. All rights reserved.
#

module YJCocoa
    
    class GitCache < Git
        
        self.command = 'cache'
        self.summary = 'Manipulate the git cache'
        self.description = <<-DESC
            主要用于删除 git 仓库中的历史缓存文件。
            
            注意事项：
            
            1. 删除的文件将在本地和远端永久删除，无法回滚；
            
            2. 需在 git 仓库的根目录执行。
        DESC
        
        def self.options
            [['--delete-path', '删除的文件路径，多个路径用‘,’隔开']]
        end
        
        # property
        attr_accessor :paths
        
        # 初始化
        def initialize(argv)
            super
            self.paths = argv.option('delete-path')
            self.paths = self.paths.split(",").reject {|i| i.empty? } if self.paths
        end
        
        # businrss
        def validate!
            super
            exit 0 unless self.gitExist?
            unless self.paths
                puts "文件路径为空".red
                self.banner!
            end
        end
        
        def run
            self.cleanWorkDirectory
            answer = self.askWithAnswers("强制推动您的本地更改覆盖您的GitHub仓库", ["Yes", "No"])
            if answer == "yes"
                self.pushOrigin
                self.cleanRepository
            end
        end
        
        def cleanWorkDirectory
            self.paths.each { |path|
                puts "YJCocoa git delete cache #{path}".green
                system("git filter-branch --force --index-filter \
                       'git rm -r --cached --ignore-unmatch #{path}' \
                       --prune-empty --tag-name-filter cat -- --all")
                puts
            }
        end
        
        def pushOrigin
            system("git push origin --force --all")
            system("git push origin --force --tags")
        end
        
        def cleanRepository
            system("git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin")
            system("git reflog expire --expire=now --all")
            system("git gc --prune=now")
        end
        
    end

end
