//
//  RSFullScreenImageStepViewController.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 2/6/19.
//

import UIKit
import ResearchKit

open class RSFullScreenImageStepViewController: ORKStepViewController {
    
    override convenience init(step: ORKStep?) {
        self.init(step: step, result: nil)
    }
    
    override convenience init(step: ORKStep?, result: ORKResult?) {
        
        let framework = Bundle(for: RSFullScreenImageStepViewController.self)
        self.init(nibName: "RSFullScreenImageStepViewController", bundle: framework)
        self.step = step
        self.restorationIdentifier = step!.identifier
        
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: RSLabelButton!
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        guard let imageStep = self.step as? RSFullScreenImageStep else {
            return
        }
        
        self.imageView.image = imageStep.image
        let tapHandler = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        self.view.addGestureRecognizer(tapHandler)
        
        if let buttonText = imageStep.buttonText {
            self.button.setTitle(buttonText, for: .normal)
        }
        
    }
    
    @objc public func viewTapped(_ gestureRecognizer: UIGestureRecognizer) {
        self.goForward()
    }

    @IBAction func buttonTapped(_ sender: Any) {
        self.goForward()
    }
    
}
