//
//  LoginClienteViewController.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 25/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class LoginClienteViewController: UIViewController, UITextFieldDelegate {

    // MARK: Declarações
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    
    let clienteModel = ClienteModel()
    
    // MARK: Métodos
    override func viewDidLoad() {
        super.viewDidLoad()

        //Teste
//        emailTextField.text = "jose@gmail.com"
//        senhaTextField.text = "j0$3"
        
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
        let retorno = clienteModel.verifyLoginCliente(emailTextField.text!, senha: senhaTextField.text!)
        
        //Se existir, loga o cliente e chama a View de Perfil
        if (retorno) {
            
            //Salva cliente logado
            UserDefaults.standard.set(emailTextField.text!, forKey: "emailCliente")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "PerfilViewController") as! PerfilViewController
            self.navigationController?.pushViewController(controller, animated: true)
            
        } else {
            
            //Mostra alerta de mensagem
            Alert(controller: self).showError(message: "Cliente não encontrado!", handler : { action in
                self.dismiss(animated: false)
            })
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}
