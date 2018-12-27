//
//  GameFlow.swift
//  Gridy
//
//  Created by Rafal Padberg on 20.12.18.
//  Copyright © 2018 Rafal Padberg. All rights reserved.
//

import UIKit

class GameFlowController {
    
    let navigator: UINavigationController
    
    init(navigator: UINavigationController) {
        self.navigator = navigator
    }
    
    func goBack() {
        navigator.popViewController(animated: true)
    }
}