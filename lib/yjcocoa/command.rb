#
#  command.rb
#  YJCocoa
#
#  https://github.com/937447974
#  YJ技术支持群:557445088
#
#  Created by 阳君 on 17/8/1.
#  Copyright © 2017年 YJCocoa. All rights reserved.
#

require 'claide'
require 'yjcocoa/gem_version'

module YJCocoa
    
    # Usage
    class Command < CLAide::Command
        
        self.abstract_command = true
        self.command = 'yjcocoa'
        self.version = VERSION
        self.description = 'YJ系列开源工具。'
        
    end
    
    # Commands
    class Command < CLAide::Command
        
        require 'yjcocoa/git/git'
        
    end
    
end
