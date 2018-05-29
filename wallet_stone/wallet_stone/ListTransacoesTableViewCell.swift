//
//  ListTransacoesTableViewCell.swift
//  wallet_stone
//
//  Created by Luis Felipe Tapajos on 29/05/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class ListTransacoesTableViewCell: UITableViewCell {

    @IBOutlet weak var moedaLabel: UILabel!
    @IBOutlet weak var quantidadeLabel: UILabel!
    @IBOutlet weak var valorTransacaoLabel: UILabel!
    @IBOutlet weak var dataHoraTransacaoLabel: UILabel!
    @IBOutlet weak var tipoimageView: UIImageView!
    
    //Configura a célula de Transação
    func configuraCelulaTransacao(transancao: Transacoes) {
        
        let moeda = recuperaMoedaPorNome(transancao.moedaNome)
        
        //Formato moedas por tipo
        var valorFomatado = ""
        if (transancao.moedaNome == "Brita") {
            valorFomatado = formatMoeda("pt_BR", valor: transancao.valorTransacao)
        } else if (transancao.moedaNome == "BTC") {
            valorFomatado = "U\(formatMoeda("en_US", valor: transancao.valorTransacao))"
        }
        
        //Carrega valores
        moedaLabel.text = moeda.nome
        quantidadeLabel.text = "Quantidade: \(transancao.quantidade)"
        valorTransacaoLabel.text = "Valor: \(valorFomatado)"
        dataHoraTransacaoLabel.text = transancao.dataHoraTransacao
        
        //Mostra imagem de operação compra ou venda
        if (transancao.tipo == "COMPRA") {
            tipoimageView.image = UIImage(named: "btn_transacao_compra")
        } else if (transancao.tipo == "VENDA") {
            tipoimageView.image = UIImage(named: "btn_transacao_venda")
        }
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(red:0.60, green:0.88, blue:0.96, alpha:1.0).cgColor
        self.layer.cornerRadius = 8
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
