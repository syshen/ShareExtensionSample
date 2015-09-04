//
//  CustomSharingViewController.swift
//  popmock
//
//  Created by syshen on 9/4/15.
//  Copyright (c) 2015 syshen. All rights reserved.
//

import UIKit
import MobileCoreServices

class CustomSharingViewController: UITableViewController {

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
        
        let barItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "cancel:")
        self.navigationItem.rightBarButtonItem = barItem

    }
    
    func cancel(sender:AnyObject) {
        self.extensionContext?.completeRequestReturningItems(nil, completionHandler: nil)
    }

    func uniqueFileName() -> String {
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd-HHmmss"
        return dateFormatter.stringFromDate(now)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("projectCell", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = "Project #\(indexPath.row)"

        return cell
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let docUrl = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.in.popapp") {
            if let image = self.selectedImage {
                let url = docUrl.URLByAppendingPathComponent(self.uniqueFileName()).URLByAppendingPathExtension("png")
                let data = UIImagePNGRepresentation(image)
                data.writeToURL(url, atomically: true)
                
                self.extensionContext?.completeRequestReturningItems(nil, completionHandler: nil)

            }
        }
    }


}
