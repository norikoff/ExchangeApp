//
//  PairsCell.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 06.12.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import UIKit

class PairCell: UITableViewCell {
    let minValue = 0
    
    var pair : EntryList.Pair? {
        didSet {
            pairLabel.text = pair?.pairName
            priceLabel.text = (pair?.content.percentChange)!+"%"
        }
    }
    
    private let pairLabel : UILabel = {
        let lbl = UILabel()
        lbl.clipsToBounds = true
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.sizeToFit()
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let amountLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let priceLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textColor = .white
        lbl.textAlignment = .right
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(pairLabel)
        addSubview(amountLabel)
        addSubview(priceLabel)
        NSLayoutConstraint.activate([
            pairLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            pairLabel.topAnchor.constraint(equalTo: topAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: topAnchor),
            priceLabel.leftAnchor.constraint(equalTo: amountLabel.rightAnchor),
            priceLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            
            ])
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
