#
# Be sure to run `pod lib lint MJSDK-iOS-cocoapods.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MJSDK-cocoapods'
  s.version          = '1.4.2.1'
  s.summary          = 'summary of MJSDK-cocoapods.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
description of MJSDK-cocoapods.
                       DESC

  s.homepage         = 'https://github.com/LX314/MJSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LX314' => '1094426094@qq.com' }
  s.source           = { :git => 'https://github.com/LX314/MJSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = 'MJSDK-cocoapods/Classes/**/*'
  
   s.resource_bundles = {
     'MJSDK-iOS-cocoapods' => ['MJSDK-cocoapods/Assets/*']
   }

#   s.public_header_files = 'MJSDK-cocoapods/Classes/**/*.h'
s.public_header_files = 'MJSDK-cocoapods/Classes/MJSDK/Manager.h'
   s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

#/******************Optional******************/
#s.dependency 'ShareSDK'
#s.dependency 'ShareSDKExtension'
#s.dependency 'ShareSDKUI'
#ShareSDKUI.bundle
#/******************WeChatSDK******************/
#s.dependency 'libWeChatSDK'
#WechatAuthSDK.h
#WXApi.h
#WXApiObject.h
#/******************Required******************/
##s.dependency 'MOBFoundation'
#ShareSDK.bundle
##s.dependency 'ShareSDKConnector'

s.dependency 'AFNetworking'
s.dependency 'Masonry'
s.dependency 'Mantle'
s.dependency 'OpenSSL'
s.dependency 'MBProgressHUD'
s.dependency 'SSKeychain'
s.dependency 'ReactiveCocoa', '~>2.0'

#******************
s.dependency 'ShareSDK2'
s.dependency 'MOBFoundation'
s.dependency 'ShareSDK2/UI/iPhoneDefault'
s.dependency 'ShareSDK2/Connection/WeChat'

end