//
//  PerfilViewController.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 27/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController {

    // MARK: Declarações
    @IBOutlet weak var saldoLabel: UILabel!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSourceArray = [Moeda]()
    var transacoes = [Transacoes]()
    
    let clienteModel = ClienteModel()
    let moedaModel = MoedaModel()
    let transacaoModel = TransacaoModel()
    
    var clienteID = ""
    
    // MARK: Métodos
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Registra notificação de Mensagens
        NotificationCenter.default.addObserver(self, selector: #selector(PerfilViewController.trocaMoedaButton), name: NSNotification.Name(rawValue: "trocaMoedaButton"), object: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        //Recupera o usuário pelo e-mail logado
        let email = UserDefaults.standard.string(forKey: "emailCliente")
        let cliente = clienteModel.listDetailCliente(email!)
        
        clienteID = cliente.clienteID
        
        let saldoFomatado = Help().formatCoin("pt_BR", valor:  Double(cliente.saldo))
        saldoLabel.text = "\(saldoFomatado)"
        
        nomeLabel.text = cliente.nome
        
        //Carrega Moedas salvas no Realm
        dataSourceArray = moedaModel.listMoedas()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
        
    }
    
    //Função para carregar troca de Moedas
    func trocaMoedaButton(_ notification: NSNotification) {
        //print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            if let moedaAtual = dict["moedaNome"] as? String {
                
                //Busca moeda diferente da moeda selecionada
                let moedaTrocada = moedaModel.loadChangeCoinByName(moedaAtual)
                //moedaAtual
                
                let alertController = UIAlertController(title: "ATENÇÃO", message: "Deseja efetuar uma troca da moeda \(moedaAtual) pela moeda \(moedaTrocada.nome)?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "SIM", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    
                    //Carrega Tela de troca de moedas
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "TrocaViewController") as! TrocaViewController
                    
                    controller.moedaOrigem = moedaAtual
                    controller.moedaTroca = moedaTrocada.nome
                    
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                }
                let cancelAction = UIAlertAction(title: "NÃO", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func retornar(_ sender: Any) {
        
        //Remove login do cliente
        UserDefaults.standard.removeObject(forKey: "emailCliente")
        
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        }
    }
    
    //Chama a View que lista as Transações do cliente
    @IBAction func carregarTransacoes(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TransacoesViewController") as! TransacoesViewController
        controller.clienteID = clienteID
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //Chama a View que lista dados das moedas para salvar compras do cliente
    @IBAction func comprarMoedas(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EntradaViewController") as! EntradaViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //Chama a View que lista dados das moedas para salvar vendas do cliente
    @IBAction func venderMoedas(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SaidaViewController") as! SaidaViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: TableView Delegate
extension PerfilViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath ) as! ListMoedasTableViewCell
        
        let row = indexPath.row
        let moeda = dataSourceArray[row]
        
        //Configura a célula
        cell.configuraCelulaMoeda(moeda: moeda)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
