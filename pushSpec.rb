#!/usr/bin/env ruby

if ARGV.length == 2

    podSpec = ARGV[0]
    tag = ARGV[1]

    system "env -i git tag -a #{tag} -m \"new pod release\""
    system "env -i git push origin --tags"
    system "pod trunk push #{podSpec} --use-libraries --allow-warnings"

else
  puts "Usage: ruby -r cocoapodsUtils.rb -e pushSpec '[podspec-name.podspec]' '[version]'"
end
