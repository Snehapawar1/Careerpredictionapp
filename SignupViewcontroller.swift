//
//  SignupViewcontroller.swift
//  quiz
//
//  Created by mac on 23/01/25.
//

import UIKit
import Firebase

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
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
