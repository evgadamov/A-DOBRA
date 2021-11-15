//
//  CustomButton.swift
//  CalcHeatingFee
//
//  Created by Evgeny Adamov on 16.02.2021.
//

import UIKit

class CustomButton: UIButton {
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		if self.tag == 999 {
			self.backgroundColor = .systemRed
			self.titleLabel?.tintColor = .white
		} else if self.tag == 777 {
			self.titleLabel?.tintColor = .black
			self.backgroundColor = .clear
		} else {
			self.titleLabel?.tintColor = .white
		}
		self.layer.cornerRadius = frame.height / 3
		self.titleLabel?.font = .boldSystemFont(ofSize: 14)
	}
}

