#
#  command.rb
#  YJCocoa
#
#  https://github.com/937447974
#  YJ技术支持群:557445088
#
#  Created by 阳君 on 17/8/22.
#  Copyright © 2017年 YJCocoa. All rights reserved.
#

require 'claide'
require 'colored2'
require 'fileutils'
require 'yjcocoa/gem_version'

module YJCocoa
    
    # Usage
    class Command < CLAide::Command
        
        DEFAULT_OPTIONS = [['--help', 'Show help banner of specified command'],]
        
        self.abstract_command = true
        self.command = 'yjcocoa'
        self.version = VERSION
        self.description = 'YJCocoa, the Cocoa library package manager.'
        
        def self.options
            if root_command?
                DEFAULT_ROOT_OPTIONS + DEFAULT_OPTIONS
                else
                DEFAULT_OPTIONS
            end
        end

        #  @abstract 向用户提问，并获取输入
        #
        #  @param question 问题
        #  @param answers  答案数组
        #
        #  @return 用户输入的选项。用户不输入时，默认返回第一个选项
        def askWithAnswers(question = "", answers = [])
            answersDowncase = answers.map { |item| item.downcase }
            return answersDowncase.first if answersDowncase.count <= 1            
            result = ""
            block = Proc.new { |again|
                str = again ? "可能的答案是 [" : "#{question}? ["
                answers.each_with_index { |item, i|
                    str << " #{(i == 0) ? item.underlined : item}"
                    str << " /" unless i == answers.count - 1
                }
                str << " ]: "
                print str
            }
            # do
            block.call(false)
            loop do
                result = STDIN.gets.chomp.downcase
                if result.empty?
                    result = answersDowncase.first
                    print "default: #{result}".yellow
                else
                    result = "yes" if result == "y"
                    result = "no" if result == "n"
                end
                break if answersDowncase.include?(result)
                block.call(true)
            end
            return result
        end

    end

    # Commands
    require 'yjcocoa/git/git'

end

