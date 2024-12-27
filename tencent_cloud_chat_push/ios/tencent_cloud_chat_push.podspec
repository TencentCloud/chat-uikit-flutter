#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tencent_cloud_chat_push.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tencent_cloud_chat_push'
  s.version          = '8.3.6498'
  s.summary          = 'Notification push for Tencent Cloud Chat.'
  s.description      = <<-DESC
Notification push for Tencent Cloud Chat.
                       DESC
  s.homepage         = 'https://trtc.io/products/chat?utm_source=flutter_demo&utm_medium=link&utm_campaign=%E6%B8%A0%E9%81%93&_channel_track_key=k6WgfCKn'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Tencent' => 'owennwang@tencent.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.dependency 'TIMPush', "= 8.3.6498"
  s.dependency 'TXIMSDK_Plus_iOS_XCFramework'
end
