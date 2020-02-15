//
//  RxWorker.swift
//  WorkManagerCocoa
//
//  Created by Fatih Şen on 15.02.2020.
//  Copyright © 2020 Fatih Sen. All rights reserved.
//

import Foundation
import RxSwift

open class RxWorker: Operation {
	
	private let delegate: WorkerDelegate
	
	private var disposable = Disposables.create()
	
	public init(_ delegate: WorkerDelegate) {
		self.delegate = delegate
	}
	
	open override func main() {
		let letch = CountDownLatch(count: 1)
		do {
			disposable = try createWork().subscribe { [weak self] event in
				switch event {
					case .next(let result): self?.delegate.onComplete(result)
					case .error(let error): self?.delegate.onComplete(.error(error))
					case .completed: self?.delegate.onComplete(.success)
				}
				letch.countDown()
			}
		} catch let error {
			delegate.onComplete(.error(error))
			letch.countDown()
		}
		letch.await()
	}
	
	open func createWork() throws -> Observable<Result> {
		return .just(.success)
	}
	
	deinit {
		disposable.dispose()
	}
}
