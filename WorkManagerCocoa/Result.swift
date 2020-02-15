//
//  Result.swift
//  WorkManagerCocoa
//
//  Created by Fatih Şen on 15.02.2020.
//  Copyright © 2020 Fatih Sen. All rights reserved.
//

import Foundation

public enum Result {
	case success
	case error(Error)
	case retry(RetryPolicy)
}
