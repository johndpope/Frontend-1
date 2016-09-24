Pod::Spec.new do |s|
  s.name             = 'Frontend'
  s.version          = '0.1.0'
  s.summary          = 'A frontend manager written in Swift'
  s.homepage         = 'https://github.com/pepibumur/Frontend'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pedro Piñera Buendía' => 'pepibumur@gmail.com' }
  s.source           = { :git => 'https://github.com/pepibumur/Frontend.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Frontend/Classes/**/*'
  s.dependency 'GCDWebServer', '~> 3.3'
  s.dependency 'NSURL+QueryDictionary', '~> 1.2'
  s.dependency 'SwiftyJSON', '~> 3.0'
  s.dependency 'Zip', '~> 0.6'
end
