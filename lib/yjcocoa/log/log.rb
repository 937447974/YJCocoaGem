#
#  pod.rb
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
    class Log < Command
        
        self.command = 'log'
        self.summary = 'log 日志解析'
        self.description = <<-DESC
            .log 日志解析，并保留需要的记录\n
            1. 以文件夹的方式解析，并将解析后的日志存放在文件夹内。\n
            2. 解析时使用字符串匹配，匹配成功的记录会保留 YJCocoa.log 中。
        DESC
        
        def self.options
            [['--dir', '文件夹地址'], ['--match', '匹配的字符串']] + super
        end
    
        LOG_FILE = "YJCocoa.log"
    
        attr_accessor :dir   # 文件夹地址
        attr_accessor :match # 匹配的字符串
        
        # 初始化
        def initialize(argv)
            super
            self.dir = argv.option('dir')
            self.match = argv.option('match')
            self.match = self.match.split(",").reject {|i| i.empty? } if self.match
        end
        
        # businrss
        def validate!
            super
            unless self.dir && Dir.exist?(self.dir)
                puts "dir:#{self.dir} 文件夹不存在".red
                self.banner!
            end
            unless self.match && self.match.length > 0
                puts "match 为空".red
                self.banner!
            end
        end
        
        def run
            Dir.chdir(self.dir) {
                log = ""
                File.delete(LOG_FILE) if File.exist?(LOG_FILE)
                for path in Dir["**/*.log"].sort do
                    puts "解析日志 #{path}".green
                    File.open(path, "r") { |file|
                        while line = file.gets
                            if self.check(line)
                                log << line
                            end
                        end
                    }
                end
                puts "\n解析完毕，打开日志：#{dir}/#{LOG_FILE}".green
                File.write(LOG_FILE, log)
                `open #{LOG_FILE}`
            }
        end
                
        def check (line)
            self.match.each { |m|
                if line.include?(m)
                    return true
                end
            }
            return false
        end
        
    end

end

