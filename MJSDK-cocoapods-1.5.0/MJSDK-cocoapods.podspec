Pod::Spec.new do |s|
  s.name = 'MJSDK-cocoapods'
  s.version = '1.5.0'
  s.summary = 'summary of MJSDK-cocoapods.'
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"LX314"=>"1094426094@qq.com"}
  s.homepage = 'https://github.com/LX314/MJSDK'
  s.description = 'description of MJSDK-cocoapods.'
  s.source = { :path => '.' }

  s.ios.deployment_target    = '7.0'
  s.ios.preserve_paths       = 'ios/MJSDK-cocoapods.framework'
  s.ios.public_header_files  = 'ios/MJSDK-cocoapods.framework/Versions/A/Headers/*.h'
  s.ios.resource             = 'ios/MJSDK-cocoapods.framework/Versions/A/Resources/**/*'
  s.ios.vendored_frameworks  = 'ios/MJSDK-cocoapods.framework'
end
