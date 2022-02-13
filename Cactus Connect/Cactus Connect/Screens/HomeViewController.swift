//
//  HomeViewCOntroller.swift
//  Cactus Connect
//
//  Created by Admin on 8/3/21.
//

import UIKit


class HomeViewController: UIViewController {
    let screenView = UIView()
    let header = UIView()
    let buttonsView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = backgroundColors
        
        setUpScreenView()
        setUpHeading()
        setUpButtons()
        
        UserDefaults.standard.register(defaults: [localLanguageKey : 0, highScoreKey: 0, lastScoreKey: 0])
        
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
        
        let practiceButton = createButton(title: "practice", function: #selector(practiceButtonPressed), parentView: centerButtonView)
        let playButton = createButton(title: "play", function: #selector(playButtonPressed), parentView: centerButtonView)
        let streakButton = createButton(title: "streak", function: #selector(streakButtonPressed), parentView: centerButtonView)
        let meButton = createButton(title: "me", function: #selector(meButtonPressed), parentView: centerButtonView)
        
        
        NSLayoutConstraint.activate([
            buttonsView.topAnchor.constraint(equalTo: header.bottomAnchor),
            buttonsView.centerXAnchor.constraint(equalTo: screenView.centerXAnchor),
            buttonsView.widthAnchor.constraint(equalTo: screenView.widthAnchor),
            buttonsView.heightAnchor.constraint(greaterThanOrEqualTo: centerButtonView.heightAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: screenView.bottomAnchor),
            
            centerButtonView.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor),
            centerButtonView.widthAnchor.constraint(equalTo: buttonsView.widthAnchor),
            centerButtonView.centerYAnchor.constraint(equalTo: buttonsView.centerYAnchor),
            centerButtonView.topAnchor.constraint(equalTo: practiceButton.topAnchor),
            centerButtonView.bottomAnchor.constraint(equalTo: meButton.bottomAnchor),
            
            practiceButton.topAnchor.constraint(equalTo: centerButtonView.topAnchor),
            playButton.topAnchor.constraint(equalTo: practiceButton.bottomAnchor, constant: 20),
            streakButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 20),
            meButton.topAnchor.constraint(equalTo: streakButton.bottomAnchor, constant: 20)
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
    
    
    @objc func practiceButtonPressed(sender: UIButton!) {
        presentScreen(fromViewController: self, toViewController: PracticeViewController())
    }
    @objc func playButtonPressed(sender: UIButton!) {
        presentScreen(fromViewController: self, toViewController: PlayOptionsViewController())
    }
    @objc func streakButtonPressed(sender: UIButton!) {
        presentScreen(fromViewController: self, toViewController: StreakViewController())
    }
    @objc func meButtonPressed(sender: UIButton!) {
        presentScreen(fromViewController: self, toViewController: MeViewController())
    }
}
