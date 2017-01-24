//
//  Item+CoreDataClass.swift
//  DreamList
//
//  Created by Bill Gao on 2017/1/15.
//  Copyright © 2017年 Bill Gao. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
    }

}
