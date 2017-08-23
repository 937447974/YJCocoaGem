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
        
        self.abstract_command = true
        self.command = 'pull'
        self.summary = 'git 工具包'
        self.description = 'git pull 当前文件夹下所有 git 和 branch'
        
        attr_accessor :show_qq
        
        # Options
        def self.options
        [
        ['--no-repo-update', 'Options 命令'],
        ]
    end


        def initialize(argv)
            super
            self.show_qq = argv.flag?('show', false)
        end
        
        def run
            
            if self.show_qq
                puts "qq: 937447974"
            end
        end
        
    end
    
end
