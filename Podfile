# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ServinV2' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ServinV2
pod 'GoogleMaps'
pod 'GooglePlaces'
pod 'KYNavigationProgress'
pod 'IQKeyboardManagerSwift'
pod 'SideMenu'
pod 'DZNEmptyDataSet'
pod "Macaw", "0.9.1"
pod 'Pulley'
pod 'PinpointKit'
pod 'TLPhotoPicker'
pod 'ImageSlideshow', '~> 1.6'
pod 'Alamofire', '~> 4.7'
pod 'SwiftyJSON', '~> 4.0'
pod 'AlamofireImage', '~> 3.3'
pod 'Eureka'

#AWS Pods
pod 'AWSCore', '~> 2.6.0'
pod 'AWSCognitoIdentityProvider', '~> 2.6.0'


#Stripe
pod 'Stripe'

#cardIO
pod 'CardIO'

  target 'ServinV2Tests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ServinV2UITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    # add this line
    target.new_shell_script_build_phase.shell_script = "mkdir -p $PODS_CONFIGURATION_BUILD_DIR/#{target.name}"
    target.build_configurations.each do |config|
      config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
    end
  end
end
