#
#  gem_version.rb
#  YJCocoa
#
#  https://github.com/937447974
#  YJ技术支持群:557445088
#
#  Created by 阳君 on 17/8/22.
#  Copyright © 2017年 YJCocoa. All rights reserved.
#

module YJCocoa
    
    VERSION = Time.now.strftime("%y.%m.%d").freeze unless defined? YJCocoa::VERSION

end
