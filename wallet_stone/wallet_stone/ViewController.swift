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
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        print("App Path: \(dirPaths)")
        
        //Remove Moedas
        deleteMoeda()
        
        //Adiciona Moedas
        //addMoeda("Brita", cotacaoCompra: <#T##Double#>, cotacaoVenda: <#T##Double#>, dataHoraCotacao: <#T##String#>)
        
        //addMoeda("Brita", quantidade: 0)
        //addMoeda("BTC", quantidade: 0)
        
        let data = "05-23-2018"
        
        let apiCall = APIManager.shared.fetchCotacaoDolarFromApi(data)
        apiCall.then {
            dolares -> Void in
            
            //Adiciona nova Cotação de Brita
            //addCotacaoBrita("Brita", cotacaoCompra: dolares[0].cotacaoCompra!, cotacaoVenda: dolares[0].cotacaoVenda!, dataHoraCotacao: dolares[0].dataHoraCotacao!)
            
            //Adiciona cotação de Moeda
            addMoeda("Brita", cotacaoCompra: dolares[0].cotacaoCompra!, cotacaoVenda: dolares[0].cotacaoVenda!, dataHoraCotacao: dolares[0].dataHoraCotacao!)
            
//            let apiCall2 = APIManager.shared.fetchCotacaoBtcFromApi()
//            apiCall2.then {
//                bitcoins -> Void in
//                
//                //Adiciona nova Cotação de Brita
//                //addCotacaoBrita("Brita", cotacaoCompra: dolares[0].cotacaoCompra!, cotacaoVenda: dolares[0].cotacaoVenda!, dataHoraCotacao: dolares[0].dataHoraCotacao!)
//                
//                //let cotacaoCompra = Double((bitcoins[0].buy! as NSString).doubleValue)
//                //let cotacaoVenda = Double((bitcoins[0].sell! as NSString).doubleValue)
//                
//                //Adiciona cotação de Moeda
//                //addMoeda("BTC", cotacaoCompra: cotacaoCompra, cotacaoVenda: cotacaoVenda, dataHoraCotacao: "\(bitcoins[0].date!)")
//                
//                }.catch { error
//                    -> Void in
//                }
            
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

