#
#  Be sure to run `pod spec lint MZArch.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "MZArch"
  s.version      = "0.0.1"
  s.summary      = "A usefull architecture design framwork for iOS."
  s.description  = <<-DESC
                   "A usefull architecture design framwork for iOS."
                   DESC

  s.homepage     = "https://github.com/jaminzzhang/MZArch"
  s.license      = "MIT"
  s.author       = { "Jamin" => "jaminzzhang@gmail.com" }

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/jaminzzhang/MZArch.git", :tag => "#{s.version}" }
  s.source_files  = "MZArch", "MZArch/**/*.{h,m}"
  s.public_header_files = "MZArch/**/*.h"
  s.frameworks = "Foundation", "UIKit"
  s.dependency "SQLite.swift"
  s.dependency "Alamofire"

end
