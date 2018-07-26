def current_branch
    list = (`git branch`).split("\n")
    for item in list
        if item =~ /\* /
            return item.gsub(/\* /, "")
        end
    end
end

unless current_branch =~ /master/
    puts "current_branch1"
end

puts "current_branch"
