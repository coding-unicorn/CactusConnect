//
//  Extensions.swift
//  Cactus Connect
//
//  Created by Admin on 2/12/22.
//

import Foundation
import UIKit


extension UIButton {
  func setBackgroundColor(_ color: UIColor, forState controlState: UIControl.State) {
    let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in
      color.setFill()
      UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1)).fill()
    }
    setBackgroundImage(colorImage, for: controlState)
  }
}


extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
}


extension CATransition {
    func fadeTransition() -> CATransition {
        let transition = CATransition()
        transition.duration = 1
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromBottom
        //let transition = CATransition()//CABasicAnimation.init(keyPath: "backgroundColor")
        //transition.duration = 1
        //transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        //transition.toValue = UIColor.black.cgColor
        //transition.fromValue = UIColor.red.cgColor
        //transition.
        
        return transition
    }
}
