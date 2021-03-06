//
//  EndScreenController.swift
//  WatchOut
//
//  Created by iOS1920 on 20.01.20.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit

class EndScreenController {

    private let endScreenViewController : EndScreenViewController
    
    private let gameManager = GameManager.shared
    private let dmManager = DeviceMotionManager.shared
    
    init(endScreenViewController: EndScreenViewController) {
        self.endScreenViewController = endScreenViewController
    }
    
    func showLoserPlayer() {
        // update the ui label for the losing player
        let currentPlayer = gameManager.currentPlayer
        
        let newText = String("\(currentPlayer!.name) lost!")
        endScreenViewController.updateLoserLabel(newText: newText)
    }
    
    // MARK: - Navigation
    
    func navigateToHome() {
        endScreenViewController.performSegue(withIdentifier: Constants.HomeSegue, sender: self)
    }
    
    func endCurrentGame() {
        gameManager.endCurrentGame()
    }
    
    func navigateToFirstTask() {
        // create a new game similar to when the start button is pressed on the home screen
        let lastPlayers = gameManager.players
        gameManager.startNewGame(players: lastPlayers)
        
        let result = dmManager.startDeviceMotion()

        if (result) {
            switch(gameManager.currentTask) {
                case .Unwrap:
                    endScreenViewController.performSegue(withIdentifier: Constants.UnwrapSegue, sender: self)
                case .Deliver:
                    endScreenViewController.performSegue(withIdentifier: Constants.DeliverSegue, sender: self)
                case .Twitch:
                    endScreenViewController.performSegue(withIdentifier: Constants.TwitchSegue, sender: self)
                case .none:
                    return
            }
        }
    }
}
