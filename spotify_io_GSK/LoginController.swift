//
//  LoginController.swift
//  spotify_io_GSK
//
//  Created by coding on 03/10/2023.
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
 
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.textColor = .white
        passwordLabel.textColor = .white
        
        self.view.backgroundColor = UIColor(named: "#191414")
    }


    @IBAction func loginAction(_ sender: Any) {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            showAlert(title: "Erreur", message: "Veuillez remplir tous les champs.")
            return
        }

        if username == "toto" && password == "toto" {
            if let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainTabBarController") as? UITabBarController {
                navigationItem.hidesBackButton = true
                navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                navigationController?.setViewControllers([tabBarController], animated: true)
            }

        } else {
            showAlert(title: "Erreur", message: "Nom d'utilisateur ou mot de passe incorrect.")
        }
    }

    
        
    func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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

