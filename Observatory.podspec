Pod::Spec.new do |s|
  s.name         = "Observatory"
  s.version      = "0.0"
  s.summary      = "BoundUserDefaults allows you to get and set user defaults as simple subclass properties."
  s.homepage     = "https://github.com/peterdeweese/Observatory"
  s.license      = "MIT"
  s.author       = { "Peter DeWeese" => "peter@dewee.se" }
  s.requires_arc = true
  s.source       = { :git => "https://github.com/peterdeweese/Observatory.git", :tag => s.version }
  s.source_files = "Observatory/*.{h,m,swift}"
  s.public_header_files = "Observatory/*.h"

  s.ios.deployment_target = '9.0'

  s.osx.deployment_target = '10.10'
end
