#
#  pod_release.rb
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
    class PodRelease < Pod
        
        self.abstract_command = false
        self.command = 'release'
        self.summary = '收集 pod 库的 版本号'
        self.description = <<-DESC
        收集 pod 库的 版本号
        
        注意事项: podfile 和 sender 不可为空
        DESC
        
        def self.options
            [['--podfile', '包含 pods 库的 podfile 文件路径'],
            ['--pods', 'pods 库，多 pod 用 "," 分隔']] + super
        end
    
        attr_accessor :podfile # 文件路径
        attr_accessor :pods # pods 库
        
        # 初始化
        def initialize(argv)
            super
            self.podfile = argv.option('podfile')
            self.pods = argv.option('pods')
            self.pods = self.pods.split(",").reject {|i| i.empty? } if self.pods
        end
        
        def validate!
            super
            puts "podfile 为空".red unless self.podfile
            puts "pods 为空".red unless self.pods
            self.banner! unless self.podfile && self.pods
            unless File.exist?(self.podfile)
                puts "podfile 文件路径 #{self.podfile} 不存在".red
                self.banner!
            end
        end
        
        # businrss
        def run
            self.gitPull
            content = []
            File.open(self.podfile, "r") { |file|
                while line = file.gets   #标准输入流
                    result = check(self.pods, line)
                    content << "#{result}" if result
                end
            }
            puts "YJCocoa Pod Release".green
            puts content.sort * "\n"
        end
        
        def gitPull
            puts "#{self.podfile} git pull".green
            Dir.chdir(File.dirname(self.podfile)) {| path |
                system("yjcocoa git pull")
            }
        end
        
        private def check (pods, line)
            pods.each { |pod|
                if line.include?(pod)
                    line.split(',').each { |item|
                        if item.include?("tag") || item.include?("branch")
                            pods.delete(pod)
                            return "#{pod}, #{item.chomp}"
                        end
                    }
                end
            }
            return nil
        end
        
    end
    
end
