Pod::Spec.new do |s|
  s.name = 'SwiftyNotificationCenter'
  s.version = '0.1.0'
  s.license = 'MIT'
  s.summary = 'A Swifty wrapper for NSNotificationCenter'
  s.homepage = 'https://github.com/jshier/SwiftyNotificationCenter'
  s.social_media_url = 'https://twitter.com/jshier'
  s.authors = { 'Jon Shier' => 'jon@jonshier.com' }
  s.source = { :git => 'https://github.com/jshier/SwiftyNotificationCenter.git', :tag => s.version }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'Source/*.swift'
end
