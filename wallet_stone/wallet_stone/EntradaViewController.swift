//
//  EntradaViewController.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 25/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class EntradaViewController: UIViewController, UITextFieldDelegate {

    // MARK: Declarações
    @IBOutlet weak var saldoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var saldoAtual = 0.0
    var clienteID = ""
    
    var dataSourceArray = [Moeda]()
    let clienteModel = ClienteModel()
    let moedaModel = MoedaModel()
    
    // MARK: Métodos
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Registra notificação para atualização do saldo
        NotificationCenter.default.addObserver(self, selector: #selector(EntradaViewController.updateSaldoLabel), name: NSNotification.Name(rawValue: "atualizaSaldo"), object: nil)
        
        //Registra notificação de Mensagens
        NotificationCenter.default.addObserver(self, selector: #selector(EntradaViewController.showMensagem), name: NSNotification.Name(rawValue: "mensagemRetorno"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        //Recupera o usuário pelo e-mail logado
        let email = UserDefaults.standard.string(forKey: "emailCliente")
        let cliente = clienteModel.listDetailCliente(email!)
        
        saldoAtual = Double(cliente.saldo)
        
        let saldoFomatado = Help().formatCoin("pt_BR", valor:  saldoAtual)
        saldoLabel.text = "\(saldoFomatado)"
        
        clienteID = cliente.clienteID
        
        //Carrega dados de cotação das Moedas salvas no Realm
        dataSourceArray = moedaModel.listMoedas()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
    }
    
    //Função para atualizar o saldo
    func updateSaldoLabel(_ notification: NSNotification) {
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            if let saldoNovo = dict["saldo"] as? Double {
                saldoLabel.text = "\(Help().formatCoin("pt_BR", valor:  saldoNovo))"
                
                saldoAtual = saldoNovo
                
                //Mostra alerta de mensagem
                Alert(controller: self).showError(message: "Compra efetuada com sucesso!", handler : { action in
                    self.dismiss(animated: false)
                })
            }
        }
    }
    
    //Função para criar alerta de mensagens
    func showMensagem(_ notification: NSNotification) {
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            if let mensagemNova = dict["mensagem"] as? String {
                
                //Mostra alerta de mensagem
                Alert(controller: self).showError(message: mensagemNova, handler : { action in
                    self.dismiss(animated: false)
                })
            }
        }
    }
    
    @IBAction func retornar(_ sender: Any) {
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}

// MARK: TableView Delegate
extension EntradaViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath ) as! ListCriptoTableViewCell
        
        let row = indexPath.row
        let moeda = dataSourceArray[row]
        
        cell.configuraCelulaMoeda(clienteID: clienteID, saldo: saldoAtual, cripto: moeda)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
