Pod::Spec.new do |s|
  s.name         		 = 'FangYuanObjC'
  s.version      		 = '0.0.1'
  s.summary      		 = "Private"
  s.author       		 = { "王策" => "634692517@qq.com" }
  s.homepage     		 = "https://github.com/HaloWang/Halo"
  s.platform     		 = :ios, "7.0"
  s.source       		 = { :path => '.' }
  s.source_files 		 = "*.{h,m}"
  s.public_header_files  = 'UIView+FangYuan.h'
  s.private_header_files = 'UIView+FangYuanPrivate.h'
end
