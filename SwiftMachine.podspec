#
# Be sure to run `pod lib lint SwiftMachine.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftMachine'
  s.version          = '1.0.3'
  s.summary          = 'A Finite-like state machine written in Swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'A simple, lightweight, yet powerful way to to manage state and state transitions in your application.'

  s.homepage         = 'https://github.com/bangerang/SwiftMachine'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'bangerang' => 'jo1han@hotmail.com' }
  s.source           = { :git => 'https://github.com/bangerang/SwiftMachine.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/johanthorell'
  s.exclude_files = "SwiftMachine/*.plist"

  s.swift_version = '3.2'
  s.ios.deployment_target = '10.0'

  s.source_files = 'SwiftMachine/**/*'
  
end