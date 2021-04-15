//
//  JuegoViewController.swift
//  Holandes
//
//  Created by Sergio Ibarra Alcala on 11/04/21.
//

import UIKit

class GameViewController: UIViewController {
    
    var answerSent = false
    var currentWord: Word?
    
    var textLocked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.setNavigationBarHidden(false, animated: true)
        
        currentWord = AppEngine.engine.getNextWord()
        wordButton.setTitle(currentWord?.dutchWord, for: .normal)
        
        wordTextArea.becomeFirstResponder()
        wordTextArea.delegate = self
    }
    
    @IBAction func sendAnswer(_ sender: Any) {
        if(!answerSent) {
            if(AppEngine.engine.checkAnswer(forWord: currentWord!, answer: wordTextArea.text ?? "")) {
                rightAnswerImage.isHidden = false
            }
            else {
                wrongAnswerImage.isHidden = false
            }
            rightAnswerLabel.text = currentWord!.spanishWord
            
            sendAnswerButton.setTitle("Siguiente", for: .normal)
            answerSent = true
            
            lockControls()
        }
        else {
            resetControls()
            
            if let word = AppEngine.engine.getNextWord() {
                currentWord = word
                wordButton.setTitle(word.dutchWord, for: .normal)
            }
            else {
                performSegue(withIdentifier: K.Segues.ResultsSegue, sender: self)
            }
        }
    }
    
    func lockControls() {
        textLocked = true
    }
    
    func resetControls() {
        rightAnswerImage.isHidden = true
        wrongAnswerImage.isHidden = true
        
        answerSent = false;
        sendAnswerButton.setTitle("Enviar", for: .normal)
        rightAnswerLabel.text = " "
        
        textLocked = false
        wordTextArea.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if AppEngine.engine.gameOver {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let resultsViewController = segue.destination as! ResultsViewController
       resultsViewController.gameViewController = self
    }
    
    @IBOutlet weak var wordButton: UIButton!
    @IBOutlet weak var wordTextArea: UITextField!
    @IBOutlet weak var rightAnswerImage: UIImageView!
    @IBOutlet weak var wrongAnswerImage: UIImageView!
    @IBOutlet weak var rightAnswerLabel: UILabel!
    @IBOutlet weak var sendAnswerButton: UIButton!
}

extension GameViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return true
        }
        
        if(textLocked) {
            return false
        }
        
        if string.lowercased() == string {
            textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.lowercased())
        } else {
            textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.lowercased())
        }

        return false
    }
    
}
