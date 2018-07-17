#
#  pod.rb
#  YJCocoa
#
#  https://github.com/937447974
#  YJ技术支持群:557445088
#
#  Created by 阳君 on 2018/07/16.
#  Copyright © 2017年 YJCocoa. All rights reserved.
#

module YJCocoa
    
    # Usage
    class Pod < Command
        
        self.abstract_command = true
        self.command = 'pod'
        self.summary = 'Pod commands'
        self.description = 'These are common pod commands used in YJCocoa.'
        
    end
    
    # Commands
    require 'yjcocoa/pod/pod_dependency'
    require 'yjcocoa/pod/pod_release'
    
end


