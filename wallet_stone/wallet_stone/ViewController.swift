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
    
    let moedaModel = MoedaModel()
    
    @IBOutlet weak var entradaButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Função para excluir o cliente (teste)
        //deleteCliente()
        
        //let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        //print("App Path: \(dirPaths)")
        
        //Remove todas as Moedas antes de recuperar as novas cotações diárias
        moedaModel.deleteMoeda()
        
        //let resultDate = "06-01-2017"
        let date = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -3, to: date)!
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let resultDate = formatter.string(from: yesterday)
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
            } else {
                //Cotação não encontrada
                //Mostra alerta de mensagem
                Alert(controller: self).showError(message: "Cotação do dólar não encontrada! Tente novamente mais tarde.", handler : { action in
                    self.dismiss(animated: false)
                })
                
                //Remove overlayView
                self.overlayView.removeFromSuperview()
                self.entradaButton.isEnabled = false
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

