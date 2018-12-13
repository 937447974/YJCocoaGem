#
#  unused_class.rb
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
    class UnusedClass < Unused
        
        self.command = 'class'
        self.summary = 'unused class commands'
        self.description = '查找 OC 项目中未使用的 class'
        
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
            unused_class = self.unreferenced_class
            fetch_class = unused_class.reject {|m| !(check_match(m) && !check_ignore(m))}
            puts "分析完毕，打开日志：#{self.output}".green
            File.write(self.output, fetch_class.join("\n"))
            `open #{self.output}`
        end
        
        def unreferenced_class
            section = match_o_section
            unless section.count
                puts "#{self.matcho} can't find classlist".red
                self.banner!
            end
            classlist = section["Contents of (__DATA,__objc_classlist) section"]
            classrefs = section["Contents of (__DATA,__objc_classrefs) section"]
            superrefs = section["Contents of (__DATA,__objc_superrefs) section"]
            all_classlist = objc_classlist(classlist)
            used_classlist = objc_super_classlist(classlist) + objc_classlist(classrefs) + objc_classlist(superrefs)
            unused_classlist = []
            all_classlist.each {|item|
                unused_classlist << item unless used_classlist.include?(item)
            }
            return unused_classlist.sort
        end
        
        def match_o_section
            lines = `otool -oV #{self.matcho}`.split("\n")
            section = Hash.new
            key = nil
            lines.each {|line|
                line = line#.strip
                if line.include?("Contents of (__DATA,")
                    key = line
                elsif (key)
                    if section.include?(key)
                        section[key] << line
                    else
                        section[key] = [line]
                    end
                end
            }
            return section
        end
        
        def objc_super_classlist(classlist)
            result = []
            classlist.each { |line|
                line_scan = line.scan(/_OBJC_CLASS_\$_(.+)/)
                if line_scan.count > 0 && line.include?("superclass")
                    result << line_scan[0][0]
                end
            }
            return result
        end
        
        def objc_classlist(classlist)
            result = []
            classlist.each { |line|
                line_scan = line.scan(/_OBJC_CLASS_\$_(.+)/)
                if line_scan.count > 0 && !line.include?("superclass")
                    result << line_scan[0][0]
                end
            }
            return result
        end
        
    end
    
end

