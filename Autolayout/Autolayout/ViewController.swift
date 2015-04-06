//
//  ViewController.swift
//  Autolayout
//
//  Created by LiuXin on 4/5/15.
//  Copyright (c) 2015 LiuXin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    var loggedInUser: User? { didSet { updateUI() } }
    
    var secure: Bool = false { didSet{ updateUI() } }

    private func updateUI(){
        passwordField.secureTextEntry = secure
        passwordLabel.text = secure ? "Secured Password" : "Password"
        
        nameLabel.text = loggedInUser?.name
        companyLabel.text = loggedInUser?.company
        image = loggedInUser?.image
    }
    
    @IBAction func toggleSecurity() {
        secure = !secure
    }
    
    var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            if let constrainedView = imageView {
                if let newImage = newValue {
                    aspectRationConstraint = NSLayoutConstraint(
                        item: constrainedView,
                        attribute: .Width,
                        relatedBy: .Equal,
                        toItem: constrainedView,
                        attribute: .Height,
                        multiplier: newImage.aspectRation,
                        constant: 0)
                } else
                {
                    aspectRationConstraint = nil
                }
            }
        }
    }
    
    var aspectRationConstraint: NSLayoutConstraint? {
        willSet {
            if let existingConstraint = aspectRationConstraint {
                view.removeConstraint(existingConstraint)
            }
        }
        
        didSet {
            if let newConstraint = aspectRationConstraint {
                view.addConstraint(newConstraint)
            }
        }
    }
    
    @IBAction func login() {
        loggedInUser = User.login(usernameField.text ?? "", password: passwordField.text ?? "")
    }
    
}

extension User {
    var image: UIImage? {
        if let image = UIImage(named: login){
            return image
        } else {
            return UIImage(named: "unknown_user")
        }
    }
}

extension UIImage {
    var aspectRation: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}



