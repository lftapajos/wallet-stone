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
        
        //Salva novo Cliente no Realm
        let confirma = addCliente(nomeTextField.text!, email: emailTextField.text!, senha: senhaTextField.text!, saldo: 100000)
        
        //Confirma registro
        if (confirma) {
            let alertController = UIAlertController(title: "ATENÇÃO", message: "Cliente registrado com sucesso!", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        
        } else {
            //Cliente já existente
            
            let alertController = UIAlertController(title: "ATENÇÃO", message: "Cliente já existente!", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
                //self.navigationController?.popViewController(animated: true)
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
