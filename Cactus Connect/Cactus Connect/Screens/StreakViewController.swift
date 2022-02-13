//
//  StreakViewController.swift
//  Cactus Connect
//
//  Created by Admin on 2/13/22.
//

import UIKit


class StreakViewController: UIViewController {
    let screenView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = backgroundColors
        
        setUpScreenView()
        setUpUI()
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
    
    func setUpUI() {
        var characterImageView = UIImageView()
        let shareButton = UIButton(type: .system)
        
        let currentDateTimeInterval = Int(Date().timeIntervalSinceReferenceDate)
        let lastDateTimeInterval = UserDefaults.standard.integer(forKey: lastUsedTimeKey)
        let difference = currentDateTimeInterval - lastDateTimeInterval
        if difference < (60 * 60 * 24 * 1) {
            characterImageView = UIImageView(image: charactersArray[0])
            shareButton.tag = 0
        } else if (difference > (60 * 60 * 24 * 1)) && (difference < (60 * 60 * 24 * 2)) {
            characterImageView = UIImageView(image: charactersArray[1])
            shareButton.tag = 1
        } else if (difference > (60 * 60 * 24 * 2)) && (difference < (60 * 60 * 24 * 3)) {
            characterImageView = UIImageView(image: charactersArray[2])
            shareButton.tag = 2
        } else if (difference > (60 * 60 * 24 * 3)) && (difference < (60 * 60 * 24 * 4)) {
            characterImageView = UIImageView(image: charactersArray[3])
            shareButton.tag = 3
        } else {
            characterImageView = UIImageView(image: charactersArray[4])
            shareButton.tag = 4
        }
        
        //image: character)
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        screenView.addSubview(characterImageView)
        
        let streakLabel = UITextView()
        streakLabel.contentInsetAdjustmentBehavior = .automatic
        streakLabel.textAlignment = NSTextAlignment.center
        streakLabel.textColor = mainTextColor
        streakLabel.font = UIFont(name: mainFont, size: 70)
        streakLabel.backgroundColor = transparentColor
        let currentStreak = UserDefaults.standard.integer(forKey: streakKey)
        if currentStreak == 1 {
            streakLabel.text = "\(currentStreak) day"
        } else {
            streakLabel.text = "\(currentStreak) days"
        }
        streakLabel.isScrollEnabled = false
        streakLabel.isEditable = false
        streakLabel.isSelectable = false
        streakLabel.translatesAutoresizingMaskIntoConstraints = false
        screenView.addSubview(streakLabel)
        
        shareButton.addTarget(self, action: #selector(share), for: .touchUpInside) // Function that the button runs
        shareButton.setTitle("share", for: .normal)
        shareButton.setTitle("share", for: .selected)
        shareButton.titleLabel?.font = UIFont(name: mainFont, size: CGFloat(buttonFontSize))
        shareButton.setTitleColor(buttonTextColor, for: .normal)
        shareButton.setTitleColor(buttonTextColor, for: .selected)
        shareButton.setBackgroundColor(transparentColor, forState: .normal)
        shareButton.setBackgroundColor(transparentColor, forState: .selected)
        shareButton.layer.borderWidth = CGFloat(buttonBorderWidth)
        shareButton.layer.borderColor = buttonBorderColor.cgColor
        shareButton.layer.cornerRadius = CGFloat(buttonCornerRadius)
        shareButton.layer.maskedCorners = buttonMaskedCorners
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        screenView.addSubview(shareButton)
        
        let homeButton = UIButton(type: .system)
        homeButton.addTarget(self, action: #selector(goHome), for: .touchUpInside) // Function that the button runs
        homeButton.setTitle("home", for: .normal)
        homeButton.setTitle("home", for: .selected)
        homeButton.titleLabel?.font = UIFont(name: mainFont, size: CGFloat(buttonFontSize))
        homeButton.setTitleColor(buttonTextColor, for: .normal)
        homeButton.setTitleColor(buttonTextColor, for: .selected)
        homeButton.setBackgroundColor(transparentColor, forState: .normal)
        homeButton.setBackgroundColor(transparentColor, forState: .selected)
        homeButton.layer.borderWidth = CGFloat(buttonBorderWidth)
        homeButton.layer.borderColor = buttonBorderColor.cgColor
        homeButton.layer.cornerRadius = CGFloat(buttonCornerRadius)
        homeButton.layer.maskedCorners = buttonMaskedCorners
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        screenView.addSubview(homeButton)
        
        
        NSLayoutConstraint.activate([
            characterImageView.centerXAnchor.constraint(equalTo: screenView.centerXAnchor),
            characterImageView.widthAnchor.constraint(equalTo: screenView.widthAnchor, multiplier: 0.8),
            characterImageView.topAnchor.constraint(equalTo: screenView.topAnchor),
            characterImageView.heightAnchor.constraint(equalTo: characterImageView.widthAnchor, multiplier: (characterImageView.image?.size.height)! / (characterImageView.image?.size.width)!),
            
            streakLabel.centerXAnchor.constraint(equalTo: screenView.centerXAnchor),
            streakLabel.widthAnchor.constraint(equalTo: screenView.widthAnchor, constant: -30),
            streakLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 20),
            streakLabel.heightAnchor.constraint(equalToConstant: 100),
            
            shareButton.centerXAnchor.constraint(equalTo: screenView.centerXAnchor),
            shareButton.widthAnchor.constraint(equalTo: screenView.widthAnchor, multiplier: 0.6),
            shareButton.bottomAnchor.constraint(equalTo: homeButton.topAnchor, constant: -10),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            
            homeButton.centerXAnchor.constraint(equalTo: screenView.centerXAnchor),
            homeButton.widthAnchor.constraint(equalTo: screenView.widthAnchor, multiplier: 0.6),
            homeButton.bottomAnchor.constraint(equalTo: screenView.bottomAnchor),
            homeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    @objc func goHome(sender: UIButton!) {
        goBack(fromViewController: self)
    }
    
    
    // Sharing
    @objc func share(sender: UIButton) {
        let shareViewController = UIActivityViewController(activityItems: [charactersArray[sender.tag]!, "\(UserDefaults.standard.integer(forKey: streakKey)) day streak!", "\n\nChallenge and play in Cactus Connect on the iOS App Store!"], applicationActivities: nil)
        
        // Pre-configuring activity items
        shareViewController.activityItemsConfiguration = [UIActivity.ActivityType.message] as? UIActivityItemsConfigurationReading
        
        // Anything you want to exclude
        shareViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]
        
        shareViewController.popoverPresentationController?.sourceView = self.view
        self.present(shareViewController, animated: true, completion: nil)
    }
}
