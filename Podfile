source 'https://github.com/CocoaPods/Specs.git'

# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'



target 'SmartdigimktSDKDemo' do

  pod 'SmartdigimktSDK', '6.5.36' 
  pod 'Masonry'
  pod 'SDWebImage'
  pod "ZYGCDTimer"
  pod 'AMLeaksFinder', '2.1.3',  :configurations => ['Debug']
  pod 'JCPerformanceMonitor'
  pod 'WechatOpenSDK'
  pod 'Bugly'
  
#  适配 iOS13 编译
  post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
           end
      end
    end
  end

end
