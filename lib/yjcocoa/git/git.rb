#
#  git.rb
#  YJCocoa
#
#  https://github.com/937447974
#  YJ技术支持群:557445088
#
#  Created by 阳君 on 17/8/1.
#  Copyright © 2017年 YJCocoa. All rights reserved.
#

module YJCocoa
    
    class Command
        
        class Git < Command
            
            self.abstract_command = true
            self.command = 'git'
            self.summary = 'QQ 号'
            self.description = '显示 QQ 号'

        end
        
        def initialize(argv)
            super
            self.show_qq = argv.flag?('show', false)
        end
        
        def validate!
            super
            help! '请输入 yjcocoa qq --show' unless self.show_qq
        end
        
        def run
            if self.show_qq
                puts "qq: 937447974"
            end
        end
        
    end
    
end

end
