//
//  RSQuestionViewController.swift
//  Pods
//
//  Created by James Kizer on 4/16/17.
//
//

import UIKit
import ResearchKit
import SnapKit

open class RSQuestionViewController: ORKStepViewController {
    
    static let footerHeightWithoutContinueButton: CGFloat = 61.0
    
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var textLabel: UILabel!
    @IBOutlet public weak var contentView: UIView!
    @IBOutlet public weak var continueButton: RSBorderedButton!
    @IBOutlet public weak var skipButton: RSLabelButton!
    @IBOutlet public weak var footerHeight: NSLayoutConstraint!
    @IBOutlet public weak var containerScrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet public weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet public weak var headerStackView: UIStackView!
    @IBOutlet public weak var footerView: UIView!
    
    
    var _appeared: Bool = false
    open var hasAppeared: Bool {
        return _appeared
    }
    
    open var skipped: Bool = false
    private var _initializedResult: ORKResult?
    public var initializedResult: ORKResult? {
        return _initializedResult
    }
    
    open class var showsContinueButton: Bool {
        return true
    }
    
    open var continueButtonEnabled: Bool = true {
        didSet {
            self.continueButton.isEnabled = continueButtonEnabled
        }
    }

    override convenience init(step: ORKStep?) {
        self.init(step: step, result: nil)
    }
    
    override convenience init(step: ORKStep?, result: ORKResult?) {
        
        let framework = Bundle(for: RSQuestionViewController.self)
        self.init(nibName: "RSQuestionViewController", bundle: framework)
        self.step = step
        self._initializedResult = result
        self.restorationIdentifier = step!.identifier
        
    }
    
    override open func viewDidLoad() {
        
        super.viewDidLoad()
        
        assert(self.step is RSStep)
        
        let step = self.step as! RSStep
        
        self.titleLabel.text = step.title
        self.textLabel.text = step.text
        
        if let attributedTitle = step.attributedTitle {
            self.titleLabel.attributedText = attributedTitle
        }
        
        if let attributedText = step.attributedText {
            self.textLabel.attributedText = attributedText
            // TODO make this customizable?
            //self.textLabel.textAlignment = .right // in original code
            //self.textLabel.backgroundColor = .systemTeal // for debugging
        }
        
        if step.attributedTitle == nil && step.title == nil &&
            step.attributedText == nil && step.text == nil {
            self.headerStackView.snp.makeConstraints { (make) in
                make.height.equalTo(0.0)
            }
        }
        
        if let buttonText = step.buttonText {
            self.setContinueButtonTitle(
                title: NSLocalizedString(buttonText, comment: "")
            )
        }
        else {
            let title = NSLocalizedString(
                self.hasNextStep() ? "Next" : "Done",
                comment: ""
            )
            self.continueButton.setTitle(title, for: .normal)
        }
        
        self.skipButton.isHidden = !step.isOptional
        
        if let skipButtonText = step.skipButtonText {
            self.setSkipButtonTitle(
                title: NSLocalizedString(skipButtonText, comment: "")
            )
        }
        else {
            self.setSkipButtonTitle(
                title: NSLocalizedString("Skip this question", comment: "")
            )
        }
        
        let hasBorder = step.skipButtonHasBorder
        self.skipButton.borderEnabled = hasBorder
        
        if !type(of: self).showsContinueButton {
            self.footerHeight.constant = RSQuestionViewController.footerHeightWithoutContinueButton
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //this is due to bug in RK 1.4.1. Parent result date not initialized properly
    //sub classes should check hasAppeared before accessing
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._appeared = true
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.contentView.setNeedsLayout()
    }
    
    @objc func adjustForKeyboard(notification: NSNotification) {
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            self.containerScrollView.contentInset = UIEdgeInsets.zero
            self.containerScrollView.setContentOffset(CGPoint.zero, animated: true)
        } else {
            let userInfo = notification.userInfo!
            let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardViewEndFrame = self.view.convert(keyboardScreenEndFrame, from: self.view.window)
            self.containerScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
            
            if let firstResponder = self.findFirstReponder(view: self.view) {
                //convert rect of first responder to within scorll view
                let rect = self.containerView.convert(firstResponder.bounds, from: firstResponder)
                self.containerScrollView.scrollRectToVisible(rect, animated: true)
            }
        }

        self.containerScrollView.scrollIndicatorInsets = self.containerScrollView.contentInset
        
        
        
    }
    
    func findFirstReponder(view: UIView) -> UIView? {
        if view.isFirstResponder {
            return view
        } else {
            for subView in view.subviews {
                if let firstResponder = findFirstReponder(view: subView) {
                    return firstResponder
                }
            }
        }
        return nil
    }
    
    open func setSkipButtonTitle(title: String) {
        self.skipButton.setTitle(title, for: .normal)
    }
    
    open func setContinueButtonTitle(title: String) {
        self.continueButton.setTitle(title, for: .normal)
    }
    
    open func notifyDelegateAndMoveForward() {
        if let delegate = self.delegate {
            delegate.stepViewControllerResultDidChange(self)
        }
        self.goForward()
    }
    
    open func validate() -> Bool {
        return true
    }
    
    open func clearAnswer() {
        self.skipped = true
    }
    
    @IBAction open func continueTapped(_ sender: Any) {
        if self.validate() {
            self.notifyDelegateAndMoveForward()
        }
    }
    
    @IBAction open func skipTapped(_ sender: Any) {
        self.clearAnswer()
        self.notifyDelegateAndMoveForward()
    }
}
