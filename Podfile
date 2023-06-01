# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'Work.AJ.SM' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  # Pods for Work.AJ.SM
  pod 'ESTabBarController-swift', '2.8.0'
  pod 'SDCycleScrollView', '1.82'
  pod 'BetterSegmentedControl', '~> 2.0.1'
  pod 'LTMorphingLabel', '~> 0.9.3'
  pod 'YPImagePicker', '5.2.1'
  pod 'swiftScan', '1.2.1'
  
  pod 'Haptica', '3.0.3'
  pod 'IQKeyboardManagerSwift', '6.5.9'
  pod 'R.swift', '6.1.0'
  pod 'SVProgressHUD', '2.2.5'
  pod 'ActiveLabel', '1.1.0'
  pod 'PGDatePicker', '2.6.9'
  pod 'MJRefresh', '3.7.5'
  pod 'YYCache'
  pod 'YYCategories'
  
  pod 'JCore', '2.1.4-noidfa'
  pod 'JPush', '3.2.4-noidfa'
  
  pod 'AgoraRtm_iOS'
  pod 'AgoraRtcEngine_iOS', '3.7.0', :subspecs => ['RtcBasic']
end


post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
               end
          end
   end
end
