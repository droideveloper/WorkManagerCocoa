//
//  Worker.swift
//  WorkManagerCocoa
//
//  Created by Fatih Şen on 15.02.2020.
//  Copyright © 2020 Fatih Sen. All rights reserved.
//

import Foundation

open class Worker<T>: Operation {
	
	private let delegate: WorkerDelegate
	
	public init(_ delegate: WorkerDelegate) {
		self.delegate = delegate
	}
	
	open override func main() {
		do {
      let result: Result<T> = try createWork()
			delegate.onComplete(result)
		} catch let error {
      let e = Result<T>.error(error)
			delegate.onComplete(e)
		}
	}
	
	open func createWork<T>() throws -> Result<T> {
		return .success(nil)
	}
  
  // if you want to dispatch any sort of progress go with this 
  open func dispatchProgress(progress: Float) {
    delegate.onProgress(progress: progress)
  }
}
