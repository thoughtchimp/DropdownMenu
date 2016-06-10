
Pod::Spec.new do |s|
  s.name             = '$DropdownMenu'
  s.version          = '0.1.0'
  s.summary          = 'A dropdown menu for iOS'

  s.homepage         = 'https://github.com/thoughtchimp/DropdownMenu'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Thoughtchimp" => "whoop@thoughtchimp.com" }
  s.source           = { :git => 'https://github.com/thoughtchimp/DropdownMenu.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'DropdownMenu/*'
  s.resources = 'DropdownMenu/*.png'
   
end
