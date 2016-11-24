//
//  NewQuestionWrongAnswersViewController.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 15.11.16.
//  Copyright © 2016 Claus-Software. All rights reserved.
//

import UIKit


class NewQuestionWrongAnswersViewController: KeyboardViewController {

    var questionManager : NewQuestionManager?
    
    @IBOutlet weak var firstWrongAnswer: UITextField!
    @IBOutlet weak var secondWrongAnswer: UITextField!
    @IBOutlet weak var thirdWrongAnswer: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ADVTheme.addGradientBackground(view)
        // view.tintColor = UIColor.white
        navigationItem.hidesBackButton = true
        
        setDelegates(firstWrongAnswer,secondWrongAnswer,thirdWrongAnswer)
        
        nextButton.tintColor = UIColor.white
        cancelButton.tintColor = UIColor.white
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func answer1changed(_ sender: Any) {
        isValidTextField()
    }
    
    @IBAction func answer2changed(_ sender: Any) {
        isValidTextField()
    }
    
    @IBAction func answer3changed(_ sender: Any) {
        isValidTextField()
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController!.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func firstAnswerNextButton(_ sender: Any) {
        secondWrongAnswer.becomeFirstResponder()
    }
    @IBAction func senconAnswerNextButton(_ sender: Any) {
        thirdWrongAnswer.becomeFirstResponder()
    }
    
    @IBAction func thirstAnswerNextButton(_ sender: Any) {
        nextButton.sendActions(for: .allTouchEvents)

    }
    /**
     Checks if at leaset 3 charcters are entered
     */
    func isValidTextField() {
        if let answer1Count = firstWrongAnswer.text?.characters.count,
            let answer2Count = secondWrongAnswer.text?.characters.count,
            let answer3Count = thirdWrongAnswer.text?.characters.count {
            
            if answer1Count >= 1 && answer2Count >= 1 && answer3Count >= 1 {
                nextButton.isEnabled = true
                return
            }
            
        }
        nextButton.isEnabled = false
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.destination is NewQuestionFinishViewController {
            
            questionManager?.wrongAnswer1 = firstWrongAnswer.text
            questionManager?.wrongAnswer2 = secondWrongAnswer.text
            questionManager?.wrongAnswer3 = thirdWrongAnswer.text
            
            (segue.destination as! NewQuestionFinishViewController).questionManager = questionManager
        }
        
    }
    

}
