//
//  registrationCustomView.swift
//  WeatherApp
//
//  Created by MacBook on 11/5/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

protocol ProfileCustomViewDelegate: class {
    func changeButtonMale(maleButton: UIButton, womanButton: UIButton)
    func changeButtonWoman(maleButton: UIButton, womanButton: UIButton)
}

class ProfileCustomView: UIView {
    
    @IBOutlet private weak var maleButton: UIButton!
    @IBOutlet private weak var womanButton: UIButton!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    weak var profileCustomViewDelegate: ProfileCustomViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(ProfileCustomView.className, owner: self, options: nil)
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        maleButton.setImage(UIImage(named: ProfileConstant.success2), for: .normal)
        womanButton.setImage(UIImage(named: ProfileConstant.success2), for: .normal)
        disableButton(disable: true)
    }
    
    ///Set Image to Male and Woman button
    func setImageToButtonMaleAndWoman(male: String, woman: String) {
        maleButton.setImage(UIImage(named: male), for: .normal)
        womanButton.setImage(UIImage(named: woman), for: .normal)
    }
    
    func disableButton(disable: Bool = true) {
        if disable {
            maleButton.isEnabled = false
            womanButton.isEnabled = false
        } else {
            maleButton.isEnabled = true
            womanButton.isEnabled = true
        }
    }
}

// MARK: - Button Action
extension ProfileCustomView {
    @IBAction func buttonMaleAction(_ sender: UIButton) {
        profileCustomViewDelegate?.changeButtonMale(maleButton: maleButton,
                                                    womanButton: womanButton)
    }
    @IBAction func buttonWomanAction(_ sender: UIButton) {
        profileCustomViewDelegate?.changeButtonWoman(maleButton: maleButton, womanButton: womanButton)
    }
}
