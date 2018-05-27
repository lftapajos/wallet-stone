//
//  LoginClienteViewController.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 25/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class LoginClienteViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.text = "jose@gmail.com"
        senhaTextField.text = "j0$3"
    }

    @IBAction func retornar(_ sender: Any) {
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        }
    }
    
    @IBAction func loginCliente(_ sender: Any) {
        
        //Pesquisa se o Cliente existe no Realm
        let retorno = verifyLoginCliente(emailTextField.text!, senha: senhaTextField.text!)
        
        if (retorno) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "PerfilViewController") as! PerfilViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
