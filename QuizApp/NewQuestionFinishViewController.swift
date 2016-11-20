//
//  NewQuestionFinishViewController.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 15.11.16.
//  Copyright © 2016 Claus-Software. All rights reserved.
//

import UIKit

class NewQuestionFinishViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {
   
    
    var questionManager : NewQuestionManager?
    lazy var categories : [String]  =  Utils.categories()
    
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var explanationLink: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ADVTheme.addGradientBackground(view)
        view.tintColor = UIColor.white
        navigationItem.hidesBackButton = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func explanationLinkChanged(_ sender: Any) {
        questionManager?.explanation = explanationLink.text
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return categories[row]
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        navigationController!.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func explanationLinkNextButton(_ sender: Any) {
        explanationLink.resignFirstResponder()
    }
    
    @IBAction func sendButton(_ sender: Any) {
    
        sendButton.isEnabled = false
        
        questionManager?.explanation = explanationLink.text
        questionManager?.category = categories[categoryPickerView.selectedRow(inComponent: 0)]
        // Start HUD
        questionManager?.send(completionHandler: { error in
            //
            // End Hud
            DispatchQueue.main.async {
                self.navigationController!.popToRootViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
            
            
        })
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
