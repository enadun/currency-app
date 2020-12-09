//
//  HomeViewController.swift
//  currency app paypay
//
//  Created by Nadun De Silva on 20/Dec/08.
//  Copyright © 2020 Nadun De Silva. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var currencySelectionTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var selectedCurrencyNameLabel: UILabel!
    
    private var viewModel: HomeViewModel!
    private var picker: UIPickerView!
    
    var currencyList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        currencyTextField.delegate = self
        currencyTextField.inputAccessoryView = getInputAccessoryView()
        currencyTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        setupPickerView()
        
        viewModel = HomeViewModel()
        loadList()
    }
    
    
    private func loadList() {
        loadingView.isHidden = false
        viewModel.getCurrncyList { [weak self] success in
            if success {
                self?.getRates()
            } else {
                self?.loadingView.isHidden = true
                //TODO: handle
            }
        }
    }
    
    private func getRates() {
        viewModel.getCurrncyRates { [weak self] success in
            self?.loadingView.isHidden = true
            if !success {
                //TODO: Update with old results alert
            }
            self?.updateView()
        }
    }
    
    private func getInputAccessoryView() -> UIView {
        let toolBar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(self.doneButtonPressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil, action: nil)
        toolBar.setItems([space, doneButton], animated: false)
        return toolBar
    }
    
    private func setupPickerView() {
        picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        currencySelectionTextField.inputView = picker
        currencySelectionTextField.inputAccessoryView = getInputAccessoryView()
    }
    
    private func updateView() {
        currencySelectionTextField.text = viewModel.selectedCurrencyKey
        selectedCurrencyNameLabel.text = viewModel.getCurrencyName(for: viewModel.selectedCurrencyKey ?? "")
        currencyList = viewModel.currencySummery?.currencyList?.map {
            $0.key
            } ?? []
        if let key = viewModel.selectedCurrencyKey,
            let index = currencyList.firstIndex(of: key) {
            currencyList.remove(at: index)
        }
        currencyList.sort(by: { str1, str2 -> Bool in
            let currencyName1 = viewModel.getCurrencyName(for: str1)
            let currencyName2 = viewModel.getCurrencyName(for: str2)
            return currencyName1 < currencyName2
        })
        
        tableView.reloadData()
        
        picker.selectRow(0, inComponent: 0, animated: false)
    }
    
    @objc func doneButtonPressed() {
        view.endEditing(true)
        updateView()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let inputText = textField.text?.components(separatedBy:
            CharacterSet.decimalDigits.inverted).joined()
        let amount = (Double(inputText ?? "100") ?? 100 ) / 100
        viewModel.setCurrencyAmount(amount: amount)
        let formattedString = getFormattedCurrencyString(for: amount)
        textField.text = formattedString
    }
}

extension HomeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        currencyList.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let key = getCurrencyKeyForPicker(with: row)
        return viewModel.getCurrencyName(for: key)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let key = getCurrencyKeyForPicker(with: row)
        viewModel.setSelectedCurrencyKey(selectedCurrency: key)
        print(viewModel.getCurrencyName(for: key))
    }
    
    private func getCurrencyKeyForPicker(with row: Int) -> String {
        if row == 0 {
            return viewModel.selectedCurrencyKey ?? ""
        } else {
            return currencyList[row - 1]
        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = textField.text {
            guard let newRange = Range(range, in: currentText) else {
                return false
            }
            let updatedText = currentText.replacingCharacters(in: newRange, with: string)
            return updatedText.count <= 16
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" || textField.text == nil {
            textField.text = "1.00"
        }
    }
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.currencySummery?.currencyRates?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeCell.dentifier,
                                                 for: indexPath) as? ExchangeCell
        let key = currencyList[indexPath.row]
        cell?.currencyTitleLabel.text = viewModel.getCurrencyName(for: key)
        cell?.exchangeRateLabel.text = viewModel.getCurrencyRateStringFor(key: key)
        cell?.exchangeAmountLabel.text = viewModel.getCurrencyAmountStringFor(key: key)
        return cell ?? ExchangeCell()
    }
    
    
}

