#
#  unused_method.rb
#  YJCocoaGem
#
#  https://github.com/937447974
#  YJ技术支持群:557445088
#
#  Created by 阳君 on 2018/12/8.
#  Copyright © 2018年 YJCocoa. All rights reserved.
#

module YJCocoa
    
    # Usage
    class UnusedMethod < Unused
        
        self.command = 'method'
        self.summary = 'unused method commands'
        self.description = '查找 OC 项目中未使用的 method'
        
        def self.options
            [['--match-o', 'Match O 文件地址'],
            ['--match', '指定的字符串匹配，多字符串用 "," 分隔'],
            ['--ignore', '忽略的字符串匹配, 多字符串用 "," 分隔'],
            ['--output', '日志存放路径，默认当前路径']] + super
        end
    
        # businrss
        def validate!
            super
            unless self.matcho && self.matcho.length > 0
                puts "Match O 文件地址为空".red
                self.banner!
            end
        end
        
        def run
            unused_methods = self.unreferenced_methods
            fetch_methods = unused_methods.reject {|m| !(check_match(m) && !check_ignore(m))}
            puts "分析完毕，打开日志：#{self.output}".green
            File.write(self.output, fetch_methods.join("\n"))
            `open #{self.output}`
        end
        
        def unreferenced_methods
            methods = self.implemented_methods
            unless methods.count
                puts "#{self.matcho} can't find implemented methods".red
                self.banner!
            end
            sels = self.referenced_selectors
            sels.each {|sel| methods.delete(sel)}
            result = []
            methods.values.each {|value| result += value}
            return result.sort
        end
        
        def implemented_methods
            lines = `otool -oV #{self.matcho}`.split("\n")
            methods = Hash.new
            methods.default = []
            lines.each {|line|
                line_scan = line.scan(/\s*imp 0x\w+ ([+|-]\[.+\s(.+)\])/)
                if line_scan.count > 0
                    imp = line_scan[0][0]
                    sel = line_scan[0][1]
                    if methods.include?(sel)
                        methods[sel] << imp
                        else
                        methods[sel] = [imp]
                    end
                end
            }
            return methods
        end
        
        def referenced_selectors
            lines = `otool -v -s __DATA __objc_selrefs #{self.matcho}`.split("\n")
            refs = []
            lines.each { |line|
                line_scan = line.scan(/__TEXT:__objc_methname:(.+)/)
                if line_scan.count > 0
                    refs << line_scan[0][0]
                end
            }
            return refs
        end
        
        def check_match(method)
            return true unless self.match
            self.match.each { |m|
                return true if method.include?(m)
            }
            return false
        end
        
        def check_ignore(method)
            return false unless self.ignore
            self.ignore.each { |i|
                return true if method.include?(i)
            }
            return false
        end
        
    end

end

