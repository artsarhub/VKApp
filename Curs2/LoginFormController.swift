//
//  LoginFormController.swift
//  Curs2
//
//  Created by Артём Сарана on 01.12.2020.
//

import UIKit

class LoginFormController: UIViewController {
    
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBAction func logout(_ segue: UIStoryboardSegue) {
        self.loginTF.text = ""
        self.passwordTF.text = ""
    }
    
    private func checkUser() -> Bool {
        guard let username = self.loginTF.text,
              let password = self.passwordTF.text
        else { return false }
        return username == "1" && password == "1"
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Error",
                                                message: "Неверные данные",
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Close",
                                        style: .cancel)
        { _ in
            self.loginTF.text = ""
            self.passwordTF.text = ""
        }
        alertController.addAction(alertAction)
        present(alertController,
                animated: true,
                completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if !checkUser() {
            showAlert()
            return false
        } else {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.isHidden = false
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
