//
//  ViewController.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 24/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var overlayView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Função para excluir o cliente (teste)
        //deleteCliente()
        
        //let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        //print("App Path: \(dirPaths)")
        
        //Remove todas as Moedas antes de recuperar as novas cotações diárias
        deleteMoeda()
        
//        let resultDate = "05-31-2017"
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let resultDate = formatter.string(from: date)
        print(resultDate)
        
        //Carrega Loading enquanto os dados não são carregados pela chamada da API
        self.overlayView = OverlayView().loadView(self.view)
        self.view.addSubview(self.overlayView)
        
        //Chama a API que salva novasbas cotações diárias das Moedas
        APIManager.shared.loadAPIdata(resultDate, completion: { (loaded) in
            
            //Se carregou, mostra os dados
            if (loaded) {
                
                //Remove overlayView
                self.overlayView.removeFromSuperview()
            }
            
        }, failureBlock: {
            //Erro ao carregar dados da API
            
            //Mostra alerta de mensagem
            Alert(controller: self).showError(message: "Erro ao carregar os dados!", handler : { action in
                self.dismiss(animated: false)
            })
        })
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

