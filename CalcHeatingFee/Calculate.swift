//
//  Calculate.swift
//  CalcHeatingFee
//
//  Created by Evgeny Adamov on 16.02.2021.
//

import Foundation

enum MounthForPay: Int {
	case seven = 7
	case twelve = 12
}

struct Calculate {
	
	// Value section
	
	var tariff: Double	 									// Тариф
	var totalAreaAppartment: Double				// Общая площадь квартиры
	var totalAreaInHouse: Double					// Площадь всех помещений
	var commonArea: Double?								// Площадь МОП
	var amountEnergyConsumed: Double			// Колличество потребленной энергии
	
	// Methods for calculation
	
	private func step0() -> Double {
		if let commonArea = commonArea {
			let result = totalAreaAppartment * amountEnergyConsumed / (commonArea - Double(0) + totalAreaInHouse)
			return result
		} else {
			let result = totalAreaAppartment * amountEnergyConsumed / totalAreaInHouse
			return result
		}
	}
	
	private func step1() -> Double {
		if let commonArea = commonArea {
			let result = amountEnergyConsumed / (totalAreaInHouse + commonArea) * totalAreaInHouse
			return result
		} else {
			let result = amountEnergyConsumed / totalAreaInHouse * totalAreaInHouse
			return result
		}
	}
	
	private func step2() -> Double {
		let result = amountEnergyConsumed - step1()
		return result
	}
	
	private func step3() -> Double {
		let result = totalAreaAppartment * (amountEnergyConsumed - step1()) / totalAreaInHouse
		return result
	}
	
	private func step4() -> Double {
		let result = step0() + step3()
		return result
	}
	
	private func step5() -> Double {
		let result = step4() * tariff
		return result
	}
	
	func step6(mounth: Int) -> Double {
		let result = step5() / Double(mounth)
		return result
	}
}
