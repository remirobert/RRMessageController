Pod::Spec.new do |s|
  s.name             = "RRMessageSendController"
  s.version          = "0.1"
  s.summary          = "RRMessagecontroller."
  s.description      = <<-DESC
  		      RRMessagecontroller allows you to write message with photos.
                        DESC
  s.homepage         = "https://github.com/remirobert/RRMessagecontroller.git"
  s.license          = 'MIT'
  s.author           = { "remi robert" => "remirobert33530@gmail.com" }
  s.source           = { :git => "https://github.com/RRMessageController.git" }
 
  s.platform     = :ios, '7.0' 
  s.source_files = 'classes/'
 
end