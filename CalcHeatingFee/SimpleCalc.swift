//
//  SimpleCalc.swift
//  CalcHeatingFee
//
//  Created by Evgeny Adamov on 10.04.2021.
//

import Foundation

struct SimpleCalc {
	var tariff: Double
	var totalAreaOfApartment: Double
	var normativ: Double
	
	func calc(mounth: Int) -> Double {
		if mounth == 7 {
			let result = (tariff * totalAreaOfApartment * normativ) * 12 / 7
			return result
		} else {
			let result = (tariff * totalAreaOfApartment * normativ)
			return result
		}
	}
}
