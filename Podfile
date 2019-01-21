platform :ios, '11.0'
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

def common
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'SwiftLint'
    pod 'KeychainAccess'
    pod 'GoogleAnalytics'
    pod 'SDVersion'
    pod 'Gallery'
end

target 'PerfectDude' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  common
  pod 'IHKeyboardAvoiding'

  # Pods for PerfectDude

  target 'PerfectDudeTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PerfectDudeUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'Core' do
    common
end

target 'BlockstackPlatform' do
    common
    pod 'Blockstack'
end

target 'FirebasePlatform' do
    common
    pod 'Firebase/Core'
end
