Pod::Spec.new do |s|
  s.name         = "CCLogSystem"
  s.version      = "1.0.0"
  s.summary      = "A Log system for iOS."
  s.description  = <<-DESC
                   This library provide  an iOS Log System. We can use it to replace NSLog.
                   And It also can record the log to the local files.
                   We can directly review these logs in our app, and email to ourselves.
                   DESC
  s.homepage     = "https://github.com/yechunjun/CCLogSystem"
  s.license      = "MIT"
  s.author             = { "Chun Ye" => "chunforios@gmail.com" }
  s.social_media_url   = "http://chun.tips"
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/yechunjun/CCLogSystem.git", :tag => "1.0.0" }
  s.source_files  = "CCLogSystem/CCLogSystem/*.{h,m}"
  s.frameworks = "Foundation", "UIKit"
  s.requires_arc = true
end
