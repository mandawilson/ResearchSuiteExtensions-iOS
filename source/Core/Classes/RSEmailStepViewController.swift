//
//  RSEmailStepViewController.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 2/7/18.
//

import UIKit
import MessageUI

open class RSEmailStepViewController: RSQuestionViewController, MFMailComposeViewControllerDelegate {

    open var emailSent: Bool = false
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        guard let emailStep = self.step as? RSEmailStep else {
            return
        }
        
        self.setContinueButtonTitle(title: emailStep.buttonText)
        self.emailSent = false
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let emailStep = self.step as? RSEmailStep {
            //load email
            
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients(emailStep.recipientAddreses)
            if let subject = emailStep.messageSubject {
                composeVC.setSubject(subject)
            }
            
            if let body = emailStep.messageBody {
                composeVC.setMessageBody(body, isHTML: emailStep.bodyIsHTML)
            }
            else {
                composeVC.setMessageBody("", isHTML: false)
            }
            
            // Present the view controller modally.
//            self.present(composeVC, animated: true, completion: nil)
            self.present(composeVC, animated: true, completion: {
                
                print("showd VC")
                
            })
            
        }
    }
    
    
    
    override open func continueTapped(_ sender: Any) {
        
        if self.emailSent {
            self.notifyDelegateAndMoveForward()
        }
        else if let emailStep = self.step as? RSEmailStep {
            //load email
            
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients(emailStep.recipientAddreses)
            if let subject = emailStep.messageSubject {
                composeVC.setSubject(subject)
            }
            
            if let body = emailStep.messageBody {
                composeVC.setMessageBody(body, isHTML: emailStep.bodyIsHTML)
            }
            else {
                composeVC.setMessageBody("", isHTML: false)
            }
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
            
        }
        
    }
    
    open func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result != .cancelled || result != .failed {
            self.emailSent = true
            self.notifyDelegateAndMoveForward()
        }
    }
}
