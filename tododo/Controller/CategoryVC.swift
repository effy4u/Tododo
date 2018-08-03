//
//  CategoryVC.swift
//  tododo
//
//  Created by Kings on 7/26/18.
//  Copyright © 2018 Kings. All rights reserved.
//

import UIKit
import CoreData

class CategoryVC: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var cateArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        loadCategory()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cateArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryCell else {return UITableViewCell()}
        let cat = cateArray[indexPath.row]
        cell.configureCell(cate: cat)
        return cell
    }
    
    // Mark: - Table view delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "itemDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        var categoryText = UITextField()
        let alert  = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (_) in
            let category = Category(context: self.context)
            category.name = categoryText.text
            self.cateArray.append(category)
            self.saveCategory()
        }
        alert.addTextField { (textF) in
            categoryText = textF
            categoryText.placeholder = "Enter category name"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategory()
    {
        do{
            try context.save()
        }catch{
            debugPrint("error here \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    func loadCategory()
    {
        let fetchReq: NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            cateArray = try context.fetch(fetchReq)
        }catch{
            debugPrint("error fetch \(error.localizedDescription)")
        }
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemDetails" {
            let destination = segue.destination as! MainVC
            if let index = tableView.indexPathForSelectedRow {
                destination.selectedCategory = cateArray[index.row]
            }
            
        }
    }
}
