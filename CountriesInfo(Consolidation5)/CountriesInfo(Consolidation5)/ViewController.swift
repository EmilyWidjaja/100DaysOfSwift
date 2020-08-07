//
//  ViewController.swift
//  CountriesInfo(Consolidation5)
//
//  Created by Emily Widjaja on 20/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var countries =  [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //additional UI Features
        title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //use codable to load the countries
        if let url = Bundle.main.url(forResource: "countries_info", withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                performSelector(inBackground: #selector(parse), with: data)
                return
            }
            //or failed - show error
            print("Failed to load data")
        }
        
    }
        
        
    
    //MARK: - Data Loading methods
  /*  func loadData() {
        guard let url = Bundle.main.url(forResource: "countries_info", withExtension: "json") else {
            fatalError("Failed to find JSON file")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load JSON file")
        }
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([Country].self, from: data) {
            //countries = results.results
            for i in 0..<decoded.count {
                let country = decoded[i]
                countries.append(country)
            }
        } else {print("Failed to decode JSON file.")}
        
    } */
    
    @objc func parse(json: Data) {
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([Country].self, from: json) {
            for i in 0..<decoded.count {
                let country = decoded[i]
                countries.append(country)
            }
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        } else {
            print("Failed to parse data")
        }
    }
    
    
    //MARK: Table methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            let country = countries[indexPath.row]
            print(country)
            //vc.capitalLabel.text = country.capital
            vc.areaLabel.text = "\(country.area)"
            //vc.gdpLabel.text = String(country.GDPPerCapita)
            //vc.languagesLabel.text = country.officialLanguages

            print("Countries: \(countries[1].area)")
            navigationController?.pushViewController(vc, animated: true)
        }
    }


}

