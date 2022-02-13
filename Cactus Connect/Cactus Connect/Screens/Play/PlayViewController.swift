//
//  PlayViewController.swift
//  Cactus Connect
//
//  Created by Admin on 2/12/22.
//

import UIKit
import GameKit


class PlayViewController: UIViewController, GKMatchDelegate, GKMatchmakerViewControllerDelegate {
    // Score
    var score = 0
    let scoreLabel = UITextView()
    
    // Timers
    let countDownLabel = UITextView()
    var countDownSeconds = 3
    var countDownTimer = Timer()
    let gameTimerLabel = UITextView()
    var gameSeconds = 60 //Change for testing
    var gameTimer = Timer()
    
    // GameKit
    var myMatch = GKMatch()
    var matchStarted = false
    var playersDict = NSMutableDictionary()
    var connectionState = ""
    let teammateLabel = UITextView()

    // Middle Piece -- takes up rest of the screen, either has a countdown timer, 3 buttons, or 'player is choosing' text
    let middleView = UIView()
    var choosingState = ""
    let languagesLabel = UITextView()
    
    // Other player's data
    var otherIndex = 0
    var otherLanguage = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = backgroundColors
        
        setUpUI()
        choosingState = "count down"
        updateMiddleView()
        presentMatchMaker()
    }
    
    
    func setUpUI() {
        scoreLabel.contentInsetAdjustmentBehavior = .automatic
        scoreLabel.textAlignment = NSTextAlignment.center
        scoreLabel.textColor = accentTextColor
        scoreLabel.font = UIFont(name: mainFont, size: 26)
        scoreLabel.backgroundColor = transparentColor
        scoreLabel.text = "score: \(score)"
        scoreLabel.isScrollEnabled = false
        scoreLabel.isEditable = false
        scoreLabel.isSelectable = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scoreLabel)
        
        gameTimerLabel.contentInsetAdjustmentBehavior = .automatic
        gameTimerLabel.textAlignment = NSTextAlignment.center
        gameTimerLabel.textColor = mainTextColor
        gameTimerLabel.font = UIFont(name: mainFont, size: 50)
        gameTimerLabel.backgroundColor = transparentColor
        gameTimerLabel.text = "1:00"
        gameTimerLabel.isScrollEnabled = false
        gameTimerLabel.isEditable = false
        gameTimerLabel.isSelectable = false
        gameTimerLabel.isHidden = true
        gameTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(gameTimerLabel)
        
        middleView.backgroundColor = transparentColor
        middleView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(middleView)
        
        teammateLabel.contentInsetAdjustmentBehavior = .automatic
        teammateLabel.textAlignment = NSTextAlignment.center
        teammateLabel.textColor = mainTextColor
        teammateLabel.font = UIFont(name: mainFont, size: 20)
        teammateLabel.backgroundColor = transparentColor
        teammateLabel.text = "Teammate"
        teammateLabel.isScrollEnabled = false
        teammateLabel.isEditable = false
        teammateLabel.isSelectable = false
        teammateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(teammateLabel)
        
        languagesLabel.contentInsetAdjustmentBehavior = .automatic
        languagesLabel.textAlignment = NSTextAlignment.center
        languagesLabel.textColor = mainTextColor
        languagesLabel.font = UIFont(name: mainFont, size: 20.0)
        languagesLabel.backgroundColor = transparentColor
        languagesLabel.text = "\(languageList[Int(UserDefaults.standard.string(forKey: localLanguageKey)!)!]) <--> English"
        languagesLabel.isScrollEnabled = false
        languagesLabel.isEditable = false
        languagesLabel.isSelectable = false
        languagesLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(languagesLabel)
        
        
        // Constraints
        NSLayoutConstraint.activate([
            scoreLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            scoreLabel.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, constant: -30),
            scoreLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scoreLabel.heightAnchor.constraint(equalToConstant: 50),
            
            gameTimerLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            gameTimerLabel.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, constant: -30),
            gameTimerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            gameTimerLabel.heightAnchor.constraint(equalToConstant: 65),
            
            middleView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            middleView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, constant: -30),
            middleView.topAnchor.constraint(equalTo: gameTimerLabel.bottomAnchor),
            middleView.bottomAnchor.constraint(equalTo: teammateLabel.topAnchor),
            
            teammateLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            teammateLabel.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, constant: -30),
            teammateLabel.heightAnchor.constraint(equalToConstant: 50),
            teammateLabel.bottomAnchor.constraint(equalTo: languagesLabel.topAnchor),
            
            languagesLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            languagesLabel.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, constant: -30),
            languagesLabel.topAnchor.constraint(equalTo: teammateLabel.bottomAnchor),
            languagesLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            languagesLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    func updateMiddleView() {
        for subview in middleView.subviews {
            subview.removeFromSuperview()
        }
        middleView.layoutSubviews()
        
        if choosingState == "count down" { // Display count down timer
            countDownLabel.contentInsetAdjustmentBehavior = .automatic
            countDownLabel.textAlignment = NSTextAlignment.center
            countDownLabel.textColor = mainTextColor
            countDownLabel.font = UIFont(name: mainFont, size: 200)
            countDownLabel.backgroundColor = transparentColor
            countDownLabel.text = "\(countDownSeconds)"
            countDownLabel.isScrollEnabled = false
            countDownLabel.isEditable = false
            countDownLabel.isSelectable = false
            countDownLabel.translatesAutoresizingMaskIntoConstraints = false
            middleView.addSubview(countDownLabel)
            NSLayoutConstraint.activate([
                countDownLabel.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
                countDownLabel.widthAnchor.constraint(equalTo: middleView.widthAnchor),
                countDownLabel.centerYAnchor.constraint(equalTo: middleView.centerYAnchor)
            ])
        } else if choosingState == "local choose" { // Display buttons in local language
            let buttonsView = UIView()
            buttonsView.backgroundColor = transparentColor
            buttonsView.translatesAutoresizingMaskIntoConstraints = false
            middleView.addSubview(buttonsView)
            
            let localLanguage = languageList[Int(UserDefaults.standard.string(forKey: localLanguageKey)!)!]
            
            let chooseLocalWordLabel = UITextView()
            chooseLocalWordLabel.contentInsetAdjustmentBehavior = .automatic
            chooseLocalWordLabel.textAlignment = NSTextAlignment.center
            chooseLocalWordLabel.textColor = mainTextColor
            chooseLocalWordLabel.font = UIFont(name: mainFont, size: 20.0)
            chooseLocalWordLabel.backgroundColor = transparentColor
            chooseLocalWordLabel.text = "choose a word:"
            chooseLocalWordLabel.isScrollEnabled = false
            chooseLocalWordLabel.isEditable = false
            chooseLocalWordLabel.isSelectable = false
            chooseLocalWordLabel.translatesAutoresizingMaskIntoConstraints = false
            buttonsView.addSubview(chooseLocalWordLabel)
            
            let wordButton1 = UIButton(type: .system)
            let randomInt1 = Int.random(in: 0..<database.count)
            wordButton1.tag = randomInt1
            wordButton1.addTarget(self, action: #selector(localWordButtonSelected), for: .touchUpInside)
            wordButton1.setTitle(database[randomInt1][localLanguage], for: .normal)
            wordButton1.titleLabel?.textAlignment = .center
            wordButton1.titleLabel?.font = UIFont(name: mainFont, size: CGFloat(buttonFontSize))
            wordButton1.setBackgroundColor(buttonColor, forState: .normal)
            wordButton1.setBackgroundColor(selectedButtonColor, forState: .selected)
            wordButton1.setTitleColor(mainTextColor, for: .normal)
            wordButton1.setTitleColor(mainTextColor, for: .selected)
            wordButton1.layer.cornerRadius = CGFloat(buttonCornerRadius)
            wordButton1.layer.maskedCorners = buttonMaskedCorners
            wordButton1.layer.borderColor = accentTextColor.cgColor
            wordButton1.layer.borderWidth = CGFloat(buttonBorderWidth)
            wordButton1.translatesAutoresizingMaskIntoConstraints = false
            buttonsView.addSubview(wordButton1)
            
            let wordButton2 = UIButton(type: .system)
            var randomInt2 = Int.random(in: 0..<database.count)
            while randomInt2 == randomInt1 {
                randomInt2 = Int.random(in: 0..<database.count)
            }
            wordButton2.tag = randomInt2
            wordButton2.addTarget(self, action: #selector(localWordButtonSelected), for: .touchUpInside)
            wordButton2.setTitle(database[randomInt2][localLanguage], for: .normal)
            wordButton2.titleLabel?.textAlignment = .center
            wordButton2.titleLabel?.font = UIFont(name: mainFont, size: CGFloat(buttonFontSize))
            wordButton2.setBackgroundColor(buttonColor, forState: .normal)
            wordButton2.setBackgroundColor(selectedButtonColor, forState: .selected)
            wordButton2.setTitleColor(mainTextColor, for: .normal)
            wordButton2.setTitleColor(mainTextColor, for: .selected)
            wordButton2.layer.cornerRadius = CGFloat(buttonCornerRadius)
            wordButton2.layer.maskedCorners = buttonMaskedCorners
            wordButton2.layer.borderColor = accentTextColor.cgColor
            wordButton2.layer.borderWidth = CGFloat(buttonBorderWidth)
            wordButton2.translatesAutoresizingMaskIntoConstraints = false
            buttonsView.addSubview(wordButton2)
            
            let wordButton3 = UIButton(type: .system)
            var randomInt3 = Int.random(in: 0..<database.count)
            while (randomInt3 == randomInt1) || (randomInt3 == randomInt2) {
                randomInt3 = Int.random(in: 0..<database.count)
            }
            wordButton3.tag = randomInt3
            wordButton3.addTarget(self, action: #selector(localWordButtonSelected), for: .touchUpInside)
            wordButton3.setTitle(database[randomInt3][localLanguage], for: .normal)
            wordButton3.titleLabel?.textAlignment = .center
            wordButton3.titleLabel?.font = UIFont(name: mainFont, size: CGFloat(buttonFontSize))
            wordButton3.setBackgroundColor(buttonColor, forState: .normal)
            wordButton3.setBackgroundColor(selectedButtonColor, forState: .selected)
            wordButton3.setTitleColor(mainTextColor, for: .normal)
            wordButton3.setTitleColor(mainTextColor, for: .selected)
            wordButton3.layer.cornerRadius = CGFloat(buttonCornerRadius)
            wordButton3.layer.maskedCorners = buttonMaskedCorners
            wordButton3.layer.borderColor = accentTextColor.cgColor
            wordButton3.layer.borderWidth = CGFloat(buttonBorderWidth)
            wordButton3.translatesAutoresizingMaskIntoConstraints = false
            buttonsView.addSubview(wordButton3)
            
            
            // Constraints
            NSLayoutConstraint.activate([
                buttonsView.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
                buttonsView.widthAnchor.constraint(equalTo: middleView.widthAnchor),
                buttonsView.centerYAnchor.constraint(equalTo: middleView.centerYAnchor),
                
                chooseLocalWordLabel.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor),
                chooseLocalWordLabel.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: 0.6),
                chooseLocalWordLabel.heightAnchor.constraint(equalToConstant: 50),
                chooseLocalWordLabel.topAnchor.constraint(equalTo: buttonsView.topAnchor),
                
                wordButton1.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor),
                wordButton1.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: 0.6),
                wordButton1.heightAnchor.constraint(equalToConstant: 50),
                wordButton1.topAnchor.constraint(equalTo: chooseLocalWordLabel.bottomAnchor, constant: 10),
                
                wordButton2.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor),
                wordButton2.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: 0.6),
                wordButton2.heightAnchor.constraint(equalToConstant: 50),
                wordButton2.topAnchor.constraint(equalTo: wordButton1.bottomAnchor, constant: 20),
                
                wordButton3.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor),
                wordButton3.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: 0.6),
                wordButton3.heightAnchor.constraint(equalToConstant: 50),
                wordButton3.topAnchor.constraint(equalTo: wordButton2.bottomAnchor, constant: 20),
                wordButton3.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor)
            ])
        } else if choosingState == "other choose" { // Display buttons in other language
            let buttonsView = UIView()
            buttonsView.backgroundColor = transparentColor
            buttonsView.translatesAutoresizingMaskIntoConstraints = false
            middleView.addSubview(buttonsView)
            
            let localLanguage = languageList[Int(UserDefaults.standard.string(forKey: localLanguageKey)!)!]
            
            let chooseLocalWordLabel = UITextView()
            chooseLocalWordLabel.contentInsetAdjustmentBehavior = .automatic
            chooseLocalWordLabel.textAlignment = NSTextAlignment.center
            chooseLocalWordLabel.textColor = mainTextColor
            chooseLocalWordLabel.font = UIFont(name: mainFont, size: 20.0)
            chooseLocalWordLabel.backgroundColor = transparentColor
            chooseLocalWordLabel.text = "select \(database[otherIndex][localLanguage]!):"
            chooseLocalWordLabel.isScrollEnabled = false
            chooseLocalWordLabel.isEditable = false
            chooseLocalWordLabel.isSelectable = false
            chooseLocalWordLabel.translatesAutoresizingMaskIntoConstraints = false
            buttonsView.addSubview(chooseLocalWordLabel)
            
            let randomInt1 = otherIndex
            
            var randomInt2 = Int.random(in: 0..<database.count)
            while randomInt2 == randomInt1 {
                randomInt2 = Int.random(in: 0..<database.count)
            }
            
            var randomInt3 = Int.random(in: 0..<database.count)
            while (randomInt3 == randomInt1) || (randomInt3 == randomInt2) {
                randomInt3 = Int.random(in: 0..<database.count)
            }
            
            let arrayToRandomizeButtonLabels = [otherIndex, randomInt2, randomInt3].shuffled()
            
            let wordButton1 = UIButton(type: .system)
            wordButton1.tag = arrayToRandomizeButtonLabels[0]
            wordButton1.addTarget(self, action: #selector(localWordButtonSelected), for: .touchUpInside)
            wordButton1.setTitle(database[arrayToRandomizeButtonLabels[0]][languageList[otherLanguage]], for: .normal)
            wordButton1.titleLabel?.textAlignment = .center
            wordButton1.titleLabel?.font = UIFont(name: mainFont, size: CGFloat(buttonFontSize))
            wordButton1.setBackgroundColor(buttonColor, forState: .normal)
            wordButton1.setBackgroundColor(selectedButtonColor, forState: .selected)
            wordButton1.setTitleColor(mainTextColor, for: .normal)
            wordButton1.setTitleColor(mainTextColor, for: .selected)
            wordButton1.layer.cornerRadius = CGFloat(buttonCornerRadius)
            wordButton1.layer.maskedCorners = buttonMaskedCorners
            wordButton1.layer.borderColor = accentTextColor.cgColor
            wordButton1.layer.borderWidth = CGFloat(buttonBorderWidth)
            wordButton1.translatesAutoresizingMaskIntoConstraints = false
            buttonsView.addSubview(wordButton1)
            
            let wordButton2 = UIButton(type: .system)
            wordButton2.tag = arrayToRandomizeButtonLabels[1]
            wordButton2.addTarget(self, action: #selector(localWordButtonSelected), for: .touchUpInside)
            wordButton2.setTitle(database[arrayToRandomizeButtonLabels[1]][languageList[otherLanguage]], for: .normal)
            wordButton2.titleLabel?.textAlignment = .center
            wordButton2.titleLabel?.font = UIFont(name: mainFont, size: CGFloat(buttonFontSize))
            wordButton2.setBackgroundColor(buttonColor, forState: .normal)
            wordButton2.setBackgroundColor(selectedButtonColor, forState: .selected)
            wordButton2.setTitleColor(mainTextColor, for: .normal)
            wordButton2.setTitleColor(mainTextColor, for: .selected)
            wordButton2.layer.cornerRadius = CGFloat(buttonCornerRadius)
            wordButton2.layer.maskedCorners = buttonMaskedCorners
            wordButton2.layer.borderColor = accentTextColor.cgColor
            wordButton2.layer.borderWidth = CGFloat(buttonBorderWidth)
            wordButton2.translatesAutoresizingMaskIntoConstraints = false
            buttonsView.addSubview(wordButton2)
            
            let wordButton3 = UIButton(type: .system)
            wordButton3.tag = arrayToRandomizeButtonLabels[2]
            wordButton3.addTarget(self, action: #selector(localWordButtonSelected), for: .touchUpInside)
            wordButton3.setTitle(database[arrayToRandomizeButtonLabels[2]][languageList[otherLanguage]], for: .normal)
            wordButton3.titleLabel?.textAlignment = .center
            wordButton3.titleLabel?.font = UIFont(name: mainFont, size: CGFloat(buttonFontSize))
            wordButton3.setBackgroundColor(buttonColor, forState: .normal)
            wordButton3.setBackgroundColor(selectedButtonColor, forState: .selected)
            wordButton3.setTitleColor(mainTextColor, for: .normal)
            wordButton3.setTitleColor(mainTextColor, for: .selected)
            wordButton3.layer.cornerRadius = CGFloat(buttonCornerRadius)
            wordButton3.layer.maskedCorners = buttonMaskedCorners
            wordButton3.layer.borderColor = accentTextColor.cgColor
            wordButton3.layer.borderWidth = CGFloat(buttonBorderWidth)
            wordButton3.translatesAutoresizingMaskIntoConstraints = false
            buttonsView.addSubview(wordButton3)
            
            
            // Constraints
            NSLayoutConstraint.activate([
                buttonsView.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
                buttonsView.widthAnchor.constraint(equalTo: middleView.widthAnchor),
                buttonsView.centerYAnchor.constraint(equalTo: middleView.centerYAnchor),
                
                chooseLocalWordLabel.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor),
                chooseLocalWordLabel.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: 0.6),
                chooseLocalWordLabel.heightAnchor.constraint(equalToConstant: 50),
                chooseLocalWordLabel.topAnchor.constraint(equalTo: buttonsView.topAnchor),
                
                wordButton1.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor),
                wordButton1.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: 0.6),
                wordButton1.heightAnchor.constraint(equalToConstant: 50),
                wordButton1.topAnchor.constraint(equalTo: chooseLocalWordLabel.bottomAnchor, constant: 10),
                
                wordButton2.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor),
                wordButton2.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: 0.6),
                wordButton2.heightAnchor.constraint(equalToConstant: 50),
                wordButton2.topAnchor.constraint(equalTo: wordButton1.bottomAnchor, constant: 20),
                
                wordButton3.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor),
                wordButton3.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: 0.6),
                wordButton3.heightAnchor.constraint(equalToConstant: 50),
                wordButton3.topAnchor.constraint(equalTo: wordButton2.bottomAnchor, constant: 20),
                wordButton3.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor)
            ])
        } else if choosingState == "local wait" {
            let waitLabel = UITextView()
            waitLabel.contentInsetAdjustmentBehavior = .automatic
            waitLabel.textAlignment = NSTextAlignment.center
            waitLabel.textColor = mainTextColor
            waitLabel.font = UIFont(name: mainFont, size: CGFloat(buttonFontSize))
            waitLabel.backgroundColor = transparentColor
            waitLabel.text = "other player is guessing your word..."
            waitLabel.isScrollEnabled = false
            waitLabel.isEditable = false
            waitLabel.isSelectable = false
            waitLabel.translatesAutoresizingMaskIntoConstraints = false
            middleView.addSubview(waitLabel)
            NSLayoutConstraint.activate([
                waitLabel.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
                waitLabel.widthAnchor.constraint(equalTo: middleView.widthAnchor),
                waitLabel.centerYAnchor.constraint(equalTo: middleView.centerYAnchor)
            ])
        } else {
            print("Unknown choosing state: \(choosingState)")
        }
    }
    @objc func localWordButtonSelected(sender: UIButton!) {
        if choosingState == "local choose" {
            var indexDataToSendString = "Index: \(sender.tag)"
            let indexData = Data(bytes: &indexDataToSendString, count: MemoryLayout.size(ofValue: indexDataToSendString))
            self.sendData(toAllPlayers: indexData, with: GKMatch.SendDataMode.reliable)
            
            choosingState = "local wait"
            updateMiddleView()
        } else if choosingState == "other choose" {
            if sender.tag == otherIndex { // if the guess is correct
                score = score + 1
                scoreLabel.text = "score: \(score)"
                
                var scoreDataToSendString = "Score: \(score)"
                let scoreData = Data(bytes: &scoreDataToSendString, count: MemoryLayout.size(ofValue: scoreDataToSendString))
                self.sendData(toAllPlayers: scoreData, with: GKMatch.SendDataMode.reliable)
            }
            
            // Now change view to select for the other player
            choosingState = "local choose"
            updateMiddleView()
        }
    }
    
    
    // Sending and Receiving data
    struct GamePacket: Codable {
        var receivedData: String
    }
    func sendData(toAllPlayers data: Data, with mode: GKMatch.SendDataMode) {
        var remotePlayerArray = [GKPlayer]()

        let playerArray = myMatch.players
        let match = myMatch
        if match == myMatch, playerArray == myMatch.players {
            for player in playerArray {
                if (playerArray.contains(player)) == false {
                    print("appending")
                    remotePlayerArray.append(player)
                }
            }
            do {
                print("Should send!")
                try myMatch.send(data, to: myMatch.players, dataMode: GKMatch.SendDataMode.reliable)
                print("Successful?")
            }
            catch {
                print("connectionError")
                myMatch.disconnect()
            }
        }
    }
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        print("RECEIVING SOMETHING. Data = \(data)")
        if match == myMatch && myMatch.players.contains(player) { //If it is my match
            print("My match = \(myMatch.players)")
            
            let randomNumberReceived = decodeGamePacket(data: data as NSData)
            let randomNumberAsString = "\(randomNumberReceived!)"
            print(randomNumberAsString)
            let splittedUpData = randomNumberAsString.split{ !$0.isNumber } //{ !$0.isLetter } will keep everything except number and put it into an array
            print(splittedUpData)
            
            var niceString = "0"
            if splittedUpData.count == 1 || splittedUpData.count > 0 {
                niceString = "\(splittedUpData[0])"
            } else {
                print("Array not adding? Splitted up data count = \(splittedUpData.count)")
                niceString = "0"
            }
            
            
            if randomNumberAsString.contains("Score:") {
                score = Int(niceString)!
                scoreLabel.text = "score: \(score)"
            } else if randomNumberAsString.contains("Index:") {
                otherIndex = Int(niceString)!
                
                choosingState = "other choose"
                updateMiddleView()
            } else if randomNumberAsString.contains("Language:") {
                otherLanguage = Int(niceString)!
                languagesLabel.text = "\(languageList[Int(UserDefaults.standard.string(forKey: localLanguageKey)!)!]) <--> \(languageList[otherLanguage])"
            }
        } else {
            print("Received something but not from myMatch.")
            print(data)
        }
    }
    func decodeGamePacket(data: NSData) -> GamePacket? {
        var tempBuffer: GamePacket? = nil
        data.getBytes(&tempBuffer, length: MemoryLayout<GamePacket>.size)
        return tempBuffer
    }
    
    
    //Match Maker functions
    func presentMatchMaker() {
        guard GKLocalPlayer.local.isAuthenticated else {
            return
        }
      
        let request = GKMatchRequest()
      
        request.minPlayers = 2
        request.maxPlayers = 2
        request.inviteMessage = "Would you like to play Word Erp?"
      
        let vc = GKMatchmakerViewController(matchRequest: request)!
        vc.matchmakerDelegate = self
        self.present(vc, animated: true)
    }
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        print("failed to make match")
        viewController.dismiss(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        if matchStarted == false && match.expectedPlayerCount == 0 {
            // Setting the match
            matchStarted = true
            myMatch = match
            myMatch.delegate = self
            
            //Find Player Alias
            print("Looking up \(match.players.count) players...")
            print(match.players[0].alias)
            
            // Setting the Player
            playersDict = NSMutableDictionary(capacity: 2)
            playersDict.setObject(match.players[0], forKey: match.players[0].teamPlayerID as NSCopying)
            
            // Starting the Game
            teammateLabel.text = "teammate: \(match.players[0].alias)"
            self.dismiss(animated: true, completion: nil)
            runCountDownTimer()
        }
    }
    
    
    // Creating Match
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        if (match != match) { return }
        
        switch (state) {
            case GKPlayerConnectionState.connected:
                // handle a new player connection.
                print("Player connected!")
                connectionState = "connected"
                if matchStarted == false && match.expectedPlayerCount == 0 {
                    // Setting the match
                    matchStarted = true
                    myMatch = match
                    myMatch.delegate = self
                    
                    //Find Player Alias
                    print("Looking up \(match.players.count) players...")
                    print(match.players[0].alias)
                    
                    // Setting the Player
                    playersDict = NSMutableDictionary(capacity: 2)
                    playersDict.setObject(match.players[0], forKey: match.players[0].teamPlayerID as NSCopying)
                    
                    // Starting the Game
                    teammateLabel.text = "teammate: \(match.players[0].alias)"
                    self.dismiss(animated: true, completion: nil)
                    runCountDownTimer()
                }
                
                break
            case GKPlayerConnectionState.disconnected:
                // a player just disconnected.
                print("Player disconnected!");
                connectionState = "disconnected"
                matchStarted = false
                gameOver()
                
                break
            case GKPlayerConnectionState.unknown:
                print("Player connection state is unknown.")
                connectionState = "unknown"
            @unknown default:
                print("Default")
                connectionState = "default"
        }
    }
    func match(_ match: GKMatch, didFailWithError error: Error?) {
        if match != match { return }
        
        if let error = error {
            print("Failed. \(error)")
        }
        matchStarted = false
    }
    
    
    func runCountDownTimer() {
        choosingState = "count down"
        updateMiddleView()
        
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateCountDownTimer)), userInfo: nil, repeats: true)
    }
    @objc func updateCountDownTimer() {
        if countDownSeconds == 0 {
            countDownTimer.invalidate()
            choosingState = "local choose"
            updateMiddleView()
            gameTimerLabel.isHidden = false
            runGameTimer()
            
            // Language
            var languageDataToSendString = "Language: \(Int(UserDefaults.standard.string(forKey: localLanguageKey)!)!)"
            print(languageDataToSendString)
            let languageData = Data(bytes: &languageDataToSendString, count: MemoryLayout.size(ofValue: languageDataToSendString))
            self.sendData(toAllPlayers: languageData, with: GKMatch.SendDataMode.reliable)
        } else {
            countDownSeconds -= 1
            countDownLabel.text = "\(countDownSeconds)"
        }
    }
    
    func runGameTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateGameTimer)), userInfo: nil, repeats: true)
    }
    @objc func updateGameTimer() {
        if gameSeconds == 0 {
            gameOver()
        } else {
            gameSeconds -= 1
            if gameSeconds == 60 {
                gameTimerLabel.text = "1:00"
            } else if gameSeconds < 10 {
                gameTimerLabel.text = "0:0\(gameSeconds)"
            } else {
                gameTimerLabel.text = "0:\(gameSeconds)"
            }
        }
    }
    
    
    func gameOver() {
        // End the timer
        gameTimer.invalidate()
        
        // Disconnect GameKit
        connectionState = "game over"
        myMatch.disconnect()
        myMatch.delegate = nil
        
        // Save the score and high score
        let highScore = UserDefaults.standard.integer(forKey: highScoreKey)
        if score > highScore {
            UserDefaults.standard.set(score, forKey: highScoreKey)
            UserDefaults.standard.set(score, forKey: highScoreKey)
        } else {
            UserDefaults.standard.set(score, forKey: highScoreKey)
        }
        
        // Dismiss
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
