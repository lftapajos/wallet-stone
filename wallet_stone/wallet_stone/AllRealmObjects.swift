//
//  AllRealmObjects.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 26/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import RealmSwift

//Realm de Cliente
class Cliente : Object {
    
    dynamic var clienteID = ""
    dynamic var nome = ""
    dynamic var email = ""
    dynamic var senha = ""
    dynamic var saldo = 0
}

//Realm de Moeda
class Moeda : Object {
    
    dynamic var moedaID = ""
    dynamic var nome = ""
    dynamic var cotacaoCompra = 0.0
    dynamic var cotacaoVenda = 0.0
    dynamic var dataHoraCotacao = ""
}

//Realm de Relatório
class Transacoes : Object {
    
    dynamic var transacaoID = ""
    dynamic var clienteID = ""
    dynamic var moedaID = ""
    dynamic var tipo = ""
    dynamic var quantidade = 0.0
    dynamic var valorTransacao = 0.0
    dynamic var dataHoraTransacao = ""
}
