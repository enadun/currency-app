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
    @IBOutlet weak var currencySelectionButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self

        // Do any additional setup after loading the view.
//        CurrencyService.getCurrencyList { result in
//            print(result)
//        }
    }
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeCell.dentifier,
                                                 for: indexPath) as? ExchangeCell
        return cell ?? ExchangeCell()
    }
    
    
}

