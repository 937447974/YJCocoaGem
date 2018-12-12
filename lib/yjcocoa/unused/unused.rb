#
#  unused.rb
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
    class Unused < Command
        
        self.abstract_command = true
        self.command = 'unused'
        self.summary = 'OC 项目未使用资源查找'
        self.description = 'These are common unused commands used in YJCocoa.'
        
        # property
        attr_accessor :matcho
        attr_accessor :match
        attr_accessor :ignore
        attr_accessor :output
        
        # 初始化
        def initialize(argv)
            super
            self.matcho = argv.option('match-o')
            self.match = argv.option('match')
            self.match = self.match.split(",").reject {|i| i.empty? } if self.match
            self.ignore = argv.option('ignore')
            self.ignore = self.ignore.split(",").reject {|i| i.empty? } if self.ignore
            self.output = argv.option('output')
            self.output = Dir.pwd + "/YJCocoa.h" unless self.output
        end
        
        def check_match(item)
            return true unless self.match
            self.match.each { |m|
                return true if item.include?(m)
            }
            return false
        end
        
        def check_ignore(item)
            return false unless self.ignore
            self.ignore.each { |i|
                return true if item.include?(i)
            }
            return false
        end
        
    end
    
    # Commands
    require 'yjcocoa/unused/unused_class'
    require 'yjcocoa/unused/unused_method'
#    require 'yjcocoa/unused/unused_image'

end
