# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

use_frameworks!
inhibit_all_warnings!

target 'BlablaBlock' do

  # Pods for BlablaBlock
  # pod 'RealmSwift'

  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxGesture'
  pod 'RxReachability'
  pod 'RxSwiftExt/Core'
  # pod 'RxRealm'

  # pod 'Moya/RxSwift'
  # pod 'SwiftyJSON'

  pod 'PromiseKit'
  pod 'SnapKit', '~> 5.0.0'
  pod 'Resolver'

  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'

  pod 'IQKeyboardManager'

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
