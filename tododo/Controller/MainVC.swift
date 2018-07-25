//
//  MainVC.swift
//  tododo
//
//  Created by Kings on 7/24/18.
//  Copyright © 2018 Kings. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UITableViewController {
    
    @IBOutlet var dodoTable: UITableView!
    
//    let defaults = UserDefaults.standard
    
//    let defaultManager = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first?.appendingPathComponent("Items.plist")
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var itemArray = [Items]()
    
    var textF = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        dodoTable.tableFooterView = UIView(frame: CGRect.zero)
        loadItem()
//        let newItem = Item(title: "Work", done: true)
//        itemArray.append(newItem)
//         let newItem1 = Item(title: "Cook", done: false)
//        itemArray.append(newItem1)
//         let newItem2 = Item(title: "Sleep", done: true)
//        itemArray.append(newItem2)
        print(FileManager.default.urls(for: .documentDirectory, in: .systemDomainMask))
//        guard let iArray = defaults.array(forKey: "itemArray") as? [Item] else {return}
//        self.itemArray = iArray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        loadItem()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? itemCell else {return UITableViewCell()}
        let item = itemArray[indexPath.row]
        cell.updateCell(item: item)
    
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        
        item.done = !item.done
        
//        let manageContext = appDelegate?.persistentContainer.viewContext
//        manageContext?.delete(item)
//        itemArray.remove(at: indexPath.row)
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (_) in
            guard let manageContext = self.appDelegate?.persistentContainer.viewContext else {return}
            let newItem = Items(context: manageContext)
            newItem.title = self.textF.text
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        alert.addTextField { (alertTF) in
            self.textF = alertTF
            alertTF.placeholder = "Create new item"
           
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems()
    {
        
//        let encoder = PropertyListEncoder()
        do{
            guard let manageContext = self.appDelegate?.persistentContainer.viewContext else {return}
            try manageContext.save()
//            let data = try encoder.encode(itemArray)
//            try data.write(to: defaultManager!)
        }catch{
            debugPrint("\(error.localizedDescription)")
        }
        self.dodoTable.reloadData()

        
    }

    func loadItem(withRequest: NSFetchRequest<Items> = Items.fetchRequest())
    {
        guard let manageContext = self.appDelegate?.persistentContainer.viewContext else {return}
//        let withRequest = NSFetchRequest<Items>(entityName: "Items")
        do{
            itemArray = try manageContext.fetch(withRequest)
            //            if let data = try? Data(contentsOf: defaultManager!) {
            //                let decoder = PropertyListDecoder()
            //                itemArray = try decoder.decode([Item].self, from: data)
        }catch{
            debugPrint("error here \(error)")
        }
        dodoTable.reloadData()
    }
    
    
}

extension MainVC: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let reqFetch = NSFetchRequest<Items>(entityName: "Items")
        let predicate  = NSPredicate(format: "title CONTAINS [cd] %@", searchBar.text!)
        reqFetch.predicate = predicate
        let sort  = NSSortDescriptor(key: "title", ascending: true)
        reqFetch.sortDescriptors = [sort]
        
        loadItem(withRequest: reqFetch)
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
