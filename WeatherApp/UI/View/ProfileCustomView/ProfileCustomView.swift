//
//  registrationCustomView.swift
//  WeatherApp
//
//  Created by MacBook on 11/5/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

protocol ProfileCustomViewDelegate: class {
    func changeButtonMale(maleButton: ChekBoxButton, womanButton: ChekBoxButton)
    func changeButtonWoman(maleButton: ChekBoxButton, womanButton: ChekBoxButton)
}

final class ProfileCustomView: UIView {
    // MARK: - UI
    @IBOutlet private weak var maleButton: ChekBoxButton!
    @IBOutlet private weak var womanButton: ChekBoxButton!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    
    // MARK: - Instance
    let profileVC = ProfileViewController()
    weak var profileCustomViewDelegate: ProfileCustomViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /// Common init
    private func commonInit() {
        Bundle.main.loadNibNamed(ProfileCustomView.className, owner: self, options: nil)
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    /// Disable button
    ///
    /// - Parameter disable: Bool = true
    func disableButton(disable: Bool = true) {
        if disable {
            maleButton.clickOff() 
            womanButton.clickOff()
        }
    }
    
    /// Button state with data base
    ///
    /// - Parameter state: Int
    func buttonStateWithDB(state: Int) {
        switch state {
        case 1:
            maleButton.isChecked = false
            maleButton.sendActions(for: .touchUpInside)
        case 2:
            womanButton.isChecked = false
            womanButton.sendActions(for: .touchUpInside)
        default:
            maleButton.clickOff()
            womanButton.clickOff()
        }
    }
}

// MARK: - Button Action
extension ProfileCustomView {
    /// Button male action
    ///
    /// - Parameter sender: UIButton
    @IBAction func buttonMaleAction(_ sender: UIButton) {
        profileCustomViewDelegate?.changeButtonMale(maleButton: maleButton,
                                                    womanButton: womanButton)
    }
    
    /// Button woman action
    ///
    /// - Parameter sender: UIButton
    @IBAction func buttonWomanAction(_ sender: UIButton) {
        profileCustomViewDelegate?.changeButtonWoman(maleButton: maleButton, womanButton: womanButton)
    }
}
