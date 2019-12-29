
Pod::Spec.new do |spec|
  spec.name         = "TFY_BannerscrollKit"
  
  spec.version      = "2.0.0"

  spec.summary      = "无限滚动视图，使用各种场景，如卡片，扇形，广告。。。"

  spec.license      = "Copyright (c) 2018年 WMZ. All rights reserved."

  spec.description  = <<-DESC
                    无限滚动视图，使用各种场景，如卡片，扇形，广告。。。
                    DESC

  spec.homepage     = "https://github.com/13662049573/TFY_Bannerscroll"
  
  spec.license      = {:type => "MIT", :file => "LICENSE" }
 
  spec.author       = { "tfyzxc13662049573" => "420144542@qq.com" }
  
  spec.source       = { :git => "https://github.com/13662049573/TFY_Bannerscroll.git", :tag => s.version.to_s }

  spec.source_files  = "TFY_Bannerscroll/TFY_BannerscrollKit/TFY_BannerscrollHeader.h","TFY_Bannerscroll/TFY_BannerscrollKit/**/*.{h,m}"

  spec.user_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }

  spec.frameworks    = "Foundation","UIKit"
  
end
