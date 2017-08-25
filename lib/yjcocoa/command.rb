#
#  command.rb
#  YJCocoa
#
#  https://github.com/937447974
#  YJ技术支持群:557445088
#
#  Created by 阳君 on 17/8/22.
#  Copyright © 2017年 YJCocoa. All rights reserved.
#

require 'claide'
require 'colored2'
require 'yjcocoa/gem_version'

module YJCocoa
    
    # Usage
    class Command < CLAide::Command
        
        DEFAULT_OPTIONS = [['--help', 'Show help banner of specified command'],]
        
        self.abstract_command = true
        self.command = 'yjcocoa'
        self.version = VERSION
        self.description = 'YJCocoa, the Cocoa library package manager.'
        
        def self.options
            if root_command?
                DEFAULT_ROOT_OPTIONS + DEFAULT_OPTIONS
                else
                DEFAULT_OPTIONS
            end
        end

    end

    # Commands
    require 'yjcocoa/git/git'

end

