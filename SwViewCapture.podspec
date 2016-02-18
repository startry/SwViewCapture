Pod::Spec.new do |s|
s.name             = "SwViewCapture"
s.version          = "0.1.0"
s.summary          = "A nice iOS View Capture Library which can capture all content."

s.description      = <<-DESC
					A nice iOS View Capture Library which can capture all content.
                     DESC

s.homepage         = "https://github.com/startry/SwViewCapture"
s.license          = 'MIT'
s.author           = { "chenxing.cx" => "chenxingfl@gmail.com" }
s.source           = { :git => "https://github.com/startry/SwViewCapture.git" }
s.social_media_url = 'https://twitter.com/xStartry'

s.platform     = :ios, '8.0'
s.requires_arc = true

s.source_files  = ["SwViewCapture/*.swift", "SwViewCapture/SwViewCapture.h"]
s.public_header_files = ["SwViewCapture/SwViewCapture.h"]

end
