//
//  SuccessView.swift
//  Gridy
//
//  Created by Rafal Padberg on 23.01.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class SuccessView: UIView {
    
    var flow: GameFlowController!
    
    // MARK: - Outlets
    
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var scoreBigLabel: UILabel!
    @IBOutlet weak var scoreSmallLabel: UILabel!
    
    @IBOutlet weak var firstStackView: UIStackView!
    @IBOutlet weak var detailsStackView: UIStackView!
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    // MARK: - Public API's
    
    func initialize() {
        Bundle.main.loadNibNamed("SuccessView", owner: self, options: nil)
        addSubview(customView)
        customView.frame = self.bounds
        
        newGameButton.styleSelectButton()
        prepareForAnimation()
    }
    
    func setConstraints(isPortraitMode: Bool) {
        topConstraint.constant = !isPortraitMode ? 50 : 200
    }
    
    func conectFlowController(flow: GameFlowController) {
        self.flow = flow
    }
    
    // Populates all labels with data
    func injectData(successData: SuccessViewData) {
        let descriptions = detailsStackView.subviews[0].subviews as? [UILabel]
        let pointsPerX = detailsStackView.subviews[2].subviews as? [UILabel]
        let calculations = detailsStackView.subviews[4].subviews as? [UILabel]
        
        for i in 0 ..< 4 {
            descriptions?[i].text = successData.descriptions[i]
            pointsPerX?[i].text = successData.pointsPerX[i]
            calculations?[i].text = successData.calculations[i]
        }
        scoreBigLabel.text = successData.endScore
        scoreSmallLabel.text = successData.endScore
    }
    
    // 3 consecutive animations happening each after another to create a good looking effect
    // Changes alpha back to 1 and transform-attribute back to .identity
    func animateSuccess() {
        UIView.animate(withDuration: 0.4, animations: {
            self.customView.alpha = 1
        }) { [weak self] (_) in
            UIView.animate(withDuration: 0.6, animations: {
                self?.firstStackView.subviews.forEach({ (stack) in
                    stack.transform = .identity
                    stack.alpha = 1
                })
            }, completion: { (_) in
                var onlyOnce = true
                self?.detailsStackView.subviews.forEach({ (subview) in
                    for (i, label) in subview.subviews.enumerated() {
                        
                        UIView.animate(withDuration: 0.4, delay: 0 + (0.1 * Double(i)), options: [], animations: {
                            label.alpha = 1.0
                            label.transform = .identity
                        }, completion: { _ in
                            
                            if i == 3 && onlyOnce {
                                onlyOnce = false
                                UIView.animate(withDuration: 0.5, delay: 0.2, options: [], animations: {
                                    self?.scoreSmallLabel.alpha = 1
                                    self?.scoreSmallLabel.transform = .identity
                                    
                                    self?.newGameButton.alpha = 1
                                    self?.newGameButton.transform = .identity
                                }, completion: nil)
                                
                                UIView.animate(withDuration: 0.5, animations: {
                                    self?.lineView.transform = .identity
                                })
                            }
                        })
                    }
                })
            })
        }
    }
    
    // MARK: - Private Methods
    
    // Animated StackViews will have their transform attributes changed.
    // When animating all of this transform attributes will be set back to normal/.identity
    private func prepareForAnimation() {
        customView.alpha = 0
        
        let width = UIScreen.main.bounds.size.width
        
        let moveRightTransform = CGAffineTransform.init(translationX: width, y: 0)
        let scaleUpTransform = CGAffineTransform.init(scaleX: 2.5, y: 2.5)
        let moveScaleTransform = scaleUpTransform.concatenating(moveRightTransform)
        
        for stack in firstStackView.subviews {
            stack.transform = moveScaleTransform
            stack.alpha = 0
        }
        
        for stack in detailsStackView.subviews {
            stack.subviews.forEach { (subview) in
                subview.alpha = 0
                subview.transform = scaleUpTransform
            }
        }
        scoreSmallLabel.alpha = 0
        scoreSmallLabel.transform = moveRightTransform
        
        newGameButton.alpha = 0
        newGameButton.transform = scaleUpTransform
        
        lineView.transform = moveRightTransform
    }
    
    // MARK: - Action Methods
    
    @IBAction func newGameButtonTapped(_ sender: UIButton) {
        flow.newGame()
    }
}
