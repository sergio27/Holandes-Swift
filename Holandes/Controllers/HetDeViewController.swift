//
//  HetDeViewController.swift
//  Holandes
//
//  Created by Sergio Ibarra Alcala on 11/04/21.
//

import UIKit

class HetDeViewController: UIViewController {

    let engine = AppEngine()
    var words = [] as [Word]
    
    var currentWord: Word?
    var currentIndex = 0
    var correctAnswers = 0
    
    var restart = false
    var gameOver = false
    
    var greenColor = UIColor(named: "AndroidGreen")
    var redColor = UIColor(named: "BaraRed")

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.setNavigationBarHidden(false, animated: true)
        
        hetAnswerButton.layer.borderColor = UIColor(named: "RadiantYellow")!.cgColor
        deAnswerButton.layer.borderColor = UIColor(named: "RadiantYellow")!.cgColor
        
        words = engine.words
        getNewWord()
    }
    
    func getNewWord() {
        currentWord = words[currentIndex]
        wordButton.setTitle(currentWord!.dutchWord, for: .normal)
        
        nextButton.isHidden = true
        
        hetAnswerButton.backgroundColor = UIColor.white
        hetAnswerButton.setTitleColor(UIColor.label, for: .normal)
        deAnswerButton.backgroundColor = UIColor.white
        deAnswerButton.setTitleColor(UIColor.label, for: .normal)
    }
    
    func checkAnswer(answer: String) {
        if(currentWord!.isHetWord && answer == "het") {
            hetAnswerButton.backgroundColor = greenColor
            hetAnswerButton.setTitleColor(UIColor.white, for: .normal)
            
            correctAnswers += 1
        }
        else if (!currentWord!.isHetWord && answer == "het") {
            hetAnswerButton.backgroundColor = redColor
            hetAnswerButton.setTitleColor(UIColor.white, for: .normal)
        }
        else if (!currentWord!.isHetWord && answer == "de") {
            deAnswerButton.backgroundColor = greenColor
            deAnswerButton.setTitleColor(UIColor.white, for: .normal)
            
            correctAnswers += 1
        }
        else if (currentWord!.isHetWord && answer == "de") {
            deAnswerButton.backgroundColor = redColor
            deAnswerButton.setTitleColor(UIColor.white, for: .normal)
        }
        
        nextButton.isHidden = false
    }
    
    @IBAction func sendAnswer(_ sender: Any) {
        let answerButton = sender as! UIButton
        checkAnswer(answer: answerButton.currentTitle!)
    }
    
    @IBAction func nextWord(_ sender: Any) {
        if (currentIndex + 1) == words.count {
            gameOver = true
            performSegue(withIdentifier: "resultsSegue", sender: self)
        }
        else {
            currentIndex += 1
            getNewWord()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if gameOver {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let resultsViewController = segue.destination as! ResultsViewController
       
        resultsViewController.resultsText = "Tuviste \(correctAnswers) de \(words.count) respuestas correctas."
       resultsViewController.gameViewController = self
   }
    
    @IBOutlet weak var wordButton: UIButton!
    @IBOutlet weak var hetAnswerButton: UIButton!
    @IBOutlet weak var deAnswerButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
}
