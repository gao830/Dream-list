//
//  MainVC.swift
//  DreamList
//
//  Created by Bill Gao on 2017/1/15.
//  Copyright © 2017年 Bill Gao. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{

    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
       
//        let count = fetchStoreCount()
//        if count == 0 {
//             generateTestData()
//        }

        attemptFetch()
    }

  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configuteCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func configuteCell(cell: ItemCell, indexPath: IndexPath) {
        let item = controller.object(at: indexPath)
        cell.configureCell(item: item)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let obj = controller.fetchedObjects, obj.count > 0 {
            let item = obj[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let typeSort = NSSortDescriptor(key: "toItemType.type", ascending: true)
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        
        if segment.selectedSegmentIndex == 0 {
            
            fetchRequest.sortDescriptors = [dateSort]
            
        } else if segment.selectedSegmentIndex == 1 {
            
            fetchRequest.sortDescriptors = [priceSort]
            
        } else if segment.selectedSegmentIndex == 2 {
            
            fetchRequest.sortDescriptors = [titleSort]
            
        } else if segment.selectedSegmentIndex == 3 {
            fetchRequest.sortDescriptors = [typeSort]
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        self.controller = controller
        
        do{
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
            
        }
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        attemptFetch()
        tableView.reloadData()
    }
    
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configuteCell(cell: cell, indexPath: indexPath)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func generateTestData() {
        let item = Item(context: context)
        item.title = "MacBook Pro"
        item.price = 1800
        item.details = "My new laptop >_<"
        
        let item3 = Item(context: context)
        item3.title = "Tesla Model S"
        item3.price = 110000
        item3.details = "My dream car one day I will buy"
        
        let item2 = Item(context: context)
        item2.title = "Bose Headphones"
        item2.price = 300
        item2.details = "A nice new headphone I like to have one"
        

        ad.saveContext()
        
    }
    
    func fetchStoreCount() -> Int {
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
//            print("Current Store Data Count : \(count)")
            return count
        } catch let err as NSError {
            print(err.description)
            return 0
        }
        
    }


    

}

