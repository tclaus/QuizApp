//
//  NewQuestionFirstControllerViewController.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 15.11.16.
//  Copyright © 2016 Claus-Software. All rights reserved.
//

import UIKit

class NewQuestionFirstControllerViewController: UIViewController {

    @IBOutlet weak var nextButon: UIButton!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var correctAnswerTextField: UITextField!
    
    let questionManager = NewQuestionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ADVTheme.addGradientBackground(view)
        view.tintColor = UIColor.white
        navigationItem.hidesBackButton = true
    
        questionTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        isValidTextField()
    }
    
    @IBAction func questionEndEditing(_ sender: Any) {
        correctAnswerTextField.becomeFirstResponder()
    }
    
    @IBAction func correctAnswerEndEditing(_ sender: Any) {
        if nextButon.isEnabled {
            // Then next screen witgh segue
            nextButon.sendActions(for: .allTouchEvents)
        }
    }
    

    /**
     Checks if at leaset 3 charcters are entered
     */
    func isValidTextField() {
        if let answerCount = correctAnswerTextField.text?.characters.count,
            let questionCount = questionTextField.text?.characters.count {
            
            if answerCount >= 3 && questionCount >= 3 {
                nextButon.isEnabled = true
                return
            }
            
        }
        nextButon.isEnabled = false
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        navigationController!.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.destination is NewQuestionWrongAnswersViewController {
            questionManager.text = questionTextField.text
            questionManager.correctAnswer = correctAnswerTextField.text
            (segue.destination as! NewQuestionWrongAnswersViewController).questionManager = questionManager
            
        }
        
    }
    

}






