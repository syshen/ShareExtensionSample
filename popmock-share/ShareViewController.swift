//
//  ShareViewController.swift
//  popmock-share
//
//  Created by syshen on 9/3/15.
//  Copyright (c) 2015 syshen. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {

    var selectedImage:UIImage?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let content = self.extensionContext!.inputItems[0] as! NSExtensionItem
        let contentType = kUTTypeImage as String
        
        for attachment in content.attachments as! [NSItemProvider] {
            if attachment.hasItemConformingToTypeIdentifier(contentType) {
                
                attachment.loadItemForTypeIdentifier(contentType, options: nil) { data, error in
                    if error == nil {
                        let url = data as! NSURL
                        if let imageData = NSData(contentsOfURL: url) {
                            self.selectedImage = UIImage(data: imageData)
                        }
                    } else {
                        
                        let alert = UIAlertController(title: "Error", message: "Error loading image", preferredStyle: .Alert)
                        
                        let action = UIAlertAction(title: "Error", style: .Cancel) { _ in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        
                        alert.addAction(action)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        
    }
    override func isContentValid() -> Bool {
        if self.selectedImage != nil {
            return true
        }
        
        return false
    }
    
    func uniqueFileName() -> String {
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyymmdd-HHmmss"
        return dateFormatter.stringFromDate(now)
    }

    override func didSelectPost() {
        
        if let docUrl = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.in.popapp") {
            if let image = self.selectedImage {
                let url = docUrl.URLByAppendingPathComponent(self.uniqueFileName()).URLByAppendingPathExtension("png")
                let data = UIImagePNGRepresentation(image)
                data.writeToURL(url, atomically: true)
            }
        }
        
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
    }

    override func configurationItems() -> [AnyObject]! {

        
        let item1 = SLComposeSheetConfigurationItem()
        item1.title = "Projects"
        item1.value = "test project"
        
        item1.tapHandler = { [unowned self] in
            let projectsViewController = ProjectsViewController()
            self.pushConfigurationViewController(projectsViewController)
        }
        
        return [item1]
    }

}

class ProjectsViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.alpha = 0.5
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "projectCell")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("projectCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = "Project \(indexPath.row)"
        return cell
    }
}
