//
//  RegistrarClienteViewController.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 25/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class RegistrarClienteViewController: UIViewController {

    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nomeTextField.text = "Pedro"
        emailTextField.text = "pedro@gmail.com"
        senhaTextField.text = "p3dr0"
    }

    @IBAction func retornar(_ sender: Any) {
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        }
    }
    
    @IBAction func registrarCliente(_ sender: Any) {
        
        //Salva novo Cliente no Realm
        addCliente(nomeTextField.text!, email: emailTextField.text!, senha: senhaTextField.text!, saldo: 100000)
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "EntradaViewController") as! EntradaViewController
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
