//
//  Functions.swift
//  Cactus Connect
//
//  Created by Admin on 2/12/22.
//

import Foundation
import UIKit
import GameKit


func presentScreen(fromViewController: UIViewController, toViewController: UIViewController) {
    fromViewController.modalTransitionStyle = presentTransition
    toViewController.modalPresentationStyle = .fullScreen
    fromViewController.present(toViewController, animated: true, completion: nil)
}


func goBack(fromViewController: UIViewController) {
    fromViewController.view.window!.layer.add(dismissTransition, forKey: nil)
    fromViewController.dismiss(animated: false, completion: nil)
}
