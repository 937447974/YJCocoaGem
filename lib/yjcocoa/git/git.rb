#
#  git.rb
#  YJCocoa
#
#  https://github.com/937447974
#  YJ技术支持群:557445088
#
#  Created by 阳君 on 17/8/22.
#  Copyright © 2017年 YJCocoa. All rights reserved.
#

module YJCocoa
    
    # Usage
    class Git < Command
        
        self.abstract_command = true
        self.command = 'git'
        self.summary = 'git 工具包'
        self.description = 'git 工具包'
        
        def gitExist?
            if File.exist?(".git")
                return true
            elsif Dir.pwd == "/"
                puts "fatal: Not a git repository (or any of the parent directories): .git".red
                return false
            end
            Dir.chdir("..") {
                return self.gitExist?
            }
        end
        
    end
    
    # Commands
    require 'yjcocoa/git/git_pull'
    
end

