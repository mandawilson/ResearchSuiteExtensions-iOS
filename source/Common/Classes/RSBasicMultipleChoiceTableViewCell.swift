//
//  RSBasicMultipleChoiceTableViewCell.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 11/26/18.
//

import UIKit
import ResearchKit

open class RSBasicMultipleChoiceTableViewCell: UITableViewCell {

    @IBOutlet weak public var titleLabel: UILabel!
    var checkImage: UIImage?
    @IBOutlet weak var checkImageView: UIImageView!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.checkImage = UIImage(named: "checkmark", in: Bundle(for: ORKStep.self), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        self.updateCheckImage(show: false)
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.titleLabel.textColor = self.tintColor
            self.checkImageView.tintColor = self.tintColor
        }
        else {
            self.titleLabel.textColor = UIColor.black
            self.checkImageView.tintColor = UIColor.black
        }
    
        // Configure the view for the selected state
        self.updateCheckImage(show: selected)
    }
    
    private func updateCheckImage(show: Bool) {
        self.checkImageView.image = show ? self.checkImage : nil
    }
    
}
