platform :ios, '10.0'
use_frameworks!

target 'WakeUp' do
    pod 'LeanCloud', :git => "https://github.com/leancloud/swift-sdk.git"
    pod 'TPKeyboardAvoiding'
    pod 'Kingfisher', '~> 3.0'
    pod 'Spring', :git => 'https://github.com/MengTo/Spring.git', :branch => 'swift3'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
