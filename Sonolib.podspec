#
# Be sure to run `pod lib lint Sonolib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Sonolib'
  s.version          = '1.0.9'
  s.summary          = 'Sonolib swift version.'
  s.swift_versions   = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  # s.description      = 

  s.homepage         = 'https://github.com/sonocoin/sonolib-swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sonocoin@gmail.com' => 'tim@sonocoin.io' }
  s.source           = { :git => 'https://github.com/sonocoin/sonolib-swift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  s.source_files = 'Sonolib/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Sonolib' => ['Sonolib/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Sodium-Fork', '~> 0.8.0'
  s.dependency "Base58Swift"
  s.dependency 'Alamofire', '~> 5.2'
end
