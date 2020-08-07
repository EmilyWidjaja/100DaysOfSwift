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
        
        
        let urlString: String
            
        //loads differently for each tab.
        if navigationController?.tabBarItem.tag == 0 {
           urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"  //cache copy
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json" //cache copy of most popular
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                //will freeze until all the data has been downloaded
                print(data)
                parse(json: data)
                return
            }
        }
        showError()
    }
    
    @objc func searchPetitions() {
        let ac = UIAlertController(title: "Search Petitions", message: "Filter petitions matching your keyword", preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        myPetitions = []
        let answer = answer.lowercased()
        for petition in petitions {
            let petitionTitle = petition.title.lowercased()
            let petitionBody = petition.body.lowercased()
            if petitionTitle.contains(answer) || petitionBody.contains(answer) {
                myPetitions.append(petition)
            }
        }
        tableView.reloadData()
    }
    
    @objc func dataOrigin() {
        let ac = UIAlertController(title: "Information", message: "This data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    
    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            myPetitions = petitions
            tableView.reloadData()
        }
    }

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

