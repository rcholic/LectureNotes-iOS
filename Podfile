# Uncomment this line to define a global platform for your project
platform :ios, '8.1'

use_frameworks!

target 'MultiMediaNotes' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
    pod 'SnapKit'
    pod 'SwiftDate', '~> 4.0'
    pod 'WYPopoverController', '~> 0.2.2'
    pod 'IQAudioRecorderController'
    pod 'RealmSwift'

  # Pods for MultiMediaNotes

  target 'MultiMediaNotesTests' do
    #inherit! :search_paths
  end

  target 'MultiMediaNotesUITests' do
    #inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0' # or '3.0'
    end
  end
end
