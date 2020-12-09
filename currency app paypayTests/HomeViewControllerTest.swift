//
//  HomeViewControllerTest.swift
//  currency app paypayTests
//
//  Created by Nadun De Silva on 20/Dec/08.
//  Copyright © 2020 Nadun De Silva. All rights reserved.
//

import XCTest
@testable import Currency_App

class HomeViewControllerTest: XCTestCase {
    var viewController: HomeViewController?
    
    override func setUpWithError() throws {
        viewController = HomeViewController()
        XCTAssertNotNil(viewController)
        viewController?.viewDidLoad()
        viewController?.doneButtonPressed()
    }
    
    override func tearDownWithError() throws {
        viewController = nil
    }
}
