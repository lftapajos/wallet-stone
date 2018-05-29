//
//  Transacao.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 29/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import RealmSwift

//_ clienteID: String, moedaNome: String, valor: Double, novoSaldo: Double
func saveTransacation(_ clienteID: String, moedaNome: String, valor: Double, tipo: String, quantidade: Double) {
    
    let realm = try! Realm()
    
    //Filtra moeda pelo nome
    let detailMoeda = realm.objects(Moeda.self).filter("nome = %@", moedaNome)
    
    //Cria dados da Transação de compra
    let transacao = Transacoes()
    transacao.transacaoID = UUID().uuidString
    transacao.clienteID = clienteID
    transacao.moedaID = (detailMoeda.first?.moedaID)!
    transacao.moedaNome = moedaNome
    transacao.tipo = tipo
    transacao.quantidade = quantidade
    transacao.valorTransacao = valor
    transacao.dataHoraTransacao = ""
    
    try! realm.write {
        realm.add(transacao)
        print("Transação \(transacao.transacaoID) adicionado no Realm.")
    }
}

//Lista todas as transacoes de um cliente
func listAllTransacoes(_ clienteID: String) -> [Transacoes] {
    
    let realm = try! Realm()
    
    let allTransacoes = realm.objects(Transacoes.self).filter("clienteID = %@", clienteID)
    
    let transacoes = Array(allTransacoes)
    
    return transacoes
}

//Lista quantidate das transações por cliente e moeda
func listAllTransacoesPorClienteMoeda(_ clienteID: String, moedaNome: String) -> Double {
    
    let realm = try! Realm()
    
    let allTransacoes = realm.objects(Transacoes.self).filter("clienteID = %@ AND moedaNome = %@", clienteID, moedaNome)
    
    var quantidade = 0.0
    for transacao in allTransacoes {
        quantidade = (quantidade + transacao.quantidade)
    }
    
    return quantidade
    
    //let transacoes = Array(allTransacoes)
    
    //return transacoes
}
