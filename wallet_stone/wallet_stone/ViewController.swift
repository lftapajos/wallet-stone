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
        
        //Remove Moedas
        deleteMoeda()
        
        //Adiciona Moedas
        addMoeda("Brita", quantidade: 0)
        addMoeda("BTC", quantidade: 0)
        
        let apiCall = APIManager.shared.fetchCotacaoDolarFromApi()
        apiCall.then {
            dolares -> Void in
            
            //Adiciona nova Cotação de Brita
            addCotacaoBrita("Brita", cotacaoCompra: dolares[0].cotacaoCompra!, cotacaoVenda: dolares[0].cotacaoVenda!, dataHoraCotacao: dolares[0].dataHoraCotacao!)
            
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

