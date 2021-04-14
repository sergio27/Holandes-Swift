//
//  JuegoViewController.swift
//  Holandes
//
//  Created by Sergio Ibarra Alcala on 11/04/21.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var wordButton: UIButton!
    @IBOutlet weak var wordTextArea: UITextField!
    @IBOutlet weak var rightAnswerImage: UIImageView!
    @IBOutlet weak var wrongAnswerImage: UIImageView!
    @IBOutlet weak var rightAnswerLabel: UILabel!
    @IBOutlet weak var sendAnswerButton: UIButton!
    
    var words = [] as [Word]
    var category = ""
    
    var currentWord: Word?
    var currentIndex = -1
    var correctAnswers = 0
    
    var answerSent = false
    
    var restart = false
    var gameOver = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.setNavigationBarHidden(false, animated: true)
        
        category = AppEngine.engine.selectedCategory
        words = AppEngine.engine.getWords(withCategory: category)
        
        words.shuffle()
        
        getNewWord()
    }
    
    @IBAction func sendAnswer(_ sender: Any) {
        if(!answerSent) {
            checkAnswer()
            
            sendAnswerButton.setTitle("Siguiente", for: .normal)
            answerSent = true
        }
        else {
            if (currentIndex + 1) == words.count {
                gameOver = true
                performSegue(withIdentifier: "resultsSegue", sender: self)
                
                let score = Double(correctAnswers) / Double(words.count) * 100
                AppEngine.engine.saveScore(category: category, score: Int(score))
            }
            else {
                getNewWord()
            }
        }
    }
    
    func getNewWord() {
        currentIndex += 1
        
        rightAnswerImage.isHidden = true
        wrongAnswerImage.isHidden = true
        
        answerSent = false;
        sendAnswerButton.setTitle("Enviar", for: .normal)
        rightAnswerLabel.text = " "
        
        currentWord = words[currentIndex]
        wordTextArea.text = ""
        wordButton.setTitle(currentWord!.dutchWord, for: .normal)
    }
    
    func checkAnswer() {
        if(wordTextArea.text == currentWord?.spanishWord) {
            rightAnswerImage.isHidden = false
            correctAnswers += 1
        }
        else {
            wrongAnswerImage.isHidden = false
        }
        rightAnswerLabel.text = currentWord?.spanishWord
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
}
