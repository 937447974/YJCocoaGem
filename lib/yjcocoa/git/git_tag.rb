#
#  git_pull.rb
#  YJCocoa
#
#  https://github.com/937447974
#  YJ技术支持群:557445088
#
#  Created by 阳君 on 17/8/22.
#  Copyright © 2017年 YJCocoa. All rights reserved.
#

module YJCocoa
    
    class GitTag < Git
        
        self.command = 'tag'
        self.summary = 'git tag'
        self.description = <<-DESC
            操作 tag 并同步到服务器
            
            1. 增加tag 1.0：yjcocoa git tag --add=1.0
            
            2. 删除多个tag 1.0 和 2.0：yjcocoa git tag --delete=1.0,2.0
        DESC
        
        def self.options
            [['--add', '增加tag并推送到服务器'],
            ['--delete', '删除多个tags并推送到服务器'],]
        end
    
        # property
        attr_accessor :addTag
        attr_accessor :deleteTags
        
        # 初始化
        def initialize(argv)
            super
            self.addTag = argv.option('add')
            self.deleteTags = argv.option('delete')
            self.deleteTags = self.deleteTags.split(",").reject {|i| i.empty? } if self.deleteTags
        end
        
        # businrss
        def validate!
            exit 0 unless self.gitExist?
            self.banner! unless self.addTag || self.deleteTags
        end
        
        def run
            if self.addTag
                self.gitTagAdd
                puts
            end
            self.gitTagDelete if self.deleteTags && !self.deleteTags.empty?
        end
        
        def gitTagAdd
            puts "YJCocoa git add tag #{self.addTag}".green
            system("git push origin #{self.addTag}") if system("git tag #{self.addTag}")
        end
        
        def gitTagDelete
            puts "YJCocoa git delete tags #{self.deleteTags}".green
            self.deleteTags.each { |tag|
                system("git push origin :refs/tags/#{tag}") if system("git tag -d #{tag}")
            }
        end
        
    end

end
