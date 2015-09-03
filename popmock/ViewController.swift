//
//  ViewController.swift
//  popmock
//
//  Created by syshen on 9/3/15.
//  Copyright (c) 2015 syshen. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialization()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialization()
    }
    
    func initialization() {
        self.imageView.frame = self.bounds
        self.addSubview(self.imageView)
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.backgroundColor = UIColor.clearColor()
    }
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collectionView:UICollectionView!
    private var items = [NSURL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let docUrl = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.in.popapp") {
            if let dirContents = NSFileManager.defaultManager().contentsOfDirectoryAtURL(docUrl, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles | NSDirectoryEnumerationOptions.SkipsPackageDescendants, error: nil) {
                
                let filesOrDirs = dirContents as! [NSURL]
                self.items = filter(filesOrDirs, { (url:NSURL) -> Bool in
                    if url.path!.rangeOfString(".png") != nil {
                        return true
                    }
                    return false
                })
                
            }
        }
        
        
        self.collectionView.registerClass(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        self.collectionView.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        
        let url = self.items[indexPath.row]
        cell.imageView.image = UIImage(contentsOfFile: url.path!)
        
        return cell
    }

}

