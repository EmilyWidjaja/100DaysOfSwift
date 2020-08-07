//
//  ViewController.swift
//  Project7
//
//  Created by Emily Widjaja on 9/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var myPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(dataOrigin))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPetitions))
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)//automatically runs in background
    }
    
    @objc func fetchJSON() {
        let urlString: String
        
        //loads differently for each tab.
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"  //cache copy
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json" //cache copy of most popular
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)    //runs showError on main thread.
    }
    
    var answer: String?  //declare global parameter for use to parse in background
    
    @objc func searchPetitions() {
        let ac = UIAlertController(title: "Search Petitions", message: "Filter petitions matching your keyword", preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            if ac?.textFields?[0].text != nil {
                self?.answer = ac?.textFields?[0].text
                self?.performSelector(inBackground: #selector(self?.submit), with: nil)
            } else {return}
        }
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    @objc func submit() {
        myPetitions = []
        let keyword = answer?.lowercased()
        for petition in petitions {
            let petitionTitle = petition.title.lowercased()
            let petitionBody = petition.body.lowercased()
            if petitionTitle.contains(keyword!) || petitionBody.contains(keyword!) {
                myPetitions.append(petition)
            }
        }
        tableView.performSelector(onMainThread: #selector(tableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    @objc func dataOrigin() {
        let ac = UIAlertController(title: "Information", message: "This data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    //called from the userinitiated thread, reload tableView would have been done in the userinitiated thread and not the main thread even though it's UI, so push it back using dispatch Q
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            myPetitions = petitions
            
            tableView.performSelector(onMainThread: #selector(tableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    //MARK: - sets up table view

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = myPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = myPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true) //to bring vc onto screen
    }
}

