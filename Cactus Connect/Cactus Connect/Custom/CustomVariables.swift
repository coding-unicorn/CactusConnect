//
//  CustomVariables.swift
//  Cactus Connect
//
//  Created by Admin on 2/12/22.
//

import Foundation
import UIKit


// Colors
let transparentColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.00)
let backgroundColors = UIColor(red: 0.61, green: 0.57, blue: 0.47, alpha: 1.00) // #9c9177
let selectedButtonColor = transparentColor
let mainTextColor = UIColor(red: 0.40, green: 0.35, blue: 0.29, alpha: 1.00) // #655949
let accentTextColor = UIColor(red: 0.31, green: 0.33, blue: 0.30, alpha: 1.00) // ##50554D
let buttonTextColor = mainTextColor
let buttonColor = transparentColor
let buttonBorderColor = accentTextColor


// Fonts
let mainFont = "Yanone Kaffeesatz Regular"
let titleFontSize = 36
let textFontSize = 16
let buttonFontSize = 30


// Transitions
let presentTransition = UIModalTransitionStyle.partialCurl
let dismissTransition = CATransition().fadeTransition()


// Button Corners
let buttonCornerRadius = 20
let buttonMaskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMinYCorner)
let buttonBorderWidth = 4


// Images
let logo = UIImage(named: "Cactus Connect Logo")
let charactersArray = [
    UIImage(named: "Cactus Connect Character")
    , UIImage(named: "Cactus Connect Character 1")
    , UIImage(named: "Cactus Connect Character 2")
    , UIImage(named: "Cactus Connect Character 3")
    , UIImage(named: "Cactus Connect Character 4")
]


// Keys
let streakKey = "CactusConnectStreak"
let lastUsedTimeKey = "CactusConnectLastUsedTime"
let localLanguageKey = "CactusConnectLocalLanguage"
let highScoreKey = "CactusConnectHighScore"
let lastScoreKey = "CactusConnectLastScore"
let leaderboardIDKey = "CactusConnectLeaderboard"
