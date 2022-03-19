# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

use_frameworks!
inhibit_all_warnings!

target 'BlablaBlock' do

  # App
  pod 'Resolver'
  pod 'KeychainAccess'
  pod 'Defaults'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'

  # UI
  pod 'SnapKit', '~> 5.0.0'
  pod 'IQKeyboardManager'
  pod 'SwiftCharts', '~> 0.6.5'
  pod 'Differ'
  pod 'Tabman'
  pod 'Toast-Swift', '~> 5.0.1'

  # Network
  pod 'Moya/RxSwift'

  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxGesture'
  pod 'RxDataSources'
  # pod 'RxReachability'
  # pod 'RxSwiftExt/Core'

  target 'BlablaBlockTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'BlablaBlockUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end
