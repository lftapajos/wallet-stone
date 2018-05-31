//
//  RegistrarClienteViewController.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 25/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class RegistrarClienteViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nomeTextField.text = "Jose"
        emailTextField.text = "jose@gmail.com"
        senhaTextField.text = "j0$3"
        
        nomeTextField.delegate = self
        emailTextField.delegate = self
        senhaTextField.delegate = self
    }

    @IBAction func retornar(_ sender: Any) {
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        }
    }
    
    @IBAction func registrarCliente(_ sender: Any) {
        
        //Salva novo Cliente no Realm com saldo inicial de 100 mil reais
        let confirma = addCliente(nomeTextField.text!, email: emailTextField.text!, senha: senhaTextField.text!, saldo: 100000)
        
        //Confirma registro
        if (confirma) {
            
            //Mostra alerta de mensagem
            Alert(controller: self).showError(message: "Cliente registrado com sucesso!", handler : { action in
                self.navigationController?.popViewController(animated: true)
            })
        
        } else {
            
            //Cliente já existente
            //Mostra alerta de mensagem
            Alert(controller: self).showError(message: "Cliente já existente!", handler : { action in
                self.dismiss(animated: false)
            })
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
