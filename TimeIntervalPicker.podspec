Pod::Spec.new do |s|
  s.name             = "TimeIntervalPicker"
  s.version          = "0.1.0"
  s.summary          = "An iOS picker view resembling look & feel of UIDatePicker in CountDownTimer mode, implemented in Swift"
  s.description      = <<-DESC
					   UIDatePicker in CountDownTimer mode is not customizable. Furthermore, as it is intended to be used for countdown timers, it doesn't allow to select the value of 0.

					   DPTimeIntervalPicker closely resembles its look & fell, while providing customization options for font faces and sizes. It also doesn't impose any limitations on the values, allowing anything from zero to 23 hours 59 minutes to be selected.
                       DESC
  s.homepage         = "https://github.com/dawiddr/TimeIntervalPicker"
  s.license          = 'MIT'
  s.author           = { "Dawid Drechny" => "dawid.drechny@gmail.com" }
  s.source           = { :git => "https://github.com/dawiddr/TimeIntervalPicker.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/*'
  s.frameworks = 'UIKit'
end
