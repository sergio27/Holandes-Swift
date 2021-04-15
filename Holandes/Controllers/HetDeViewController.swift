//
//  HetDeViewController.swift
//  Holandes
//
//  Created by Sergio Ibarra Alcala on 11/04/21.
//

import UIKit

class HetDeViewController: UIViewController {

    var words = [] as [Word]
    
    var currentWord: Word?
    var currentIndex = 0
    var correctAnswers = 0
    
    var restart = false
    var gameOver = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.setNavigationBarHidden(false, animated: true)
        
        hetAnswerButton.layer.borderColor = K.Colors.Orange!.cgColor
        deAnswerButton.layer.borderColor = K.Colors.Orange!.cgColor
        
        words = AppEngine.engine.getWords(withOption: "noun")
        words.shuffle()
        
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
        if(currentWord!.article == "het" && answer == "het") {
            hetAnswerButton.backgroundColor = K.Colors.Green
            hetAnswerButton.setTitleColor(UIColor.white, for: .normal)
            
            correctAnswers += 1
        }
        else if (currentWord!.article == "de" && answer == "het") {
            hetAnswerButton.backgroundColor = K.Colors.Red
            hetAnswerButton.setTitleColor(UIColor.white, for: .normal)
        }
        else if (currentWord!.article == "de" && answer == "de") {
            deAnswerButton.backgroundColor = K.Colors.Green
            deAnswerButton.setTitleColor(UIColor.white, for: .normal)
            
            correctAnswers += 1
        }
        else if (currentWord!.article == "het" && answer == "de") {
            deAnswerButton.backgroundColor = K.Colors.Red
            deAnswerButton.setTitleColor(UIColor.white, for: .normal)
        }
        
        nextButton.isHidden = false
    }
    
    @IBAction func sendAnswer(_ sender: Any) {
        let answerButton = sender as! UIButton
        checkAnswer(answer: answerButton.currentTitle!)
        
        lockControls()
    }
    
    @IBAction func nextWord(_ sender: Any) {
        if (currentIndex + 1) == words.count {
            gameOver = true
            performSegue(withIdentifier: K.Segues.ResultsSegue, sender: self)
        }
        else {
            currentIndex += 1
            getNewWord()
            
            resetControls()
        }
    }
    
    func lockControls () {
        hetAnswerButton.isEnabled = false
        deAnswerButton.isEnabled = false
    }
    
    func resetControls() {
        hetAnswerButton.isEnabled = true
        deAnswerButton.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if gameOver {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultsViewController = segue.destination as! ResultsViewController
        resultsViewController.gameViewController = self
        
        AppEngine.engine.results = "Tuviste \(correctAnswers) de \(words.count) respuestas correctas."
   }
    
    @IBOutlet weak var wordButton: UIButton!
    @IBOutlet weak var hetAnswerButton: UIButton!
    @IBOutlet weak var deAnswerButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
}
