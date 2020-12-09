//
//  AppConstants.swift
//  currency app paypay
//
//  Created by Nadun De Silva on 20/Dec/08.
//  Copyright © 2020 Nadun De Silva. All rights reserved.
//

struct Keys {
    static let currency_service_api_key = "c3c86551b22582addd251e922ae0490c"
}

struct Config {
    struct CurrencyService {
        static let base_url = "api.currencylayer.com"
    }
    static let request_timeout = 10.0 //Seconds
    static let request_time_interval = 60.0 * 30.0 //Seconds
    static let date_time_format = "YYYY MMM d, hh:mm"
}

struct Strings {
    static let last_update_time = "Last updated on %@"
    struct Alert {
        static let titleNotLoaded = "Coudn't Load!"
        static let messageDataNotAvailable = "Data not available to display."
        static let tryAgainButton = "Try again"
        static let messageDataOutdated = "Loading with outdated data."
        static let okButton = "Ok"
    }
}
