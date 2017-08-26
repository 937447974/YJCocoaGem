#
#  yjcocoa
#  YJCocoa
#
#  https://github.com/937447974
#  YJ技术支持群: 557445088
#  Email: 937447974@qq.com
#
#  Created by 阳君 on 17/8/1.
#  Copyright © 2017年 YJCocoa. All rights reserved.
#
# http://guides.rubygems.org/specification-reference/
# gem build yjcocoa.gemspec
# gem install yjcocoa-17.8.22.gem
# gem push yjcocoa-17.8.26.gem

require File.expand_path('../lib/yjcocoa/gem_version', __FILE__)
require 'date'

Gem::Specification.new do |s|

    s.name     = "yjcocoa"
    s.version  = YJCocoa::VERSION
    s.date     = Date.today
    s.license  = "MIT"
    s.email    = ["937447974@qq.com"]
    s.homepage = "https://github.com/937447974/YJCocoaGem"
    s.author   = "阳君"

    s.summary     = "YJCocoa, the Cocoa library package manager."
    s.description = "YJ系列开源工具"

    s.files = Dir["lib/**/*.rb"] + %w{ bin/yjcocoa README.md LICENSE }

    s.executables   = %w{ yjcocoa }
    s.require_paths = %w{ lib }

    s.add_runtime_dependency 'claide',   '~> 1.0', '>= 1.0.2'
    s.add_runtime_dependency 'colored2', '~> 3.1', '>= 3.1.2'

    ## Make sure you can build the gem on older versions of RubyGems too:
    s.rubygems_version = "1.6.2"
    s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
    s.required_ruby_version = '>= 2.0.0'
    s.specification_version = 3 if s.respond_to? :specification_version

end
