//
//  RSGiphyInstructionStepViewController.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 1/24/19.
//

import UIKit
import SwiftyGif
import GiphyCoreSDK
import SnapKit

open class RSGiphyInstructionStepViewController: RSQuestionViewController {
    
    var stackView: UIStackView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        guard let step = self.step as? RSGiphyInstructionStep else {
            return
        }
        
        var stackedViews: [UIView] = []
        
        if let apiKey = step.giphyAPIKey,
            let gifID = step.gifID,
            let url = URL(string: "https://media.giphy.com/media/\(gifID)/giphy.gif") {
            GiphyCore.configure(apiKey: apiKey)

            let gifView = UIImageView()
            gifView.contentMode = .scaleAspectFit
            gifView.setGifFromURL(url)
            stackedViews.append(gifView)
            
            var horizontalViews: [UIView] = []
            
            let attributionLabel = UILabel()
            attributionLabel.font = UIFont.systemFont(ofSize: 10)
            attributionLabel.text = "Source: Unknown"
            attributionLabel.numberOfLines = 0
            horizontalViews.append(attributionLabel)
            
            let bundle = Bundle.init(for: RSGiphyInstructionStepViewController.self)
            if let poweredByGiphyImage = UIImage(named: "powered_by_giphy", in: bundle, compatibleWith: nil) {
                let imageView = UIImageView(image: poweredByGiphyImage)
                imageView.contentMode = .scaleAspectFit
                horizontalViews.append(imageView)
            }
            
            let horizontalStackView = UIStackView(arrangedSubviews: horizontalViews)
            horizontalStackView.axis = .horizontal
            horizontalStackView.distribution = .equalSpacing
            horizontalStackView.spacing = 0
            
            self.view.addSubview(horizontalStackView)
            horizontalStackView.snp.makeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                if #available(iOS 11, *) {
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin)
                } else {
                    make.bottom.equalToSuperview()
                }
            }

            GiphyCore.shared.gifByID(gifID) { (response, error) in
                if let response = response, let data = response.data  {
 
                    let attributionText = data.user?.attributionDisplayName ?? data.user?.displayName ?? data.source ?? "Unknown"
                    
                    DispatchQueue.main.async {
                        attributionLabel.text = "Source: \(attributionText)"
                    }
                    
                } else {
//                    print("No Result Found")
                }
            }
        }
        
        let stackView = UIStackView(arrangedSubviews: stackedViews)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        stackView.frame = self.contentView.bounds
        self.stackView = stackView
        
        self.contentView.addSubview(stackView)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.stackView.frame = self.contentView.bounds
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.stackView.frame = self.contentView.bounds
    }
    
}
