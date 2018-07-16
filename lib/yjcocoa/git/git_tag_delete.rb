#
#  git_tag_delete.rb
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
    class GitTagDelete < GitTag
        
        self.abstract_command = false
        self.command = 'delete'
        self.summary = '删除最新的 tag'
        self.description = '删除最新的 tag'
        
        def run
            tag = `git tag`.split("\n").last
            if tag
                answer = self.askWithAnswers("是否删除 tag #{tag}", ["Yes", "No"])
                if answer == "yes"
                    system("YJCocoa git tag --delete=#{tag}")
                end
                else
                puts "暂无 Tag".green
                self.banner!
            end
        end
        
    end
    
end

