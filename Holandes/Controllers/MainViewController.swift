//
//  ViewController.swift
//  Holandes
//
//  Created by Sergio Ibarra Alcala on 11/04/21.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppEngine.engine.downloadWords()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let safeSender = sender {
            let selectedButton = safeSender as! UIButton
            AppEngine.engine.selectedOption = selectedButton.currentTitle ?? ""
        }
            
   }
}
