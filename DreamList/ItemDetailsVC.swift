//
//  ItemDetailsVC.swift
//  DreamList
//
//  Created by Bill Gao on 2017/1/19.
//  Copyright © 2017年 Bill Gao. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
   
    @IBOutlet weak var thumbImg: UIImageView!
    
    var count = 0
    var stores = [Store]()
    var itemTypes = [ItemType]()
    var imagePicker: UIImagePickerController!
    
    private var _itemToEdit: Item!
    var itemToEdit: Item! {
        get {
            return _itemToEdit
        } set {
            _itemToEdit = newValue
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
            
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let count = fetchStoreCount()
        if count == 0 {
            createStores()
        }
        let count1 = fetchTypeCount()
        if count1 == 0 {
            createType()
        }
        getStores()
        getType()
        
        if itemToEdit != nil {
            loadItemData()
        }
       print("\(count1)")

    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    

    func createStores() {
        let store1 = Store(context: context)
        store1.name = "Best Buy"
        let store2 = Store(context: context)
        store2.name = "Tesla Dealer"
        let store3 = Store(context: context)
        store3.name = "Frys"
        let store4 = Store(context: context)
        store4.name = "Target"
        let store5 = Store(context: context)
        store5.name = "Amazon"
        let store6 = Store(context: context)
        store6.name = "Walmart"
        ad.saveContext()
    }
    
    func createType() {
        
        
        
        
        let type1 = ItemType(context: context)
        type1.type = "Electronics"
        ad.saveContext()
        let type2 = ItemType(context: context)
        type2.type = "Vehicles"
        ad.saveContext()
        let type3 = ItemType(context: context)
        type3.type = "Video Games"
        ad.saveContext()
        let type4 = ItemType(context: context)
        type4.type = "Software"
        ad.saveContext()
        let type5 = ItemType(context: context)
        type5.type = "Other"
        ad.saveContext()
    }

    
    
    
    func fetchStoreCount() -> Int {
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
//            print("Current Store Data Count : \(count)")
            return count
        } catch let err as NSError {
            print(err.description)
            return 0
        }
        
    }
    
    func fetchTypeCount() -> Int {
        
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            //            print("Current Store Data Count : \(count)")
            return count
        } catch let err as NSError {
            print(err.description)
            return 0
        }
        
    }

    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let store = stores[row]
            return store.name
        } else {
            let type = itemTypes[row]
//            print("\(type.type!)")
            return type.type
        }
    
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return stores.count
        }
        else {
            return itemTypes.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            //
        }
        
    }
    
    func getType() {
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        do {
            self.itemTypes = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            //
        }
        
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        var item: Item!
        let picture = Image(context: context)
        picture.image = thumbImg.image
        
        
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        item.toImage = picture
        if let title = titleField.text {
            item.title = title
        }
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
            
        }
        if let details = detailsField.text {
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        item.toItemType = itemTypes[storePicker.selectedRow(inComponent: 1)]
        
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func loadItemData() {
        
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumbImg.image = item.toImage?.image as! UIImage?
            
            if let store = item.toStore {
                var index = 0
                repeat {
                    
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                    
                } while (index < stores.count)
            }
            
            if let type = item.toItemType {
                var index = 0
                repeat {
                    
                    let t = itemTypes[index]
                    if t.type == type.type {
                        storePicker.selectRow(index, inComponent: 1, animated: false)
                        break
                    }
                    index += 1
                    
                    
                } while (index < itemTypes.count)
            }

            
            
        }
    }
    
    
    
    @IBAction func addImg(_ sender: UIButton) {
//        print("hi")
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
            
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImg.image = img
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    

}
