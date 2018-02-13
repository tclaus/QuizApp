//
//  SettingsTableViewController.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 28.12.16.
//  Copyright © 2016 Claus-Software. All rights reserved.
//

import UIKit
import InAppSettingsKit

class SettingsTableViewController: IASKAppSettingsViewController, IASKSettingsDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Settings are changed, reload settings
     */
    func settingsViewControllerDidEnd(_ sender: IASKAppSettingsViewController!) {
        
        Config.sharedInstance().loadQuestions()
        
        // Reload questions ? 
        dismiss(animated: true, completion: nil)
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
