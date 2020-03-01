//
//  QuizInAppPurchaseData.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 29.02.20.
//  Copyright © 2020 Claus-Software. All rights reserved.
//

import UIKit

@objc
class QuizInAppPurchaseData: NSObject {
    
    @objc
    var numberOfFreeLevels: Int = 0
    @objc
    var inAppPurchaseID: String = ""
    @objc
    var messageTitle: String = ""
    @objc
    var messageText: String = ""
    @objc
    var messageBuy: String = ""
    @objc
    var messageCancel : String = ""
}
