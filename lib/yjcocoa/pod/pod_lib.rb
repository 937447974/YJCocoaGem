#
#  product_lib.rb
#  YJCocoa
#
#  https://github.com/937447974
#  YJ技术支持群:557445088
#
#  Created by 阳君 on 2018/07/17.
#  Copyright © 2017年 YJCocoa. All rights reserved.
#

module YJCocoa
    
    # Usage
    class PodLib < Pod
        
        self.command = 'lib'
        self.summary = 'Develop pods'
        self.description = 'Develop pods'
        
        def self.options
            [['--create', 'Creates a new Pod'],] + super
        end
    
        attr_accessor :create # create pod
    
        def initialize(argv)
            super
            self.create = argv.option('create')
        end
        
        def validate!
            super
            unless self.create && !self.create.empty?
                puts "库名为空".red
                self.banner!
            end
        end
        
        def run
            puts "YJCocoa create pod lib #{self.create}".green            
            system("pod lib create --template-url=git@github.com:937447974/pod-template.git #{self.create}")
        end
    
    end
    
end
