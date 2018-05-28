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
        
        //Remove todas as Moedas antes de recuperar as novas cotações diárias
        deleteMoeda()
        
        let resultDate = "05-23-2018"
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM-dd-yyyy"
//        let resultDate = formatter.string(from: date)
//        print(resultDate)
        
        //Carrega a API com a moeda BRITA ao modelo de Moeda do Realm
        let apiCall = APIManager.shared.fetchCotacaoDolarFromApi(resultDate)
        apiCall.then {
            dolares -> Void in
            
            //Adiciona cotação de Brita ao Realm
            addMoeda("Brita", cotacaoCompra: dolares[0].cotacaoCompra!, cotacaoVenda: dolares[0].cotacaoVenda!, dataHoraCotacao: dolares[0].dataHoraCotacao!)
            
            }.catch { error
                -> Void in
        }
        
        //Carrega a API com a moeda BTC
        let apiCall2 = APIManager.shared.fetchCotacaoBtcFromApi()
        apiCall2.then {
            bitcoins -> Void in

            let cotacaoCompra = Double((bitcoins[0].buy! as NSString).doubleValue)
            let cotacaoVenda = Double((bitcoins[0].sell! as NSString).doubleValue)
            
            //Adiciona cotação de BTC ao modelo de Moeda do Realm
            addMoeda("BTC", cotacaoCompra: cotacaoCompra, cotacaoVenda: cotacaoVenda, dataHoraCotacao: "\(bitcoins[0].date!)")
            
            }.catch { error
                -> Void in
        }

    }
    
    //Chama a View de registro de cliente
    @IBAction func registroCliente(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RegistrarClienteViewController") as! RegistrarClienteViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //Chama a View de login de cliente
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

