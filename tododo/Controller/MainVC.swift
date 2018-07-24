//
//  MainVC.swift
//  tododo
//
//  Created by Kings on 7/24/18.
//  Copyright © 2018 Kings. All rights reserved.
//

import UIKit

class MainVC: UITableViewController {
    
    @IBOutlet var dodoTable: UITableView!
    
    let defaults = UserDefaults.standard
    
    var itemArray = ["Work", "School","travel"]

    override func viewDidLoad() {
        super.viewDidLoad()
        dodoTable.tableFooterView = UIView(frame: CGRect.zero)
        
        guard let iArray = defaults.array(forKey: "itemArray") as? [String] else {return}
        self.itemArray = iArray
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
        cell.updateCell(name: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        print(item)
        
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == .checkmark{
          cell?.accessoryType = .none
        }else{
            cell?.accessoryType = .checkmark
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textF = UITextField()
        let alert = UIAlertController(title: "Add new todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (_) in
            self.itemArray.append(textF.text!)
            self.defaults.setValue(self.itemArray, forKey: "itemArray")
            self.dodoTable.reloadData()
        }
        
        alert.addTextField { (alertTF) in
            textF = alertTF
            alertTF.placeholder = "Create new item"
           
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
