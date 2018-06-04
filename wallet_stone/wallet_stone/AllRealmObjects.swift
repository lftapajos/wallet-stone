//
//  AllRealmObjects.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 26/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: Modelos do Realm

// MARK: Modelo de Cliente
class Cliente : Object {
    
    dynamic var clienteID = ""
    dynamic var nome = ""
    dynamic var email = ""
    dynamic var senha = ""
    dynamic var saldo = 0.0
}

// MARK: Modelo de Moeda
class Moeda : Object {
    
    dynamic var moedaID = ""
    dynamic var nome = ""
    dynamic var cotacaoCompra = 0.0
    dynamic var cotacaoVenda = 0.0
    dynamic var dataHoraCotacao = ""
}

// MARK: Modelo de Transações
class Transacoes : Object {
    
    dynamic var transacaoID = ""
    dynamic var clienteID = ""
    dynamic var moedaID = ""
    dynamic var moedaNome = ""
    dynamic var tipo = ""
    dynamic var quantidade = 0.0
    dynamic var valorTransacao = 0.0
    dynamic var dataHoraTransacao = ""
    //Troca
    dynamic var moedaNomeOrigem = ""
    dynamic var novoValorOrigem = 0.0
    dynamic var quantidadeOrigem = 0.0
    dynamic var moedaNomeTroca = ""
    dynamic var novoValorTroca = 0.0
    dynamic var quantidadeTroca = 0.0
}

// MARK: Modelo de Estoque
class Estoque : Object {
    
    dynamic var estoqueID = ""
    dynamic var clienteID = ""
    dynamic var moedaNome = ""
    dynamic var quantidade = 0.0
    dynamic var saldo = 0.0
}
