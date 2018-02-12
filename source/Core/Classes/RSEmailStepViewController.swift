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

    func composeMail(emailStep: RSEmailStep) {
        
        let mailClass: AnyClass? = NSClassFromString("MFMailComposeViewController")
        if mailClass != nil && MFMailComposeViewController.canSendMail() {
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
        else {
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Email failed", message: emailStep.errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                
                // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    print("OK")
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    override open func continueTapped(_ sender: Any) {
        
        if self.emailSent {
            self.notifyDelegateAndMoveForward()
        }
        else if let emailStep = self.step as? RSEmailStep {
            //load email
            
            self.composeMail(emailStep: emailStep)
            
        }
        
    }
    
    open func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result != .cancelled || result != .failed {
            self.emailSent = true
            self.notifyDelegateAndMoveForward()
        }
    }
}
