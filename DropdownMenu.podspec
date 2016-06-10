
Pod::Spec.new do |s|
  s.name             = 'DropdownMenu'
  s.version          = '0.1.0'
  s.summary          = 'A dropdown menu for iOS'

  s.homepage         = 'https://github.com/thoughtchimp/DropdownMenu'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "ThoughtChimp" => "whoop@thoughtchimp.com" }
  s.source           = { :git => 'https://github.com/thoughtchimp/DropdownMenu.git', :tag => s.version.to_s }

  s.source_files = 'DropdownMenu/*.swift'
  s.resources = 'DropdownMenu/*.png'
  s.platform = :ios, '8.0'
  s.ios.deployment_target = '5.0'
  s.requires_arc = true
end
