//
//  RSEnhancedMultipleChoiceCellWithAccessory.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 4/24/18.
//

import UIKit
import ResearchKit

public protocol RSEnhancedMultipleChoiceCellWithAccessoryDelegate: class {
    func setSelected(selected: Bool, forCellId id: Int)
    func viewForAuxiliaryItem(item: ORKFormItem) -> UIView?
}

open class RSEnhancedMultipleChoiceCellWithAccessory: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    @IBOutlet weak var choiceContainer: UIView!
    @IBOutlet weak var auxContainer: UIView!
    @IBOutlet weak var auxStackView: UIStackView!
    
    var identifier: Int!
    
    var auxHeight: NSLayoutConstraint?
    var titleHeight: NSLayoutConstraint?
    var choiceContainerHeight: NSLayoutConstraint?
    var auxFormItem: ORKFormItem?
    
    weak var delegate: RSEnhancedMultipleChoiceCellWithAccessoryDelegate?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.clearForReuse()
    }
    
    override open func prepareForReuse() {
        self.clearForReuse()
        super.prepareForReuse()
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if let identifier = self.identifier {
            self.delegate?.setSelected(selected: selected, forCellId: identifier)
        }
        
        // Configure the view for the selected state
        self.updateUI(selected: selected, animated: animated, updateResponder: true)
    }
    
    open func setAuxView(view: UIView) {
        
    }
    
    open func clearForReuse() {
        
        if let auxContainerHeight = self.auxHeight {
            self.auxContainer.removeConstraint(auxContainerHeight)
        }
        
        self.identifier = nil
//        self.delegate = nil
        self.titleHeight = nil
        self.choiceContainerHeight = nil
        self.auxFormItem = nil
        //        self.auxFormAnswer = nil
        self.auxHeight = nil
        
        let auxContainerHeight = NSLayoutConstraint(item: self.auxContainer, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
        auxContainerHeight.priority = UILayoutPriority(rawValue: 801)
        self.auxHeight = auxContainerHeight
        self.auxContainer.addConstraint(auxContainerHeight)
        
        self.auxStackView.arrangedSubviews.forEach { (view) in
            self.auxStackView.removeArrangedSubview(view)
        }
    }
    
    open func configure(forTextChoice textChoice: RSTextChoiceWithAuxiliaryAnswer, withId: Int, delegate: RSEnhancedMultipleChoiceCellWithAccessoryDelegate?, result: ORKResult?) {
        
        self.clearForReuse()
        
        self.identifier = withId
        self.separatorInset = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.titleLabel?.text = textChoice.text
        //        self.detailTextLabel?.text = textChoice.detailText
        self.selectionStyle = .none
        
        self.checkImageView.image = UIImage(named: "checkmark", in: Bundle(for: ORKStep.self), compatibleWith: nil)
        
//        self.auxTextField.text = initialText
        self.auxFormItem = textChoice.auxiliaryItem
        
        if let auxItem = textChoice.auxiliaryItem,
            let delegate = self.delegate,
            let auxView: UIView = delegate.viewForAuxiliaryItem(item: auxItem) {
            
            self.auxStackView.addArrangedSubview(auxView)
        }
        
        
//        guard let auxItem = textChoice.auxiliaryItem else {
//            return
//        }
        
    }
    
    func updateHeightConstraints() {
        
        if self.titleHeight == nil {
            
            //sorry for the magic numbers, padding, padding, checkmark, padding
            let titleWidth = self.frame.width - (8 + 8 + 24 + 8)
            let sizeThatFits = self.titleLabel.sizeThatFits(CGSize(width: titleWidth, height: CGFloat(MAXFLOAT)))
            let height = sizeThatFits.height
            
            let titleHeight = NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height)
            
            self.titleHeight = titleHeight
            self.titleLabel.addConstraint(titleHeight)
            
            //sorry for the magic numbers, padding + padding
            let containerHeight = NSLayoutConstraint(item: self.choiceContainer, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height + 32)
            
            self.choiceContainerHeight = containerHeight
            self.choiceContainer.addConstraint(containerHeight)
        }
        
        let titleWidth = self.frame.width - (8 + 8 + 24 + 8)
        let titleHeight = self.titleLabel.sizeThatFits(CGSize(width: titleWidth, height: CGFloat(MAXFLOAT))).height
        self.titleHeight?.constant = titleHeight
        //sorry for the magic numbers, padding + padding
        self.choiceContainerHeight?.constant = titleHeight + 32
        
    }
    
    open override func updateConstraints() {
        
        self.updateHeightConstraints()
        super.updateConstraints()
        
    }
    
    open func updateUI(selected: Bool, animated: Bool, updateResponder: Bool) {
        
        if selected {
            self.titleLabel.textColor = self.tintColor
            self.checkImageView.isHidden = false
            
            if let _ = self.auxFormItem {
                if let auxHeight = self.auxHeight {
                    self.auxContainer.removeConstraint(auxHeight)
                    self.auxHeight = nil
//                    if updateResponder { self.auxTextField.becomeFirstResponder() }
                }
            }
            
        }
        else {
            self.titleLabel.textColor = UIColor.black
            self.checkImageView.isHidden = true
            
            if self.auxHeight == nil {
                let auxContainerHeight = NSLayoutConstraint(item: self.auxContainer, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
                auxContainerHeight.priority = UILayoutPriority(rawValue: 801)
                self.auxHeight = auxContainerHeight
                self.auxContainer.addConstraint(auxContainerHeight)
            }
            
            self.endEditing(true)
            
        }
        
        self.setNeedsUpdateConstraints()
        
    }
    
}
