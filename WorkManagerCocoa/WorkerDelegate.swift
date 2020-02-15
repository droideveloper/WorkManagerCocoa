//
//  WorkerDelegate.swift
//  WorkManagerCocoa
//
//  Created by Fatih Şen on 15.02.2020.
//  Copyright © 2020 Fatih Sen. All rights reserved.
//

import Foundation

public protocol WorkerDelegate {
	
	func onComplete(_ result: Result)
}
