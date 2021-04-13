//
//  ResultsViewController.swift
//  Holandes
//
//  Created by Sergio Ibarra Alcala on 12/04/21.
//

import UIKit

class ResultsViewController: UIViewController {

    var resultsText = ""
    var gameViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resultsTextLabel.text = resultsText
    }
    
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
 
    
    @IBAction func restart(_ sender: Any) {        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finish(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var resultsTextLabel: UILabel!
}
