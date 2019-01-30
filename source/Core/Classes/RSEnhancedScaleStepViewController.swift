//
//  RSEnhancedScaleStepViewController.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 3/26/18.
//

import UIKit
import ResearchKit

open class RSEnhancedScaleStepViewController: RSQuestionViewController {
    
    var value: Int?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        guard let scaleStep = self.step as? RSEnhancedScaleStep,
            let answerFormat = scaleStep.answerFormat as? RSEnhancedScaleAnswerFormat,
            let sliderView = RSSliderView.newView(minimumValue: answerFormat.minimum, maximumValue: answerFormat.maximum) else {
            return
        }
        
        sliderView.minValueLabel.text = answerFormat.minValueLabel
        sliderView.maxValueLabel.text = answerFormat.maxValueLabel
        sliderView.minValueDescriptionLabel.text = answerFormat.minimumValueDescription
        sliderView.neutralValueDescriptionLabel.text = answerFormat.neutralValueDescription
        sliderView.maxValueDescriptionLabel.text = answerFormat.maximumValueDescription
        
        sliderView.textLabel.text = nil
        
        sliderView.onValueChanged = { [unowned self] value, touched in
            
            self.value = value
            if value >= answerFormat.minimum && value <= answerFormat.maximum {
                self.continueButtonEnabled = true
                sliderView.currentValueLabel.text = "\(value)"
            }
            else {
                self.continueButtonEnabled = false
            }
        
            sliderView.setNeedsLayout()
            self.contentView.setNeedsLayout()
      
            if touched && scaleStep.autoAdvance {
                RSEnhancedScaleStepViewController.delay(0.25) {
                    self.goForward()
                }
            }
            
        }
        
        if let initializedResult = self.initializedResult as? ORKStepResult,
            let result = initializedResult.firstResult as? ORKNumericQuestionResult,
            let numericAnswer = result.numericAnswer {
            sliderView.setValue(value: numericAnswer.intValue, animated: false)
        }
        else {
            sliderView.setValue(value: answerFormat.defaultValue, animated: false)
        }

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.frame = self.contentView.bounds
        self.contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(sliderView)
        stackView.addArrangedSubview(UIView())
    }
    
    static func delay(_ delay:TimeInterval, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    override open func validate() -> Bool {
        guard let value = self.value,
            let scaleStep = self.step as? RSEnhancedScaleStep,
            let answerFormat = scaleStep.answerFormat as? RSEnhancedScaleAnswerFormat else {
                return false
        }
        return value >= answerFormat.minimum && value <= answerFormat.maximum
    }
    
    
    //ORKNumericQuestionResult
    override open var result: ORKStepResult? {
        guard let parentResult = super.result else {
            return nil
        }

        if self.hasAppeared,
            let value = self.value,
            let scaleStep = self.step as? RSEnhancedScaleStep,
            let answerFormat = scaleStep.answerFormat as? RSEnhancedScaleAnswerFormat,
            value >= answerFormat.minimum && value <= answerFormat.maximum {
            
            let numericResult = ORKNumericQuestionResult(identifier: scaleStep.identifier)
            numericResult.numericAnswer = NSNumber(value: value)

            parentResult.results = [numericResult]
        }
        
        return parentResult
    }

}
