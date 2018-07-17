#
#  product_class.rb
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
    class ProductClass
        
        attr_accessor :name
        attr_accessor :h_path
        attr_accessor :m_path
        attr_accessor :mm_path
        
        def initialize(name)
            self.name = name
        end
        
    end
    
end
