//
//  EmailViewcontroller.swift
//  quiz
//
//  Created by mac on 23/01/25.
//

import UIKit
import FirebaseAuth


class EmailViewcontroller: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordButton: UITextField!
    @IBOutlet weak var emailButton: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let email = emailButton.text, !email.isEmpty,
                      let password = passwordButton.text, !password.isEmpty else {
                    // Display an alert for missing or empty fields
                    let alert = UIAlertController(title: "Error", message: "Please enter email and password.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                    return
                }

                // Attempt to log in the user
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        // Handle login error
                        print("Login Error: \(error.localizedDescription)")
                        let alert = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        // Login successful
                        print("Login Successful")
                        // Perform any necessary actions after successful login
                        // (e.g., transition to the home screen)
                        self.performSegue(withIdentifier: "showHomeScreen", sender: self)
                    }
                }
            }
        }
    
    
  
