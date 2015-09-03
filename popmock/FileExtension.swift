//
//  FileExtension.swift
//  PlayUI
//
//  Created by syshen on 7/13/15.
//  Copyright (c) 2015 Intelligent Gadget. All rights reserved.
//

import Foundation

extension NSFileManager {
    class var documentURL:NSURL {
        get {
            let docs = defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            return docs[0] as! NSURL
        }
    }
}
