
Pod::Spec.new do |s|

  s.name         = "LPTagsView"
<<<<<<< HEAD
  s.version      = "0.0.3"
=======
  s.version      = "0.0.2"
>>>>>>> 4ce42920af356cd7f76d3eb5d82da39b71a5425d
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
