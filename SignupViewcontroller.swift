//
//  SignupViewcontroller.swift
//  quiz
//
//  Created by mac on 23/01/25.
//

import UIKit
import FirebaseAuth

class SignupViewcontroller: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var passwordButton: UITextField!
    @IBOutlet weak var mailButton: UITextField!
    @IBOutlet weak var nameButton: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        guard let email = mailButton.text, !email.isEmpty,
                      let password = passwordButton.text, !password.isEmpty,
                      let name = nameButton.text, !name.isEmpty else {
                    // Display an alert for missing or empty fields
                    let alert = UIAlertController(title: "Error", message: "Please fill in all fields.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                    return
                }

                // Create a new user with email and password
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        // Handle error during user creation
                        print("Error creating user:", error)
                        let alert = UIAlertController(title: "Error", message: "Failed to create user: \(error.localizedDescription)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }

                    // User created successfully
                    print("User created successfully")

                    // Optionally, update the user's display name
                    let changeRequest = authResult?.user.createProfileChangeRequest()
                    changeRequest?.displayName = name
                    changeRequest?.commitChanges { error in
                        if let error = error {
                            print("Error updating user profile:", error)
                        } else {
                            print("User profile updated successfully")
                            // Perform any necessary actions after successful signup (e.g., transition to another screen)
                            // Example:
                            self.performSegue(withIdentifier: "showHomeScreen", sender: self)
                        }
                    }
                }
            }
        }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


