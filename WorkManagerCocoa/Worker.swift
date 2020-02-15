//
//  Worker.swift
//  WorkManagerCocoa
//
//  Created by Fatih Şen on 15.02.2020.
//  Copyright © 2020 Fatih Sen. All rights reserved.
//

import Foundation

open class Worker: Operation {
	
	private let delegate: WorkerDelegate
	
	public init(_ delegate: WorkerDelegate) {
		self.delegate = delegate
	}
	
	open override func main() {
		do {
			let result = try createWork()
			delegate.onComplete(result)
		} catch let error {
			delegate.onComplete(.error(error))
		}
	}
	
	open func createWork() throws -> Result {
		return .success
	}
}
