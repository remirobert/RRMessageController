Pod::Spec.new do |s|
  s.name             = "RRMessageSendController"
  s.version          = "0.1.0"
  s.summary          = "RRMessagecontroller."
  s.description      = <<-DESC
  		      RRMessagecontroller allows you to write message with photos.
                        DESC
  s.homepage         = "https://github.com/remirobert/RRMessagecontroller.git"
  s.license          = 'MIT'
  s.author           = { "remi robert" => "remirobert33530@gmail.com" }
  s.source           = { :git => "https://github.com/RRMessageController.git", :commit => "ef9610bd29390342d1c37ef564d775f452c72d16", :tag => 'v0.1.0' }
 
  s.platform     = :ios, '7.0' 
  s.source_files = 'classes/'
 
end