//
//  LoginClienteViewController.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 25/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class LoginClienteViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.text = "jose@gmail.com"
        senhaTextField.text = "j0$3"
        
        emailTextField.delegate = self
        senhaTextField.delegate = self
    }

    @IBAction func retornar(_ sender: Any) {
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        }
    }
    
    @IBAction func loginCliente(_ sender: Any) {
        
        //Verifica se o Cliente existe no Realm
        let retorno = verifyLoginCliente(emailTextField.text!, senha: senhaTextField.text!)
        
        //Se existir, loga o cliente e chama a View de Perfil
        if (retorno) {
            
            //Salva cliente logado
            UserDefaults.standard.set(emailTextField.text!, forKey: "emailCliente")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "PerfilViewController") as! PerfilViewController
            self.navigationController?.pushViewController(controller, animated: true)
            
        } else {
            //Cliente não encontrado
            let alertController = UIAlertController(title: "ATENÇÃO", message: "Cliente não encontrado!", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
