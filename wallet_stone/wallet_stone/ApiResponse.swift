//
//  ApiResponse.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 24/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import ObjectMapper

class ApiResponse : Mappable {
    
    var dolares : [Dolar]?
    var bitcoins : [Bitcoin]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        dolares <- map["value"] //"dolar"
        bitcoins <- map["data"] //"btc"
    }
}

//{
//    "@odata.context": "https://was-p/olinda/servico/PTAX/versao/v1/odata$metadata#_CotacaoDolarDia",
//    "value": [{
//    "cotacaoCompra": 3.6501,
//    "cotacaoVenda": 3.6507,
//    "dataHoraCotacao": "2018-05-23 13:04:41.926"
//    }]
//}

class Dolar: Mappable {
    
    var cotacaoCompra: Double?
    var cotacaoVenda: Double?
    var dataHoraCotacao: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        cotacaoCompra <- map["cotacaoCompra"]
        cotacaoVenda <- map["cotacaoVenda"]
        dataHoraCotacao <- map["dataHoraCotacao"]
    }
}

//{
//    "date": "2018-05-23",
//    "opening": 29703.0,
//    "closing": 28500.00066,
//    "lowest": 27501.0,
//    "highest": 30200.0,
//    "volume": 4819955.64147635,
//    "quantity": 168.55281569,
//    "amount": 2800,
//    "avg_price": 28596.11464659
//}

class Bitcoin: Mappable {
    
    var date: String?
    var opening: Double?
    var closing: Double?
    var lowest: Double?
    var highest: Double?
    var volume: Double?
    var quantity: Double?
    var amount: Double?
    var avg_price: Double?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        date <- map["date"]
        opening <- map["opening"]
        closing <- map["closing"]
        lowest <- map["lowest"]
        highest <- map["highest"]
        volume <- map["volume"]
        quantity <- map["quantity"]
        amount <- map["amount"]
        avg_price <- map["avg_price"]
    }
}
