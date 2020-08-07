//
//  ViewController.swift
//  ShoppingList - Consolidation2
//
//  Created by Emily Widjaja on 9/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var groceryList = [String]()
    var item: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Grocery List"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(clearTable))
        //clear the table if there's anything there
        clearTable()
    
    }
    
    @objc func clearTable() {
        groceryList = []
        tableView.reloadData()
    }
    
    //asks for new item
    @objc func addNewItem() {
        let ac = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        ac.addTextField()
        
        //Need to review this line of code
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    //adds new Item
    func submit(_ answer: String) {
        groceryList.insert(answer.lowercased(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        return
        
    }
    
    //loads what's in the cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = groceryList[indexPath.row]
        return cell
    }

}

