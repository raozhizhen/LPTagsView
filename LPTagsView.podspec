
Pod::Spec.new do |s|

  s.name         = "LPTagsView"
  s.version      = "0.0.1"
  s.summary      = "tags collectionView"
  s.homepage     = "https://github.com/raozhizhen/LPTagsView.git"
  s.author       = { "raozhizhen" => "raozhizhen@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/raozhizhen/LPTagsView.git", :tag => s.version }
  s.license      = { :type => "MIT", :file => "LICENSE" }  
  s.source_files = "LPTagsView/*.{h,m}" 
  s.dependency   "UICollectionViewLeftAlignedLayout"  
  s.requires_arc = true

end
