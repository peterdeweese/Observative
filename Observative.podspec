Pod::Spec.new do |s|
  s.name         = "Observative"
  s.version      = "0.0.3"
  s.summary      = "BoundUserDefaults allows you to get and set user defaults as simple subclass properties."
  s.homepage     = "https://github.com/peterdeweese/Observative"
  s.license      = "MIT"
  s.author       = { "Peter DeWeese" => "peter@dewee.se" }
  s.requires_arc = true
  s.source       = { :git => "https://github.com/peterdeweese/Observative.git", :tag => s.version }
  s.source_files = "lib/*.{h,m,swift}"
  s.public_header_files = "lib/*.h"

  s.ios.deployment_target = '9.0'

  s.osx.deployment_target = '10.10'
end
