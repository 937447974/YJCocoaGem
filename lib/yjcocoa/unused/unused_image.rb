#
#  unused_image.rb
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
    class UnusedImage < Unused
        
        self.command = 'image'
        self.summary = 'unused image commands'
        self.description = '查找 OC 项目中未使用的 image'
        
        def self.options
            [['--dir', '项目文件夹'],
            ['--ignore', '忽略的字符串匹配, 多字符串用 "," 分隔'],
            ['--output', '日志存放路径，默认当前路径']] + super
        end
    
        # property
        attr_accessor :dir
        attr_accessor :image_hash
        attr_accessor :class_content
        
        # 初始化
        def initialize(argv)
            super
            self.dir = argv.option('dir')
            self.image_hash = Hash.new
            self.class_content = ""
        end
        
        # businrss
        def validate!
            super
            unless self.dir && self.dir.length > 0
                puts "dir 文件地址为空".red
                self.banner!
            end
            unless Dir.exist?(self.dir)
                puts "dir 文件路径 #{self.dir} 不是文件夹".red
                self.banner!
            end
        end
        
        def run
            unused_image = self.unreferenced_image
            puts "分析完毕，打开日志：#{self.output}".green
            File.write(self.output, unused_image.join("\n"))
            `open #{self.output}`
        end
        
        def unreferenced_image
            self.deal_with_path(self.dir)
            puts "分析图片资源".green
            result = []
            self.image_hash.each {|key, value|
                puts key
                result += value unless self.class_content.include?(key)
            }
            return result.sort
        end
        
        
        def deal_with_path(path)
            Dir.chdir(path) {
                Dir["**/*.{png,jpg}"].each {|filename| self.deal_with_image(filename)}
                Dir["**/*.{h,m,mm,swift,xib,storyboard,plist}"].each {|filename| self.deal_with_file(filename)}
            }
        end
        
        def deal_with_image(filename)
            return if self.check_ignore(filename)
            basename = File.basename(filename)
            image_gsub = [".png", ".jpg", "@1x", "@2x", "@3x", "@1X", "@2X", "@3X"]
            image_gsub.each {|gsub| basename.gsub!(gsub, "")}
            if self.image_hash.include?(basename)
                self.image_hash[basename] << filename
            else
                self.image_hash[basename] = [filename]
            end
        end
        
        def deal_with_file(filename)
            self.class_content << File.read(filename) unless File.symlink?(filename)
        end
        
    end

end

