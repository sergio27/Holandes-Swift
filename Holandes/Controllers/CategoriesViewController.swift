//
//  CategoriesViewController.swift
//  Holandes
//
//  Created by Sergio Ibarra Alcala on 13/04/21.
//

import UIKit

class CategoriesViewController: UITableViewController {

    var categories: [String: [Word]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        
        categories = AppEngine.engine.categories
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.ReusableCells.ReusableCell, for: indexPath)

        let category = Array(categories.keys.sorted())[indexPath.row]
        cell.textLabel?.text = category
        
        if(AppEngine.engine.selectedOption == "Juego") {
            if let score = AppEngine.engine.gameScores[category] {
                cell.detailTextLabel?.text = "\(score)%"
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCategory = Array(categories.keys.sorted())[indexPath.row]
        
        AppEngine.engine.loadNewGame(withCategory: selectedCategory)
        
        if(AppEngine.engine.selectedOption == "Vocabulario") {
            performSegue(withIdentifier: K.Segues.FlashcardsSegue, sender: self)
        }
        else if(AppEngine.engine.selectedOption == "Juego") {
            performSegue(withIdentifier: K.Segues.GameSegue, sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
}
