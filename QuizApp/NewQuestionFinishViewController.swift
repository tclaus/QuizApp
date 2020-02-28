//
//  NewQuestionFinishViewController.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 15.11.16.
//  Copyright © 2016 Claus-Software. All rights reserved.
//

import UIKit

class NewQuestionFinishViewController: KeyboardViewController, UIPickerViewDataSource, UIPickerViewDelegate  {
    
    
    var questionManager : NewQuestionManager?
    lazy var categories : [String]  =  Utils.categories()
    
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var explanationLink: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var levelSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ADVTheme.addGradientBackground(view)
        // view.tintColor = UIColor.white
        navigationItem.hidesBackButton = true
        setDelegates(explanationLink)
        sendButton.tintColor = UIColor.white
        cancelButton.tintColor = UIColor.white
        explanationLink.tintColor = UIColor.white
        levelSlider.tintColor = UIColor.white
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func linkButton(_ sender: Any) {
        
        // open Link to Wiki, if filed is empty
        // https://de.wikipedia.org/wiki/Wikipedia:Hauptseite
        
        let wikiLink = "https://de.wikipedia.org/wiki/Wikipedia:Hauptseite"
        
        var URLToOpen: URL?
        
        if let text = explanationLink.text {
            if text.count > 3 {
                URLToOpen = URL(string: text)!
            }
        }
        
        guard let _ = URLToOpen else {
            URLToOpen = URL(string: wikiLink)
            UIApplication.shared.open(URLToOpen!, options: [:] , completionHandler: nil)
            return
        }
        
        UIApplication.shared.open(URLToOpen!, options: [:] , completionHandler: nil)
        
    }
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func explanationLinkChanged(_ sender: Any) {
        questionManager?.explanation = explanationLink.text!
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
    
    
    @IBAction func levelValueChanged(_ sender: Any) {
        let levelValue : Int = Int(levelSlider.value)
        levelLabel.text =  "Level: \(levelValue)"
    }
    
    @IBAction func sendButton(_ sender: Any) {
        
        sendButton.isEnabled = false
        
        questionManager?.explanation = explanationLink.text!
        questionManager?.level = Int(levelSlider.value)
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
