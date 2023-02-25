
Pod::Spec.new do |spec|
  spec.name         = "TFY_BannerscrollKit"
  
  spec.version      = "2.5.6"

  spec.summary      = "无限滚动视图，使用各种场景，如卡片，扇形，广告。。。"

  spec.description  = <<-DESC
                    无限滚动视图，使用各种场景，如卡片，扇形，广告。。。
                    DESC

  spec.homepage     = "https://github.com/13662049573/TFY_Bannerscroll"
  
  spec.license      = "MIT"
 
  spec.platform     = :ios, "12.0"

  spec.author       = { "tfyzxc13662049573" => "420144542@qq.com" }
  
  spec.source       = { :git => "https://github.com/13662049573/TFY_Bannerscroll.git", :tag => spec.version}

  spec.source_files  = "TFY_Bannerscroll/TFY_BannerscrollKit/TFY_BannerscrollKit.h"

  spec.subspec 'TFY_BannerView' do |s_s|
    s_s.dependency "TFY_BannerscrollKit/TFY_ITools"
    s_s.source_files  = "TFY_Bannerscroll/TFY_BannerscrollKit/TFY_BannerView/**/*.{h,m}"
  end

  spec.subspec 'TFY_ITools' do |s_s|
    s_s.source_files  = "TFY_Bannerscroll/TFY_BannerscrollKit/TFY_ITools/**/*.{h,m}"
  end

  spec.resources     = "TFY_Bannerscroll/TFY_BannerscrollKit/TFY_banner.bundle"
  
  spec.requires_arc = true
  
  spec.dependency "SDWebImage"
  
end
