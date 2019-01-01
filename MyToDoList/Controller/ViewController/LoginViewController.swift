//
//  LoginViewController.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 12/11/18.
//  Copyright © 2018 myw. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    struct KeychainConfiguration {
        static let serviceName = "OneList"
        static let accessGroup: String? = nil
    }
    
    var tap: UITapGestureRecognizer!

    @IBOutlet var masterView: DesignViewController!
    @IBOutlet weak var popupWindow: DesignViewController!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordHint: UITextField!
    @IBOutlet weak var delete: UIButton!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    var passwordItems: [KeychainPasswordItem] = []
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    let storedUser = "OneList"
    let newAccountName = "OneList"
    var catVC : CategoryViewController?
    var invalidPasswordAttempt : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        passwordTextField.becomeFirstResponder()
        // For Test Run - Cleanup defaults
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
//        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
        // ******
        
        //Set the Color Scheme and Layout
        passwordTextField.layer.cornerRadius = 30
        loginButton.backgroundColor = UIColor.flatPowderBlueDark
        loginButton.tintColor = UIColor.init(complementaryFlatColorOf: .flatPowderBlueDark)
        popupWindow.backgroundColor = UIColor.flatPowderBlue
        loginLabel.backgroundColor = UIColor.flatPowderBlueDark
        loginLabel.tintColor = UIColor.init(complementaryFlatColorOf: .flatPowderBlueDark)
        
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLoginKey")
        
        //Password Text Field Anchors
        passwordTextField.topAnchor.constraint(equalTo: (passwordTextField.superview?.topAnchor)!, constant: 0).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: (passwordTextField.superview?.leadingAnchor)!).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: (passwordTextField.superview?.trailingAnchor)!, constant: 0).isActive = true
        
        passwordHint.leadingAnchor.constraint(equalTo: (passwordHint.superview?.leadingAnchor)!).isActive = true
        passwordHint.trailingAnchor.constraint(equalTo: (passwordHint.superview?.trailingAnchor)!, constant: 0).isActive = true
        
        loginButton.centerXAnchor.constraint(equalTo: (loginButton.superview?.centerXAnchor)!).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordHint.bottomAnchor, constant: 7).isActive = true

        // 2
        if hasLogin {
            loginButton.setTitle("Login", for: .normal)
            loginButton.tag = loginButtonTag
            
            //Hide Password Hint
            passwordHint.isHidden = true
            passwordHint.frame.origin.y = passwordTextField.frame.origin.y
            passwordHint.topAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: 0).isActive = true

            //Set Superview Height
        passwordTextField.superview?.heightAnchor.constraint(equalToConstant: 120).isActive = true
        } else {
            //Show Password Hint
            passwordHint.isHidden = false
            passwordHint.frame.origin.y = passwordTextField.frame.origin.y + passwordTextField.frame.height + 3
            passwordHint.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 3).isActive = true

            loginButton.setTitle("Create", for: .normal)
            loginButton.tag = createLoginButtonTag
            //Set Superview Height
            passwordTextField.superview?.heightAnchor.constraint(equalToConstant: 200).isActive = true
        }
        
        
        print("Store user \(storedUser)")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    passwordTextField.becomeFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        passwordTextField.becomeFirstResponder()
        tap = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.cancelsTouchesInView = false
        tap.delegate = self
        masterView.window?.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        passwordTextField.becomeFirstResponder()
         self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Login Button Action for Create and Login
    @IBAction func loginAction(_ sender: Any) {
        
        // Check Password
        guard let newPassword = passwordTextField.text,
            !newAccountName.isEmpty,
            !newPassword.isEmpty
        else {
            showLoginFailedAlert(alertMessage: "Invalid password", showHint: false)
            return
        }
        
        //passwordTextField.resignFirstResponder()
        
        //Create Password Action
        if (sender as AnyObject).tag == createLoginButtonTag {
            let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
            if !hasLoginKey {
                UserDefaults.standard.setValue(storedUser, forKey: "username")
                UserDefaults.standard.setValue(passwordHint.text, forKey: "passwordhint")
            }
            
            //Create KeyChain Entry
            do {
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,account: storedUser, accessGroup: KeychainConfiguration.accessGroup)
                    
                // Save the password for the new item.
                try passwordItem.savePassword(newPassword)
            } catch {
                fatalError("Error updating keychain - \(error)")
            }
            
            UserDefaults.standard.set(true, forKey: "hasLoginKey")
            loginButton.tag = loginButtonTag
            self.dismiss(animated: true, completion: nil)
            catVC?.gotoItem()
        } else if (sender as AnyObject).tag == loginButtonTag {
            if checkLogin(username: newAccountName, password: newPassword) {
                self.dismiss(animated: true, completion: nil)
                catVC?.gotoItem()
            } else {
                invalidPasswordAttempt += 1
                showLoginFailedAlert(alertMessage: "Incorrect Password", showHint: invalidPasswordAttempt >= 3 )
                 //passwordTextField.becomeFirstResponder()
                passwordTextField.text = ""
                if passwordTextField.text?.count == 0 {
                    passwordTextField.becomeFirstResponder()
                }
               
            }
        }
    }

    func checkLogin(username: String, password: String) -> Bool {
        guard username == UserDefaults.standard.value(forKey: "username") as? String else {
            return false
        }
        
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,account: username, accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return password == keychainPassword
        } catch {
            showLoginFailedAlert(alertMessage: "\(error)", showHint: false)
            return false
        }
    }
}

//Gesture Implementation + Login Alert
extension LoginViewController: UIGestureRecognizerDelegate {
    
    
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: popupWindow)
        
        print("Inside gesture \(location)")
        if popupWindow.point(inside: location, with: nil) {
            return false
        }
        else {
            return true
        }
    }
    
    @objc private func onTap(sender: UITapGestureRecognizer) {
        //masterView.window?.removeGestureRecognizer(sender)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func showLoginFailedAlert(alertMessage: String, showHint: Bool) {
        var newAlertMessage: String
        if showHint {
            let pwdHint = UserDefaults.standard.value(forKey: "passwordhint")
            newAlertMessage = alertMessage + "\n Password Hint : \(pwdHint)"
        } else {
            newAlertMessage = alertMessage
        }

        let alertView = UIAlertController(title: "Login Problem", message: newAlertMessage, preferredStyle:. alert)
        let okAction = UIAlertAction(title: "Foiled Again!", style: .default)
        alertView.addAction(okAction)
        present(alertView, animated: true)
    }
}
