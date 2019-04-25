Pod::Spec.new do |s|
  s.name             = "Infinity"
  s.version          = "4.0.0"
  s.summary          = "A simple way to make UIScrollView support pull-to-refresh & infinity-scroll"
  s.homepage         = "https://github.com/selfcreator/Infinity"
  s.license          = 'MIT'
  s.author           = { "DanisFabric" => "danisfabric@gmail.com" }
  s.source           = { :git => "https://github.com/selfcreator/Infinity.git", :tag => s.version.to_s }
  s.platform     = :ios, '11.0'
  s.requires_arc = true
  s.source_files = 'Infinity/**/*'
  s.exclude_files = "Infinity/**/*.plist"
  s.swift_version = '4.2'
  s.ios.deployment_target  = '10.0'

end
