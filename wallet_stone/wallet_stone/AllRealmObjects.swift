//
//  AllRealmObjects.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 26/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import RealmSwift

class Cliente : Object {
    
    dynamic var nome = ""
    dynamic var email = ""
    dynamic var senha = ""
    dynamic var saldo = 0
}

class Brita : Object {
    
    dynamic var nome = ""
    dynamic var cotacaoCompra = 0.0
    dynamic var cotacaoVenda = 0.0
    dynamic var dataHoraCotacao = ""
}
