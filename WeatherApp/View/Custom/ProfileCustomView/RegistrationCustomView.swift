//
//  registrationCustomView.swift
//  WeatherApp
//
//  Created by MacBook on 11/5/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
protocol RegistrationCustomViewDelegate: class {
    func chengeImageButton(sender: UIButton)
}
class ProfileViewController: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var buttonCheck: UIButton!
     weak var registrationCustomViewDelegate: RegistrationCustomViewDelegate?
    
    @IBAction func buttonCheckAction(_ sender: UIButton) {
        registrationCustomViewDelegate?.chengeImageButton(sender: sender)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(ProfileViewController.className, owner: self, options: nil)
        self.addSubview(contentView)
    }
}
