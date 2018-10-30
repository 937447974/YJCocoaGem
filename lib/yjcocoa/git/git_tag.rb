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
        
        self.abstract_command = false
        self.command = 'tag'
        self.summary = 'git tag'
        self.description = <<-DESC
            操作 tag 并同步到服务器
        DESC
        
        def self.options
            if self == YJCocoa::GitTag
                [['--add', '增加 tag, 多 tag 用 "," 分隔'],
                ['--delete', '删除 tag, 多 tag 用 "," 分隔']] + super
            else
                super
            end
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
            super
            exit 0 unless self.gitExist?
            if self.class == YJCocoa::GitTag
                self.banner! unless self.addTag || self.deleteTags
            end
        end

        def run
            if self.deleteTags && !self.deleteTags.empty?
                self.gitTagDelete
                puts
            end
            self.gitTagAdd if self.addTag
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

    # Commands
    require 'yjcocoa/git/git_tag_add'
    require 'yjcocoa/git/git_tag_delete'

end
