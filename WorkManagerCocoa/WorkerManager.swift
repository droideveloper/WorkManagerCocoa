//
//  WorkerManager.swift
//  WorkManagerCocoa
//
//  Created by Fatih Şen on 15.02.2020.
//  Copyright © 2020 Fatih Sen. All rights reserved.
//

import Foundation

public class WorkerManager: OperationQueue {
		
	public init(_ max: Int, _ name: String? = nil) {
		super.init()
		self.maxConcurrentOperationCount = max
		self.name = name
	}
	
	public func enqueu(_ worker: Worker) {
		addOperation(worker)
	}

	public func enqueu(_ worker: RxWorker) {
		addOperation(worker)
	}
}
