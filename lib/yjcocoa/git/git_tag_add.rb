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
        self.summary = '添加默认 tag(git库名-branch-%Y%m%d%H%M)'
        self.description = '添加默认 tag(git库名-branch-%Y%m%d%H%M)'
        
        def run
            if File.exist?(".git")
                current_branch = self.current_branch
                tag = File.basename(Dir.pwd)
                tag << "-#{current_branch}" unless current_branch =~ /master/
                tag << "-#{Time.now.strftime('%Y%m%d%H%M')}"
                puts "YJCocoa build tag #{tag}".green
                system("yjcocoa git tag --add=#{tag}")
            else
                Dir.chdir("..") {
                    self.run
                }
            end
        end
        
        def current_branch
            list = (`git branch`).split("\n")
            for item in list
                if item =~ /\* /
                    return item.gsub(/\* /, "")
                end
            end
        end
        
    end
    
end
