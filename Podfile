# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

plugin 'cocoapods-keys', {
  :project => "Maps",
  :keys => [
    "GoogleMapsApiKey"
  ]
}

target 'Maps' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Maps
  pod 'GoogleMaps'

  target 'MapsTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
