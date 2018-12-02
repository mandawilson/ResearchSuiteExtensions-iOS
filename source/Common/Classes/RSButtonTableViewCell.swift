//
//  RSButtonTableViewCell.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 11/26/18.
//

import UIKit

open class RSButtonTableViewCell: UITableViewCell {

    @IBOutlet weak public var button: UIButton!
    
    public var onTap:((RSButtonTableViewCell) -> ())?
    
    @IBAction func buttonTap(_ sender: Any) {
        self.onTap?(self)
    }
}
