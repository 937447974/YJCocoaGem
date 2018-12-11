#
#  unused_class.rb
#  YJCocoaGem
#
#  https://github.com/937447974
#  YJ技术支持群:557445088
#
#  Created by 阳君 on 2018/12/8.
#  Copyright © 2018年 YJCocoa. All rights reserved.
#

module YJCocoa
    
    # Usage
    class UnusedClass < Unused
        
        self.command = 'class'
        self.summary = 'unused class commands'
        self.description = '查找 OC 项目中未使用的 class'
        
        def self.options
            [['--match-o-file', 'Match O 文件地址'],
            ['--output', '日志存放路径，默认当前路径']] + super
        end
        
    end
    
end

