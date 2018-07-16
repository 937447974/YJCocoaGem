#
#  git_tag_add.rb
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
    class GitTagAdd < GitTag
        
        self.abstract_command = false
        self.command = 'add'
        self.summary = 'git tag add'
        self.description = '添加默认 tag(git库名-%Y%m%d%H%M) 并推送到服务器.'
        
        def self.options
            DEFAULT_OPTIONS
        end
    
        def validate!
            super
            if self.class == YJCocoa::GitTagAdd
                unless File.exist?('.git')
                    puts "需在项目根目录执行".red
                    self.banner!
                end
            end
        end
    
        def run
            unless File.exist?('.git')
                puts "需在项目根目录执行".red
                self.banner!
            end
            tag = File.basename(Dir.pwd)
            tag << '-'
            tag << Time.now.strftime("%Y%m%d%H%M")
            puts "yjcocoa build tag #{tag}".green
            system("yjcocoa git tag --add=#{tag}")
        end
        
    end
    
end
