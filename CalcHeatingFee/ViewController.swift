//
//  ViewController.swift
//  CalcHeatingFee
//
//  Created by Evgeny Adamov on 16.02.2021.
//

import UIKit

class ViewController: UIViewController {
	
	// Status Bar Color
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	// Value section
	
	@IBOutlet weak var valueSectionStack: UIStackView!
	@IBOutlet weak var normativSingleStack: UIStackView!
	@IBOutlet weak var totalAreaInHouseSingleStack: UIStackView!
	@IBOutlet weak var totalEnergyConsumedSingleStack: UIStackView!
	
	// Single sections in stack
	
	@IBOutlet weak var stackMOPSingleSection: UIStackView!
	@IBOutlet weak var stackIPUSingleSectionWithSwitch: UIStackView!
	
	// Buttons outlet
	
	@IBOutlet weak var button7mounth: CustomButton!
	@IBOutlet weak var button12mounth: CustomButton!
	
	// Switch buttons
	
	@IBOutlet weak var switchButtonOdpu: UISwitch!
	@IBOutlet weak var switchButtonIpu: UISwitch!
	
	// Value inputs text fields
	
	@IBOutlet weak var tariffTextField: UITextField!								// Тариф
	@IBOutlet weak var totalAreaApartmentTextField: UITextField!		// Общая площадь квартиры
	@IBOutlet weak var totalAreaInHouseTextField: UITextField!			// Площадь всех помещений
	@IBOutlet weak var commonAreaTextField: UITextField!						// Площадь МОП
	@IBOutlet weak var totalEnergyConsumedTextField: UITextField!		// Колличество потребляемой энергии
	@IBOutlet weak var normativTextField: UITextField! 							// Норматив
	
	@IBOutlet weak var resultCalculation: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		checkMounthsButton()
		checkODPUSwitchIsEnabled()
		checkIPUisEnabled()
		switchButtonIpu.onTintColor = .systemRed
		switchButtonOdpu.onTintColor = .systemRed
		
		clearResult()
	}
	
	let numberFormatter: NumberFormatter = {
		let nf = NumberFormatter()
		nf.numberStyle = .decimal
		nf.maximumFractionDigits = 2
		nf.minimumFractionDigits = 2
		return nf
	}()
	
	var calculationMethodInMounth: MounthForPay = .twelve
	
	func checkODPUSwitchIsEnabled() {
		if switchButtonOdpu.isOn {
			UIView.animate(withDuration: 0.5) {
				self.normativSingleStack.isHidden = true
				self.totalAreaInHouseSingleStack.isHidden = false
				self.totalEnergyConsumedSingleStack.isHidden = false
			}
		} else {
			UIView.animate(withDuration: 0.5) {
				self.normativSingleStack.isHidden = false
				self.totalAreaInHouseSingleStack.isHidden = true
				self.totalEnergyConsumedSingleStack.isHidden = true
			}
		}
	}
	
	@IBAction func calculateButton(_ sender: UIButton) {
		
		if !switchButtonOdpu.isOn {
			
			if let tariffString = tariffTextField.text,
				 let tariffDouble = numberFormatter.number(from: tariffString),
				 let totalAreaApartmentString = totalAreaApartmentTextField.text,
				 let totalAreaApartmentDouble = numberFormatter.number(from: totalAreaApartmentString),
				 let normativString = normativTextField.text,
				 let normativDouble = numberFormatter.number(from: normativString) {
				
				let simpleCalc = SimpleCalc(tariff: tariffDouble.doubleValue,
																		totalAreaOfApartment: totalAreaApartmentDouble.doubleValue, normativ: normativDouble.doubleValue)
				
				let resultDouble = simpleCalc.calc(mounth: calculationMethodInMounth.rawValue)
				let resultString = convertDoubleTo(currency: resultDouble)
				
				if let result = resultString {
					resultCalculation.text = result
				}
			} else {
				wrongValues()
			}
		} else {
			if let tariffString = tariffTextField.text,
				 let tariffDouble = numberFormatter.number(from: tariffString),
				 let totalAreaApartmentString = totalAreaApartmentTextField.text,
				 let totalAreaApartmentDouble = numberFormatter.number(from: totalAreaApartmentString),
				 let totalAreaInHouseString = totalAreaInHouseTextField.text,
				 let totalAreaInHouseDouble = numberFormatter.number(from: totalAreaInHouseString),
				 // let commonAreaString = commonAreaTextField.text,
				 // let commonAreaDouble = numberFormatter.number(from: commonAreaString),
				 let amountEnergyConsumedString = totalEnergyConsumedTextField.text,
				 let amountEnergyConsumedDouble = numberFormatter.number(from: amountEnergyConsumedString)
			{
				
				let calc = Calculate(tariff: tariffDouble.doubleValue,
														 totalAreaAppartment: totalAreaApartmentDouble.doubleValue,
														 totalAreaInHouse: totalAreaInHouseDouble.doubleValue,
														 commonArea: nil,
														 amountEnergyConsumed: amountEnergyConsumedDouble.doubleValue)
				
				let resultDouble = calc.step6(mounth: calculationMethodInMounth.rawValue)
				let resultString = convertDoubleTo(currency: resultDouble)
				
				if let result = resultString {
					resultCalculation.text = result
				}
			} else {
				wrongValues()
			}
		}
	}
	
	@IBAction func clearResultButton(_ sender: UIButton) {
		clearResult()
	}
	
	func clearResult() {
		[tariffTextField, totalAreaApartmentTextField, totalAreaInHouseTextField, commonAreaTextField, totalEnergyConsumedTextField, normativTextField].forEach { (textField) in
			textField?.text = nil
		}
		
		if let clearValueStr = convertDoubleTo(currency: 0.00) {
			
			resultCalculation.text = clearValueStr
		}
	}
	
	func convertDoubleTo(currency value: Double) -> String? {
		let numberFormatter = NumberFormatter()
		numberFormatter.locale = Locale.init(identifier: "ru_RU")
		numberFormatter.numberStyle = .currency
		
		return numberFormatter.string(from: NSNumber(value: value))
	}
	
	func convertStringTo(double value: String) -> Double? {
		let numberFormatter = NumberFormatter()
		numberFormatter.locale = Locale.init(identifier: "ru_RU")
		numberFormatter.numberStyle = .currency
		
		
		if let nsNumberValue = numberFormatter.number(from: value) {
			return nsNumberValue.doubleValue
		} else {
			return nil
		}
	}
	
	private func checkIPUisEnabled() {
		
		if switchButtonIpu.isOn && stackMOPSingleSection.isHidden {
			stackMOPSingleSection.isHidden = false
		} else {
			stackMOPSingleSection.isHidden = true
		}
	}
	
	@IBAction func button7mounth(_ sender: CustomButton) {
		calculationMethodInMounth = .seven
		checkMounthsButton()
	}
	
	@IBAction func button12mounth(_ sender: CustomButton) {
		calculationMethodInMounth = .twelve
		checkMounthsButton()
	}
	
	@IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
		view.endEditing(true)
	}
	
	@IBAction func switchIPUToggled(_ sender: UISwitch) {
		UIView.animate(withDuration: 0.5) {
			self.checkIPUisEnabled()
		}
	}
	
	@IBAction func switchODPUToggled(_ sender: UISwitch) {
		
		checkODPUSwitchIsEnabled()
		
		// Если свитч включили
		
		if sender.isOn {
			UIView.animate(withDuration: 0.2) {
				self.stackIPUSingleSectionWithSwitch.isHidden = false
			}
		}
		
		// Если свитч выключили
		
		if !sender.isOn { // OFF
			UIView.animate(withDuration: 0.5) {
				self.stackIPUSingleSectionWithSwitch.isHidden = true
			}
			
			if switchButtonIpu.isOn {
				switchButtonIpu.setOn(false, animated: true)
				if !stackMOPSingleSection.isHidden {
					UIView.animate(withDuration: 0.5) {
						self.stackMOPSingleSection.isHidden = true
					}
				}
			}
		}
	}
	
	func checkMounthsButton() {
		switch self.calculationMethodInMounth {
			case .seven:
				self.button7mounth.layer.borderWidth = 2
				self.button7mounth.layer.borderColor = UIColor.systemRed.cgColor
				self.button12mounth.layer.borderColor = UIColor.clear.cgColor
			case .twelve:
				self.button12mounth.layer.borderWidth = 2
				self.button12mounth.layer.borderColor = UIColor.systemRed.cgColor
				self.button7mounth.layer.borderColor = UIColor.clear.cgColor
		}
	}
	
	func wrongValues() {
		let alertController = UIAlertController(title: "Некорректные данные",
																						message: "Пожалуйста, введите корректные данные.", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alertController.addAction(okAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
	
}

// Блокировка ввода второго знака "," или "." (в зависимости от локали)

extension ViewController: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		let locale = Locale.current
		let decimalSeparator = locale.decimalSeparator ?? "."
		
		let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
		let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
		
		var numbers = CharacterSet.decimalDigits
		numbers.insert(charactersIn: decimalSeparator)
		
		if existingTextHasDecimalSeparator != nil,
			 replacementTextHasDecimalSeparator != nil {
			return false
		} else {
			return (string.rangeOfCharacter(from: numbers) != nil) || string.isEmpty
		}
	}
}
