
Pod::Spec.new do |spec|
  spec.name         = "TFY_BannerscrollKit"
  
  spec.version      = "2.1.6"

  spec.summary      = "无限滚动视图，使用各种场景，如卡片，扇形，广告。。。"

  spec.description  = <<-DESC
                    无限滚动视图，使用各种场景，如卡片，扇形，广告。。。
                    DESC

  spec.homepage     = "https://github.com/13662049573/TFY_Bannerscroll"
  
  spec.license      = "MIT"
 
  spec.platform     = :ios, "10.0"

  spec.author       = { "tfyzxc13662049573" => "420144542@qq.com" }
  
  spec.source       = { :git => "https://github.com/13662049573/TFY_Bannerscroll.git", :tag => spec.version}

  spec.source_files  = "TFY_Bannerscroll/TFY_BannerscrollKit/**/*.{h,m}"

  spec.frameworks    = "Foundation","UIKit"

  spec.xcconfig      = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include" }

  spec.requires_arc = true
  
end
