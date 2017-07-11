#
# Be sure to run `pod lib lint ResearchSuiteExtensions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ResearchSuiteExtensions'
  s.version          = '0.0.1'
  s.summary          = 'A short description of ResearchSuiteExtensions.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/jdkizer9/ResearchSuiteExtensions'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jdkizer9' => 'jdkizer9@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/jdkizer9/ResearchSuiteExtensions.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.subspec 'Common' do |common|
    common.source_files = 'source/Common/Classes/**/*'
    common.dependency 'ResearchKit', '~> 1.4'
  end

  s.subspec 'Core' do |core|
    core.source_files = 'source/Core/Classes/**/*'
    core.dependency 'ResearchKit', '~> 1.4'
  end

  s.subspec 'RSTBSupport' do |rstb|
    rstb.source_files = 'source/RSTBSupport/Classes/**/*'
    rstb.dependency 'ResearchSuiteExtensions/Core'
    rstb.dependency 'ResearchSuiteTaskBuilder', '~> 0.4'
    rstb.dependency 'Gloss', '~> 1'
  end

  # s.resource_bundles = {
  #   'ResearchSuiteExtensions' => ['ResearchSuiteExtensions/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
