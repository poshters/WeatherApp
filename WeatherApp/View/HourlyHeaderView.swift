//
//  HourlyHeaderView.swift
//  WeatherApp
//
//  Created by mac on 10/2/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class HourlyHeaderView: UIView {

    @IBOutlet private weak var horlyHeader: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(HourlyHeaderView.className, owner: self, options: nil)
        addSubview(horlyHeader)
        horlyHeader.translatesAutoresizingMaskIntoConstraints = false
        horlyHeader.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: horlyHeader.bottomAnchor).isActive = true
        horlyHeader.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: horlyHeader.trailingAnchor).isActive = true
    }
}
