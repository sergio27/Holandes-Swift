//
//  VocabularioViewController.swift
//  Holandes
//
//  Created by Sergio Ibarra Alcala on 11/04/21.
//

import UIKit

class FlashcardsViewController: UIViewController {
    
    var words = [] as [Word]
    
    var category = ""
    
    var currentWord: Word?
    var cardFlipped = true
    
    var currentIndex = -1
    var correctAnswers = 0
    
    var restart = false
    var gameOver = false
    
    var totalWords = 0
    var round = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.setNavigationBarHidden(false, animated: true)
        
        correctButton.layer.borderColor = K.Colors.Orange!.cgColor
        wrongButton.layer.borderColor = K.Colors.Orange!.cgColor
        
        category = AppEngine.engine.selectedCategory
        words = AppEngine.engine.getWords(withCategory: category)
        
        words.shuffle()
        totalWords = words.count
        
        getNewWord()
    }
    
    @IBAction func cardTouched(_ sender: Any) {
        flipCard()
    }
    
    func flipCard() {
        if(cardFlipped) {
            cardButton.setTitle(currentWord!.spanishWord, for: .normal)
            cardFlipped = false;
            
            correctButton.isHidden = false
            wrongButton.isHidden = false
        }
        else {
            cardFlipped = true;
            
            getNewWord()
        }
        
        UIView.transition(with: cardButton, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
    @IBAction func correctWord(_ sender: Any) {
        if round == 1 {
            correctAnswers += 1
        }
        
        removeCurrentWord()
        
        if words.count > 0 {
            flipCard()
        }
    }
    
    @IBAction func wrongWord(_ sender: Any) {
        flipCard()
    }
    
    func getNewWord() {
        if (currentIndex + 1) == words.count {
            round += 1
            words.shuffle()
            currentIndex = -1
        }
        
        currentIndex += 1
        
        correctButton.isHidden = true
        wrongButton.isHidden = true
        
        currentWord = words[currentIndex]
        cardButton.setTitle(currentWord!.dutchWord, for: .normal)
    }
    
    func removeCurrentWord() {
        words.remove(at: currentIndex)
        currentIndex -= 1
        
        if words.count == 0 {
            gameOver = true
            performSegue(withIdentifier: K.Segues.ResultsSegue, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultsViewController = segue.destination as! ResultsViewController
        
        AppEngine.engine.results = "Tuviste \(correctAnswers) de \(totalWords) respuestas correctas."
        resultsViewController.gameViewController = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if gameOver {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var correctButton: UIButton!
    @IBOutlet weak var wrongButton: UIButton!
    
}
