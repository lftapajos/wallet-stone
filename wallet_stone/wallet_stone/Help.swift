//
//  Help.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 28/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation

//Formata Moedas
func formatMoeda(_ codigo: String, valor: Double) -> String {
    
    let formatter = NumberFormatter()
    let locale = Locale(identifier: codigo)
    formatter.locale = locale
    formatter.numberStyle = .currency
    let valorFormatado = formatter.string(from: valor as NSNumber)
    return valorFormatado!
    
}

//Cálculo de compra da moeda Brita
func calculaCompraBrita(_ quantidade: Double, saldoAtual: Double, valorCotacaoCompra: Double) -> Double {
    
    let saldoConvertido = (saldoAtual / valorCotacaoCompra)
    let calculoCompra = (quantidade * valorCotacaoCompra)
    let calculoFinal = (saldoConvertido - calculoCompra)
    let saldoFinalDesconvertido = (calculoFinal * valorCotacaoCompra)
    
    return saldoFinalDesconvertido
}

//Cálculo de compra da moeda Bitcoin BTC
func calculaCompraBtc(_ quantidade: Double, saldoAtualDolar: Double, valorCotacaoCompra: Double) -> Double {
    let calculoCompra = (valorCotacaoCompra * (quantidade * saldoAtualDolar))
    let calculoFinal = (saldoAtualDolar - calculoCompra)
    let saldoFinalDesconvertido = (calculoFinal * valorCotacaoCompra)
    
    return saldoFinalDesconvertido
}

//Cálculo de venda da moeda Brita
func calculaVendaBrita(_ quantidade: Double, saldoAtual: Double, valorCotacaoVenda: Double) -> Double {
    
    let saldoConvertido = (saldoAtual / valorCotacaoVenda)
    let calculoVenda = (quantidade * valorCotacaoVenda)
    let calculoFinal = (saldoConvertido + calculoVenda)
    let saldoFinalDesconvertido = (calculoFinal * valorCotacaoVenda)
    
    return saldoFinalDesconvertido
}

//Converte Dólar para Real
func convertDolarToReal(_ cotacao: Double, valor: Double) -> Double {
    let calculo = (cotacao * valor)
    return calculo
}

//Converte Real para Dólar
func convertRealToDolar(_ cotacao:Double, valor: Double) -> Double {
    let calculo = (valor / cotacao)
    return calculo
}
