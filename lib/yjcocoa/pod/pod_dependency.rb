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
    
    require 'yjcocoa/pod/product_class'
    
    # Usage
    class PodDependency < Pod
        
        self.command = 'dependency'
        self.summary = '代码依赖分析'
        self.description = <<-DESC
        代码依赖分析\n
        1. 分析库之间的依赖关系；\n
        2. 搜索不符合规范的 import 导入，库正确导入方式为 '#import <Foundation/Foundation.h>'，错误的方式是'#import "Foundation.h"'.
        DESC
        
        def self.options
            [['--dir', '库路径，多个库用’,‘号分割'],
            ['--output', '日志存放路径，默认当前路径']] + super
        end
    
         attr_accessor :dir_array # 目录
         attr_accessor :output # 输出地址
         attr_accessor :ignore_frameworks # 忽略的外部库

        def initialize(argv)
            super
            self.dir_array = argv.option('dir')
            self.output = argv.option('output')
            if self.dir_array
                self.dir_array = self.dir_array.split(",").reject {|i|
                    i.empty? || !Dir.exist?(i)
                }
            end
            self.output = Dir.pwd unless self.output
            self.output << "/YJCocoa.log"
            self.ignore_frameworks = ["AppKit", "Foundation", "UIKit", "WatchKit"]
        end
        
        def validate!
            super
            unless self.dir_array && !self.dir_array.empty?
                puts "库路径为空或不存在".red
                self.banner!
            end
        end
        
        def run
            log = "YJCocoa 代码依赖分析\n"
            files = self.search_files
            log << "文件数：#{files.size}\n"
            products = self.parsing_files(files)
            log << "class数：#{products.size}\n"
            log << self.parsing_class(products)
            puts "\n分析完毕，打开日志：#{self.output}".green
            File.write(self.output, log)
            `open #{self.output}`
        end
        
        def search_files
            puts "\n搜索文件...".green
            files = []
            for dir in self.dir_array do
                Dir.chdir(dir) {
                    puts dir
                    for path in Dir["**/*.{h,m,mm}"] do
                        files << "#{dir}/#{path}"
                    end
                }
            end
            files.uniq!
            files.sort!
        end
        
        def parsing_files(files)
            puts "\n分析文件...".green
            hash = {}
            for file in files
                puts file
                fileName = File.basename(file).split(".").first
                product_class = hash[fileName]
                unless product_class
                    product_class = ProductClass.new(fileName)
                    hash[fileName] = product_class
                end
                case File.extname(file)
                when ".h"
                    product_class.h_path = file
                when ".m"
                    product_class.m_path = file
                when ".mm"
                    product_class.mm_path = file
                end
            end
            return hash
        end
        
        def parsing_class(products)
            puts "\n分析文件内容...".green
            log = ""
            all_frameworks = []
            for project in products.values
                puts project.name
                templog = ""
                hlog = self.parsing_content(project.h_path, all_frameworks, products) if project.h_path
                templog << hlog if hlog
                mlog = self.parsing_content(project.m_path, all_frameworks, products) if project.m_path
                templog << mlog if mlog
                mmlog = self.parsing_content(project.mm_path, all_frameworks, products) if project.mm_path
                templog << mmlog if mmlog
                log << "\n#{project.name}\n#{templog}" unless templog.empty?
            end
            all_frameworks.uniq!
            all_frameworks.sort!
            return "外部依赖汇总：#{all_frameworks.size} #{all_frameworks.to_s}\n\n" + log
        end
        
        def parsing_content(file, all_frameworks, products)
            frameworks = []
            warning = []
            error = []
            File.open(file, "r") { |file|
                while line = file.gets
                    if line.include?("#import")
                        if line.include?("<")
                            import = line[/<.*>/][/<.*\//]
                            if import
                                import[0] = ""
                                import[-1] = ""
                                frameworks << import unless self.ignore_frameworks.include?(import)
                            else
                                 error << line.chomp
                            end
                        elsif line.include?(".h\"")
                            import = line[/".*.h"/]
                            import[0] = ""
                            import[-1] = ""
                            warning << import unless products[import[0..import.size-3]]
                        end
                    elsif line.include?("@protocol") || line.include?("@interface") || line.include?("@implementation")
                        break
                    end
                end
            }
            all_frameworks.concat(frameworks)
            frameworks.uniq!
            frameworks.sort!
            if !frameworks.empty? || !warning.empty? || !error.empty?
                log = "#{file}\n"
                log << "外部依赖：#{frameworks.to_s}\n" unless frameworks.empty?
                log << "错误依赖：#{error.to_s}\n" unless error.empty?
                log << "不合理依赖：#{warning.to_s}\n" unless warning.empty?
                return log
            end
            return nil
        end
        
    end

end

