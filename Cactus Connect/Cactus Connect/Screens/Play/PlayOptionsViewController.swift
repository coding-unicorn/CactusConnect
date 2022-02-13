//
//  PlayOptionsViewController.swift
//  Cactus Connect
//
//  Created by Admin on 8/3/21.
//

import UIKit
import GameKit


class PlayOptionsViewController: UIViewController, GKGameCenterControllerDelegate {
    let screenView = UIView()
    let header = UIView()
    let buttonsView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = backgroundColors
        
        setUpScreenView()
        setUpHeading()
        setUpButtons()
        
        authenticatePlayer()
    }
    
    
    func setUpScreenView() {
        screenView.backgroundColor = transparentColor
        screenView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(screenView)
        let maxAspectRatio = CGFloat(16.0 / 9.0) // Needs to hae the decimal to be a valid CGFloat to work
        NSLayoutConstraint.activate([
            screenView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            screenView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: (1.0 / maxAspectRatio)), // Needs to hae the decimal to be a valid CGFloat to work
            screenView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor)
            
        ])
    }
    
    func setUpHeading() {
        header.backgroundColor = transparentColor
        header.translatesAutoresizingMaskIntoConstraints = false
        screenView.addSubview(header)
        
        let logoView = UIImageView(image: logo!)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(logoView)
        
        
        NSLayoutConstraint.activate([
            header.centerXAnchor.constraint(equalTo: screenView.centerXAnchor),
            header.widthAnchor.constraint(equalTo: screenView.widthAnchor),
            header.topAnchor.constraint(equalTo: screenView.topAnchor),
            
            logoView.topAnchor.constraint(equalTo: header.topAnchor, constant: 20),
            logoView.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            logoView.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.8),
            logoView.heightAnchor.constraint(equalTo: logoView.widthAnchor, multiplier: (logoView.image?.size.height)! / (logoView.image?.size.width)!),
            logoView.bottomAnchor.constraint(equalTo: header.bottomAnchor)
        ])
    }
    
    func setUpButtons() {
        buttonsView.backgroundColor = transparentColor
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        screenView.addSubview(buttonsView)
        
        let centerButtonView = UIView()
        centerButtonView.backgroundColor = transparentColor
        centerButtonView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.addSubview(centerButtonView)
        
        let playButton = createButton(title: "play", function: #selector(playButtonPressed), parentView: centerButtonView)
        let leaderboardButton = createButton(title: "leaderboard", function: #selector(leaderboardButtonPressed), parentView: centerButtonView)
        let homeButton = createButton(title: "home", function: #selector(homeButtonPressed), parentView: buttonsView)
        
        
        NSLayoutConstraint.activate([
            buttonsView.topAnchor.constraint(equalTo: header.bottomAnchor),
            buttonsView.centerXAnchor.constraint(equalTo: screenView.centerXAnchor),
            buttonsView.widthAnchor.constraint(equalTo: screenView.widthAnchor),
            buttonsView.heightAnchor.constraint(greaterThanOrEqualTo: centerButtonView.heightAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: screenView.bottomAnchor),
            
            centerButtonView.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor),
            centerButtonView.widthAnchor.constraint(equalTo: buttonsView.widthAnchor),
            centerButtonView.centerYAnchor.constraint(equalTo: buttonsView.centerYAnchor),
            centerButtonView.topAnchor.constraint(equalTo: playButton.topAnchor),
            centerButtonView.bottomAnchor.constraint(equalTo: leaderboardButton.bottomAnchor),
            
            playButton.topAnchor.constraint(equalTo: centerButtonView.topAnchor),
            leaderboardButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 20),
            homeButton.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor),
        ])
    }
    func createButton(title: String, function: Selector, parentView: UIView) -> UIButton {
        let button = UIButton(type: .system)
        button.addTarget(self, action: function, for: .touchUpInside) // Function that the button runs
        button.setTitle(title, for: .normal)
        button.setTitle(title, for: .selected)
        button.titleLabel?.font = UIFont(name: mainFont, size: CGFloat(buttonFontSize))
        button.setTitleColor(buttonTextColor, for: .normal)
        button.setTitleColor(buttonTextColor, for: .selected)
        button.setBackgroundColor(transparentColor, forState: .normal)
        button.setBackgroundColor(transparentColor, forState: .selected)
        button.layer.borderWidth = CGFloat(buttonBorderWidth)
        button.layer.borderColor = buttonBorderColor.cgColor
        button.layer.cornerRadius = CGFloat(buttonCornerRadius)
        button.layer.maskedCorners = buttonMaskedCorners
        button.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            button.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 0.6),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return button
    }
    @objc func playButtonPressed(sender: UIButton!) {
        if GKLocalPlayer.local.isAuthenticated == true {
            presentScreen(fromViewController: self, toViewController: PlayViewController())
        } else {
            let alertController = UIAlertController(title: "Player Not Signed In", message: "You are not signed into Game Center. To Fix this, Go to >>Settings >>Game Center and create an account or sign into a pre-exsisting one. You only need to have a Game Center account if you would like to access the leaderboards or compete with friends", preferredStyle: .alert)
            // Create Cancel button
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction!) in
                self.view?.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(cancelAction)
            
            // Present Dialog message
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @objc func homeButtonPressed(sender: UIButton!) {
        goBack(fromViewController: self)
    }
    
    @objc func leaderboardButtonPressed(sender: UIButton!) {
        if GKLocalPlayer.local.isAuthenticated == true {
            saveHighScore()
            showLeaderboard()
        } else {
            let alertController = UIAlertController(title: "Player Not Signed In", message: "You are not signed into Game Center. To Fix this, Go to >>Settings >>Game Center and create an account or sign into a pre-exsisting one. You only need to have a Game Center account if you would like to access the leaderboards or compete with friends", preferredStyle: .alert)
            // Create Cancel button
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction!) in
                self.view?.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(cancelAction)
            
            // Present Dialog message
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func saveHighScore() {
        let highScore = UserDefaults.standard.integer(forKey: highScoreKey)
        GKLeaderboard.submitScore(
            highScore,
            context: 0,
            player: GKLocalPlayer.local,
            leaderboardIDs: [leaderboardIDKey]
        ) { error in
            print("\(String(describing: error))")
        }
    }
    func showLeaderboard() {
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        self.present(gameCenterViewController, animated: true, completion: nil)
    }
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    func authenticatePlayer() {
        let localPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {
            (view, error) in
            if view != nil {
                self.present(view!, animated: true, completion: nil)
            } else {
                print(GKLocalPlayer.local.isAuthenticated)
            }
        }
    }
}
