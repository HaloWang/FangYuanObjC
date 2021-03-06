
Pod::Spec.new do |s|
  s.name                = "FangYuanObjC"
  s.version             = "0.1.8"
  s.summary             = "A lightweght layout tool written by Objective-C"
  s.homepage            = "https://github.com/HaloWang/FangYuanObjC"
  s.license             = { :type => "MIT", :file => "LICENSE" }
  s.author              = { "王策" => "634692517@qq.com" }
  s.platform            = :ios, "7.0"
  s.source              = { 
    :git => "https://github.com/HaloWang/FangYuanObjC.git", 
    :tag => s.version }
  s.source_files        = "FangYuanObjC/*.{h,m}"
  s.public_header_files = "FangYuanObjC/UIView+FangYuan.h"
  s.framework           = "UIKit"
  s.requires_arc        = true
end
