//
//  LogInViewController.swift
//  StoneBridge Well Inspection
//
//  Created by John Sanchez on 11/8/20.
//

import UIKit
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
extension LogInViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        if userText.text?.isEmpty == false && passText.text?.isEmpty == false{
            
            if userText.text == "" || passText.text == "" { //if any of the two are empty
            
                loginButton.isEnabled = false
                let alert = UIAlertController(title: "ERROR", message: "Missing text fields", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            } else {
               //runs through database to check if username and password are valid
            }
            
        } else {
            //turns off button initially
            loginButton.isEnabled = false
        }
    }
}

class LogInViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var passText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
        userText.delegate = self
        passText.delegate = self
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
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
