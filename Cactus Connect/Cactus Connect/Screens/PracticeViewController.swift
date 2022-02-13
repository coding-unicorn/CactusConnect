//
//  PracticeViewController.swift
//  Cactus Connect
//
//  Created by natacha on 2/12/22.
//

import UIKit


class PracticeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    let screenView = UIView()
    
    let flashcard = UIView()
    var currentFlashcardIndex = 0
    let currentFlashcardLabel = UITextView()
    let currentFlashcardWord = UITextView()
    
    let languagePickerView1 = UIPickerView()
    let selectedLanguageLabel1 = UITextField()
    let languagePickerView2 = UIPickerView()
    let selectedLanguageLabel2 = UITextField()
    
    var selectedLanguages = ["English", "English"]
    var selectedFlashcardFrontBack = "English"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = backgroundColors
        
        selectedLanguages = [languageList[Int(UserDefaults.standard.string(forKey: localLanguageKey)!)!], "English"]
        selectedFlashcardFrontBack = languageList[Int(UserDefaults.standard.string(forKey: localLanguageKey)!)!]
        setUpScreenView()
        setUpUI()
        setUpGestures()
    }
    
    
    func setUpScreenView() {
        screenView.backgroundColor = transparentColor
        screenView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(screenView)
        let maxAspectRatio = CGFloat(16.0 / 9.0) // Needs to have the decimal to be a valid CGFloat to work
        NSLayoutConstraint.activate([
            //screenView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            //screenView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: (1.0 / maxAspectRatio)), // Needs to hae the decimal to be a valid CGFloat to work
            //screenView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor)
            screenView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            screenView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            screenView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: (1.0 / maxAspectRatio)), // Needs to hae the decimal to be a valid CGFloat to work
        ])
    }
    
    func setUpUI() {
        let homeButton = UIButton(type: .system)
        homeButton.addTarget(self, action: #selector(goHome), for: .touchUpInside)
        homeButton.setImage(UIImage(named: "Home Button.png"), for: .normal)
        homeButton.setImage(UIImage(named: "Home Button.png"), for: .selected)
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(homeButton)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissUIPickerView))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        languagePickerView1.delegate = self
        languagePickerView1.selectRow(Int(UserDefaults.standard.string(forKey: localLanguageKey)!)!, inComponent: 0, animated: true)
        languagePickerView1.isUserInteractionEnabled = true
        selectedLanguageLabel1.inputView = languagePickerView1
        selectedLanguageLabel1.inputAccessoryView = toolBar
        selectedLanguageLabel1.textAlignment = NSTextAlignment.center
        selectedLanguageLabel1.text = languageList[Int(UserDefaults.standard.string(forKey: localLanguageKey)!)!]
        selectedLanguageLabel1.textColor = mainTextColor
        selectedLanguageLabel1.font = UIFont(name: mainFont, size: CGFloat(textFontSize))
        selectedLanguageLabel1.backgroundColor = buttonColor
        selectedLanguageLabel1.layer.borderWidth = CGFloat(buttonBorderWidth)
        selectedLanguageLabel1.layer.borderColor = buttonBorderColor.cgColor
        selectedLanguageLabel1.layer.cornerRadius = CGFloat(buttonCornerRadius)
        selectedLanguageLabel1.layer.maskedCorners = buttonMaskedCorners
        selectedLanguageLabel1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(selectedLanguageLabel1)
        
        languagePickerView2.delegate = self
        languagePickerView2.selectRow(0, inComponent: 0, animated: true)
        languagePickerView2.isUserInteractionEnabled = true
        selectedLanguageLabel2.inputView = languagePickerView2
        selectedLanguageLabel2.inputAccessoryView = toolBar
        selectedLanguageLabel2.textAlignment = NSTextAlignment.center
        selectedLanguageLabel2.text = "English"
        selectedLanguageLabel2.textColor = mainTextColor
        selectedLanguageLabel2.font = UIFont(name: mainFont, size: CGFloat(textFontSize))
        selectedLanguageLabel2.backgroundColor = buttonColor
        selectedLanguageLabel2.layer.borderWidth = CGFloat(buttonBorderWidth)
        selectedLanguageLabel2.layer.borderColor = buttonBorderColor.cgColor
        selectedLanguageLabel2.layer.cornerRadius = CGFloat(buttonCornerRadius)
        selectedLanguageLabel2.layer.maskedCorners = buttonMaskedCorners
        selectedLanguageLabel2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(selectedLanguageLabel2)
        
        currentFlashcardLabel.contentInsetAdjustmentBehavior = .automatic
        currentFlashcardLabel.textAlignment = NSTextAlignment.center
        currentFlashcardLabel.textColor = mainTextColor
        currentFlashcardLabel.font = UIFont(name: mainFont, size: 20.0)
        currentFlashcardLabel.backgroundColor = transparentColor
        currentFlashcardLabel.text = "\(currentFlashcardIndex) of \(database.count)"
        currentFlashcardLabel.isScrollEnabled = false
        currentFlashcardLabel.isEditable = false
        currentFlashcardLabel.isSelectable = false
        currentFlashcardLabel.translatesAutoresizingMaskIntoConstraints = false
        screenView.addSubview(currentFlashcardLabel)
        
        flashcard.backgroundColor = .white
        flashcard.layer.cornerRadius = CGFloat(buttonCornerRadius)
        flashcard.layer.maskedCorners = buttonMaskedCorners
        flashcard.layer.shadowColor = mainTextColor.cgColor
        flashcard.layer.shadowOffset = CGSize(width: 3, height: 3)
        flashcard.layer.shadowOpacity = 0.6
        flashcard.layer.shadowRadius = 4
        let flipFlashcardTap = UITapGestureRecognizer(target: self, action: #selector(self.flipFlashcard))
        flashcard.addGestureRecognizer(flipFlashcardTap)
        flashcard.translatesAutoresizingMaskIntoConstraints = false
        screenView.addSubview(flashcard)
        
        currentFlashcardWord.contentInsetAdjustmentBehavior = .automatic
        currentFlashcardWord.textAlignment = NSTextAlignment.center
        currentFlashcardWord.textColor = mainTextColor
        currentFlashcardWord.font = UIFont(name: mainFont, size: 26.0)
        currentFlashcardWord.backgroundColor = transparentColor
        currentFlashcardWord.text = "\(database[currentFlashcardIndex][languageList[Int(UserDefaults.standard.string(forKey: localLanguageKey)!)!]]!)"
        currentFlashcardWord.isScrollEnabled = false
        currentFlashcardWord.isEditable = false
        currentFlashcardWord.isSelectable = false
        currentFlashcardWord.translatesAutoresizingMaskIntoConstraints = false
        flashcard.addSubview(currentFlashcardWord)
        
        
        // Constraints
        NSLayoutConstraint.activate([
            homeButton.widthAnchor.constraint(equalToConstant: 100),
            homeButton.heightAnchor.constraint(equalTo: homeButton.widthAnchor),
            homeButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            homeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            
            selectedLanguageLabel1.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            selectedLanguageLabel1.topAnchor.constraint(equalTo: homeButton.bottomAnchor, constant: 10),
            selectedLanguageLabel1.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 5),
            selectedLanguageLabel1.rightAnchor.constraint(equalTo: selectedLanguageLabel2.leftAnchor, constant: -5),
            selectedLanguageLabel1.heightAnchor.constraint(equalToConstant: 50),
            
            selectedLanguageLabel1.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            selectedLanguageLabel2.topAnchor.constraint(equalTo: homeButton.bottomAnchor, constant: 10),
            selectedLanguageLabel2.leftAnchor.constraint(equalTo: selectedLanguageLabel1.rightAnchor, constant: 5),
            selectedLanguageLabel2.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -5),
            selectedLanguageLabel2.heightAnchor.constraint(equalToConstant: 50),
            
            screenView.topAnchor.constraint(equalTo: selectedLanguageLabel1.bottomAnchor),
            
            currentFlashcardLabel.centerXAnchor.constraint(equalTo: screenView.centerXAnchor),
            currentFlashcardLabel.widthAnchor.constraint(equalTo: screenView.widthAnchor, constant: -30),
            currentFlashcardLabel.heightAnchor.constraint(equalToConstant: 50),
            currentFlashcardLabel.topAnchor.constraint(equalTo: screenView.topAnchor), //selectedLanguageLabel1.bottomAnchor),
            
            flashcard.centerXAnchor.constraint(equalTo: screenView.centerXAnchor),
            flashcard.widthAnchor.constraint(equalTo: screenView.widthAnchor, multiplier: 0.8),
            flashcard.topAnchor.constraint(equalTo: currentFlashcardLabel.bottomAnchor, constant: 20),
            flashcard.bottomAnchor.constraint(equalTo: screenView.bottomAnchor, constant: -20),
            
            currentFlashcardWord.centerXAnchor.constraint(equalTo: flashcard.centerXAnchor),
            currentFlashcardWord.centerYAnchor.constraint(equalTo: flashcard.centerYAnchor),
            currentFlashcardWord.widthAnchor.constraint(equalTo: flashcard.widthAnchor, constant: -30),
            currentFlashcardWord.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    @objc func goHome(sender: UIButton!) {
        goBack(fromViewController: self)
    }
    @objc func flipFlashcard(sender: UITapGestureRecognizer) {
        if currentFlashcardWord.text == "\(database[currentFlashcardIndex][selectedLanguages[0]]!)" {
            selectedFlashcardFrontBack = selectedLanguages[1]
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.flashcard.transform = CGAffineTransform(scaleX: 1, y: -1)
            }, completion: nil)
            currentFlashcardWord.transform = CGAffineTransform(scaleX: 1, y: -1)
        } else if currentFlashcardWord.text == "\(database[currentFlashcardIndex][selectedLanguages[1]]!)" {
            selectedFlashcardFrontBack = selectedLanguages[0]
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.flashcard.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
            currentFlashcardWord.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        currentFlashcardWord.text = "\(database[currentFlashcardIndex][selectedFlashcardFrontBack]!)"
    }
    
    func setUpGestures() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipe)
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                case UISwipeGestureRecognizer.Direction.right:
                    if currentFlashcardIndex == 0 {
                        currentFlashcardIndex = database.count - 1
                    } else {
                        currentFlashcardIndex = currentFlashcardIndex - 1
                    }
                case UISwipeGestureRecognizer.Direction.left:
                    if currentFlashcardIndex == (database.count - 1) {
                        currentFlashcardIndex = 0
                    } else {
                        currentFlashcardIndex = currentFlashcardIndex + 1
                    }
                default:
                    break
            }
        }
        
        
        currentFlashcardWord.text = "\(database[currentFlashcardIndex][selectedFlashcardFrontBack]!)"
        currentFlashcardLabel.text = "\(currentFlashcardIndex + 1) of \(database.count)"
    }
    
    
    // UIPickerView
    @objc func dismissUIPickerView() {
        view.endEditing(true)
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
        if pickerView == languagePickerView1 {
            selectedFlashcardFrontBack = selectedLanguages[0]
            selectedLanguages[0] = languageList[row]
            selectedLanguageLabel1.text = selectedLanguages[0]
            currentFlashcardWord.text = "\(database[currentFlashcardIndex][selectedLanguages[0]]!)"
        } else if pickerView == languagePickerView2 {
            selectedFlashcardFrontBack = selectedLanguages[1]
            selectedLanguages[1] = languageList[row]
            selectedLanguageLabel2.text = selectedLanguages[1]
            currentFlashcardWord.text = "\(database[currentFlashcardIndex][selectedLanguages[1]]!)"
        }
    }
}
