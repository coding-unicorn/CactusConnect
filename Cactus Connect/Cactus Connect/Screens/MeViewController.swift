//
//  MeViewController.swift
//  Cactus Connect
//
//  Created by Admin on 2/12/22.
//

import UIKit
import GameKit


class MeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    let screenView = UIView()
    let header = UIView()
    let boxView = UIView()
    
    let languagePickerView = UIPickerView()
    let selectedLanguageLabel = UITextField()
    var selectedLanguageIndex = 0
    
    let username = UITextView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = backgroundColors
        
        setUpScreenView()
        setUpHeading()
        authenticatePlayer()
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
    
    func setUpUI() {
        boxView.backgroundColor = transparentColor
        boxView.translatesAutoresizingMaskIntoConstraints = false
        screenView.addSubview(boxView)
        
        username.contentInsetAdjustmentBehavior = .automatic
        username.textAlignment = NSTextAlignment.center
        username.textColor = mainTextColor
        username.font = UIFont(name: mainFont, size: 26.0)
        username.backgroundColor = transparentColor
        username.text = "Player"
        username.isScrollEnabled = false
        username.isEditable = false
        username.isSelectable = false
        username.translatesAutoresizingMaskIntoConstraints = false
        boxView.addSubview(username)
        
        let streakLabel = UITextView()
        streakLabel.contentInsetAdjustmentBehavior = .automatic
        streakLabel.textAlignment = NSTextAlignment.center
        streakLabel.textColor = mainTextColor
        streakLabel.font = UIFont(name: mainFont, size: 26.0)
        streakLabel.backgroundColor = transparentColor
        streakLabel.text = "\(UserDefaults.standard.string(forKey: streakKey)!) day streak"
        streakLabel.isScrollEnabled = false
        streakLabel.isEditable = false
        streakLabel.isSelectable = false
        streakLabel.translatesAutoresizingMaskIntoConstraints = false
        boxView.addSubview(streakLabel)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissUIPickerView))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        languagePickerView.delegate = self
        languagePickerView.selectRow(Int(UserDefaults.standard.string(forKey: localLanguageKey)!)!, inComponent: 0, animated: true)
        languagePickerView.isUserInteractionEnabled = true
        selectedLanguageLabel.inputView = languagePickerView
        selectedLanguageLabel.inputAccessoryView = toolBar
        selectedLanguageLabel.textAlignment = NSTextAlignment.center
        selectedLanguageLabel.text = languageList[Int(UserDefaults.standard.string(forKey: localLanguageKey)!)!]
        selectedLanguageLabel.textColor = mainTextColor
        selectedLanguageLabel.font = UIFont(name: mainFont, size: CGFloat(textFontSize))
        selectedLanguageLabel.backgroundColor = transparentColor
        selectedLanguageLabel.layer.borderWidth = CGFloat(buttonBorderWidth)
        selectedLanguageLabel.layer.borderColor = buttonBorderColor.cgColor
        selectedLanguageLabel.layer.cornerRadius = CGFloat(buttonCornerRadius)
        selectedLanguageLabel.layer.maskedCorners = buttonMaskedCorners
        selectedLanguageLabel.translatesAutoresizingMaskIntoConstraints = false
        boxView.addSubview(selectedLanguageLabel)
        
        let shareButton = UIButton(type: .system)
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
        boxView.addSubview(shareButton)
        
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
        boxView.addSubview(homeButton)
        
        
        NSLayoutConstraint.activate([
            boxView.centerXAnchor.constraint(equalTo: screenView.centerXAnchor),
            boxView.widthAnchor.constraint(equalTo: screenView.widthAnchor),
            boxView.topAnchor.constraint(equalTo: header.bottomAnchor),
            boxView.bottomAnchor.constraint(equalTo: screenView.bottomAnchor),
            
            username.centerXAnchor.constraint(equalTo: boxView.centerXAnchor),
            username.widthAnchor.constraint(equalTo: boxView.widthAnchor, constant: -30),
            username.topAnchor.constraint(equalTo: boxView.topAnchor, constant: 10),
            username.heightAnchor.constraint(equalToConstant: 50),
            
            streakLabel.centerXAnchor.constraint(equalTo: boxView.centerXAnchor),
            streakLabel.widthAnchor.constraint(equalTo: boxView.widthAnchor, constant: -30),
            streakLabel.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 10),
            streakLabel.heightAnchor.constraint(equalToConstant: 50),
            
            selectedLanguageLabel.centerXAnchor.constraint(equalTo: boxView.centerXAnchor),
            selectedLanguageLabel.widthAnchor.constraint(equalTo: boxView.widthAnchor, multiplier: 0.6),
            selectedLanguageLabel.topAnchor.constraint(equalTo: streakLabel.bottomAnchor, constant: 10),
            selectedLanguageLabel.heightAnchor.constraint(equalToConstant: 50),
            
            shareButton.centerXAnchor.constraint(equalTo: boxView.centerXAnchor),
            shareButton.widthAnchor.constraint(equalTo: boxView.widthAnchor, multiplier: 0.6),
            shareButton.bottomAnchor.constraint(equalTo: homeButton.topAnchor, constant: -10),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            
            homeButton.centerXAnchor.constraint(equalTo: screenView.centerXAnchor),
            homeButton.widthAnchor.constraint(equalTo: boxView.widthAnchor, multiplier: 0.6),
            homeButton.bottomAnchor.constraint(equalTo: boxView.bottomAnchor),
            homeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    @objc func goHome(sender: UIButton!) {
        goBack(fromViewController: self)
    }
    
    
    func authenticatePlayer() {
        let localPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {
            (view, error) in
            if view != nil {
                self.present(view!, animated: true, completion: nil)
            } else {
                print(GKLocalPlayer.local.isAuthenticated)
                self.username.text = "\(GKLocalPlayer.local.displayName)"
            }
        }
    }
    
    
    // UIPickerView
    @objc func dismissUIPickerView() {
        view.endEditing(true)
        UserDefaults.standard.set(selectedLanguageIndex, forKey: localLanguageKey)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languageList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLanguageIndex = row
        selectedLanguageLabel.text = languageList[row]
    }
    
    
    // Sharing
    @objc func share(sender: UIButton) {
        let shareViewController = UIActivityViewController(activityItems: [charactersArray[0]!, "\(GKLocalPlayer.local.displayName) is on Cactus Connect!", "\n\nChallenge and play on the iOS App Store!"], applicationActivities: nil)
        
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
