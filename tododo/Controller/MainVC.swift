//
//  MainVC.swift
//  tododo
//
//  Created by Kings on 7/24/18.
//  Copyright © 2018 Kings. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class MainVC: UITableViewController {
    
    @IBOutlet var dodoTable: UITableView!
    
    let realm = try! Realm()
    
//    let defaults = UserDefaults.standard
    
//    let defaultManager = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first?.appendingPathComponent("Items.plist")
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
//    var itemArray = [Items]()
    var itemArray: Results<Item>?
    
    
    var selectedCategory: CatGory? {
        didSet{
            loadItem()
        }
    }
    
    var textF = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        dodoTable.tableFooterView = UIView(frame: CGRect.zero)
        print(FileManager.default.urls(for: .documentDirectory, in: .systemDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
//        loadItem()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return itemArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? itemCell else {return UITableViewCell()}
      
        if let item = itemArray?[indexPath.row] {
            cell.updateCell(item: item)
            
            cell.accessoryType = item.done == true ? .checkmark : .none
            
        }else{
            cell.itemName.text = "empty list"
          
        }
         return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let item = itemArray?[indexPath.row] {
//            item.done = !item.done
//            saveItems(item: item)
//        }
        
//        let manageContext = appDelegate?.persistentContainer.viewContext
//        manageContext?.delete(item)
//        itemArray.remove(at: indexPath.row)
        
        if let item = itemArray?[indexPath.row] {
            do{
                try realm.write {
//                    realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                debugPrint("error updating \(error.localizedDescription)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (_) in
//            guard let manageContext = self.appDelegate?.persistentContainer.viewContext else {return}
//            let newItem = Items(context: manageContext)
            
            if let currCategory = self.selectedCategory {
                let dateNow = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
                let dateString = formatter.string(from: dateNow)
                
                do{
                    
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = self.textF.text!
                        newItem.dateCreated = dateNow
                        currCategory.items.append(newItem)
                        try self.realm.add(newItem)
                    }
                }catch{
                    debugPrint("error here \(error.localizedDescription)")
                }
               
                //            newItem.parentCategory = self.selectedCategory
                //            self.itemArray.append(newItem)
            
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTF) in
            self.textF = alertTF
            alertTF.placeholder = "Create new item"
           
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
//    func saveItems(item: Item)
//    {
////        let encoder = PropertyListEncoder()
//        do{
////            guard let manageContext = self.appDelegate?.persistentContainer.viewContext else {return}
////            try manageContext.save()
////            let data = try encoder.encode(itemArray)
////            try data.write(to: defaultManager!)
//
//            try realm.write {
//                try realm.add(item)
//            }
//        }catch{
//            debugPrint("\(error.localizedDescription)")
//        }
//        self.dodoTable.reloadData()
//    }
    
// Coredata load
//    func loadItem(withRequest: NSFetchRequest<Items> = Items.fetchRequest(), predicate: NSPredicate? = nil)
//    {
//        guard let manageContext = self.appDelegate?.persistentContainer.viewContext else {return}
//        let catePredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory!.name!))
//        if let additionalPredicate = predicate {
//            let compPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, catePredicate])
//             withRequest.predicate = compPredicate
//        }else{
//            withRequest.predicate = catePredicate
//        }
//        do{
//            itemArray = try manageContext.fetch(withRequest)
//            //            if let data = try? Data(contentsOf: defaultManager!) {
//            //                let decoder = PropertyListDecoder()
//            //                itemArray = try decoder.decode([Item].self, from: data)
//        }catch{
//            debugPrint("error here \(error)")
//        }
//        tableView.reloadData()
//    }
    
    func loadItem()
    {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
}

extension MainVC: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let reqFetch = NSFetchRequest<Items>(entityName: "Items")
//        let predicate  = NSPredicate(format: "title CONTAINS [cd] %@", searchBar.text!)
//        reqFetch.predicate = predicate
//        let sort  = NSSortDescriptor(key: "title", ascending: true)
//        reqFetch.sortDescriptors = [sort]
//        loadItem(withRequest: reqFetch, predicate: predicate)
        
        itemArray = itemArray?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }
           
        }
    }
}
