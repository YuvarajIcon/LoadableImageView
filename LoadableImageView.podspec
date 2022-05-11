#
# Be sure to run `pod lib lint LoadableImageView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LoadableImageView'
  s.version          = '0.1.0'
  s.summary          = 'A library to download and show images seamlessly.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'A library to download images and show them seamlessly without the headache of thread safety.'

  s.homepage         = 'https://github.com/YuvarajIcon/LoadableImageView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'YuvarajIcon' => 'yuvaraj.australia@gmail.com' }
  s.source           = { :git => 'https://github.com/YuvarajIcon/LoadableImageView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'LoadableImageView/Classes/**/*'
  s.swift_versions = '4.0'
  # s.resource_bundles = {
  #   'LoadableImageView' => ['LoadableImageView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Downloader'
  s.dependency 'HelpfulExtensions'
end
