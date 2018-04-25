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
    func layoutTableview()
}

open class RSEnhancedMultipleChoiceCellWithAccessory: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    @IBOutlet weak var auxStackView: UIStackView!
    
    var identifier: Int!

    var auxFormItem: ORKFormItem?
    
    weak var delegate: RSEnhancedMultipleChoiceCellWithAccessoryDelegate?
    
    var auxContainerBackgroundView: UIView?
    
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

        self.identifier = nil
        self.auxFormItem = nil
        self.auxStackView.arrangedSubviews.forEach { subView in
            self.auxStackView.removeArrangedSubview(subView)
            subView.removeFromSuperview()
        }
        
        self.auxContainerBackgroundView?.removeFromSuperview()
        
    }
    
    open func configure(forTextChoice textChoice: RSTextChoiceWithAuxiliaryAnswer, withId: Int, delegate: RSEnhancedMultipleChoiceCellWithAccessoryDelegate?, result: ORKResult?) {
        
        self.clearForReuse()
        
        self.identifier = withId
        self.separatorInset = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.titleLabel?.text = textChoice.text
        self.selectionStyle = .none
        
        self.checkImageView.image = UIImage(named: "checkmark", in: Bundle(for: ORKStep.self), compatibleWith: nil)
        
        self.auxFormItem = textChoice.auxiliaryItem
        
    }
    
    open func updateUI(selected: Bool, animated: Bool, updateResponder: Bool) {
        
        self.auxContainerBackgroundView?.removeFromSuperview()
        
        if selected {
            self.titleLabel.textColor = self.tintColor
            self.checkImageView.isHidden = false
            
            if let auxItem = self.auxFormItem,
                let auxView: UIView = self.delegate?.viewForAuxiliaryItem(item: auxItem) {

                self.auxStackView.arrangedSubviews.forEach { subview in
                    self.auxStackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                }
            
                
                assert(self.auxStackView.arrangedSubviews.count == 0)
                self.auxStackView.addArrangedSubview(auxView)
                }
                
        }
        else {
            self.titleLabel.textColor = UIColor.black
            self.checkImageView.isHidden = true
            
            self.endEditing(true)
            self.setNeedsUpdateConstraints()
            
            assert(self.auxStackView.arrangedSubviews.count <= 1)
            if let subview = self.auxStackView.arrangedSubviews.first {
                
                //take snapshot of the subview
                let layer = subview.layer
                UIGraphicsBeginImageContext(subview.bounds.size);
                guard let context = UIGraphicsGetCurrentContext() else {
                    self.auxStackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                    return
                }
                
                layer.render(in:context)
                guard let viewImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
                    self.auxStackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                    return
                }
                UIGraphicsEndImageContext()

                //set auxcontainer background view to the image
                //background view will be removed on next ui update
                //remove image
                let backgroundColor = UIColor(patternImage: viewImage)
                let backgroundView = UIView()
                backgroundView.backgroundColor = backgroundColor
                backgroundView.translatesAutoresizingMaskIntoConstraints = false
                self.auxStackView.insertSubview(backgroundView, at: 0)
                NSLayoutConstraint.activate([
                    backgroundView.leadingAnchor.constraint(equalTo: self.auxStackView.leadingAnchor),
                    backgroundView.trailingAnchor.constraint(equalTo: self.auxStackView.trailingAnchor),
                    backgroundView.topAnchor.constraint(equalTo: self.auxStackView.topAnchor),
                    backgroundView.bottomAnchor.constraint(equalTo: self.auxStackView.bottomAnchor)
                    ])
                
                self.auxContainerBackgroundView = backgroundView
                
                self.auxStackView.backgroundColor = backgroundColor
                self.auxStackView.removeArrangedSubview(subview)
                subview.removeFromSuperview()
                
            }
            
        }
        
        self.setNeedsUpdateConstraints()
        
    }
 
    private static func delay(_ delay:TimeInterval, dispatchQueue: DispatchQueue = DispatchQueue.main,  closure:@escaping ()->()) {
        dispatchQueue.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
