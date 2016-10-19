//
//  Model.swift
//  PageBasedApp
//
//  Created by Imanou Petit on 17/10/2016.
//  Copyright © 2016 Imanou Petit. All rights reserved.
//

import Foundation

class Model {
    
    /// The array containing the elements to display.
    var array: [String]
    /// `selectedIndexPath` keeps a reference of the selected indexPath.
    var selectedIndexPath: NSIndexPath
    
    init() {
        array = [Int](1...20).map(String.init)
        selectedIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    }
    
}
