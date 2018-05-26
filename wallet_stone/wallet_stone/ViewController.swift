//
//  ViewController.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 24/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let data = "2018/5/23"
        
        //Carrega dados da cotação do Dólar
        let apiCall = APIManager.shared.fetchCotacaoDolarFromApi()
        apiCall.then {
            dolares -> Void in
            
            print(dolares[0].cotacaoCompra ?? 0)
            print(dolares[0].cotacaoVenda ?? 0)
            print(dolares[0].dataHoraCotacao ?? "")
            
        }.catch { error
            -> Void in
        }
        
        //Carrega dados da cotação do Bitcoin pela data
        let apiCall2 = APIManager.shared.fetchCotacaoBtcFromApi(data)
        apiCall2.then {
            bitcoins -> Void in
            
            print(bitcoins[0].opening ?? 0)
            print(bitcoins[0].closing ?? 0)
            print(bitcoins[0].quantity ?? 0)
            print(bitcoins[0].avg_price ?? 0)
            print(bitcoins[0].date ?? "")
            
            }.catch { error
                -> Void in
        }
    }
    
    @IBAction func registroCliente(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RegistrarClienteViewController") as! RegistrarClienteViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func loginCliente(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginClienteViewController") as! LoginClienteViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

