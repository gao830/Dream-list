//
//  ItemCell.swift
//  DreamList
//
//  Created by Bill Gao on 2017/1/16.
//  Copyright © 2017年 Bill Gao. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    @IBOutlet weak var itemType: UILabel!
    @IBOutlet weak var store: UILabel!
    
    func configureCell(item: Item) {
        title.text = item.title
        price.text = "$\(item.price)"
        detail.text = item.details
        thumb.image = item.toImage?.image as? UIImage
        store.text = item.toStore?.name
        itemType.text = item.toItemType?.type
    }
}
