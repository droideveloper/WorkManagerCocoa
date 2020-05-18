//
//  Worker.swift
//  WorkManagerCocoa
//
//  Created by Fatih Şen on 15.02.2020.
//  Copyright © 2020 Fatih Sen. All rights reserved.
//

import Foundation

open class Worker<T>: Operation {
	
  var delegates = Array<WorkerDelegate>()
	private let lock = SpinLock()
  
  public init(_ delegate: WorkerDelegate? = nil) {
    if let delegate = delegate {
      self.delegates.append(delegate)
    }
  }
	
	public override func main() {
		do {
      let result: Result<T> = try createWork()
      dispatchResult(result)
		} catch let error {
      let result = Result<T>.error(error)
      dispatchResult(result)
		}
	}
	
	open func createWork() throws -> Result<T> {
		return .success(nil)
	}
  
  public func  registerDelegate(_ delegate: WorkerDelegate) {
    lock.hold()
    let index = delegates.firstIndex { search in
      return search === delegate
    }
    if index == nil {
      delegates.append(delegate)
    }
    lock.release()
  }
  
  public func unregisterDelegate(_ delegate: WorkerDelegate) {
    lock.hold()
    let index = delegates.firstIndex { search in
      return search === delegate
    }
    if let index = index {
      delegates.remove(at: index)
    }
    lock.release()
  }

  public func dispatchResult(_ result: Result<T>) {
    lock.hold()
    for delegate in delegates {
      delegate.complete(result)
    }
    lock.release()
  }
  
  public func dispatchProgress(_ progress: Float) {
    lock.hold()
    for delegate in delegates {
      delegate.progress(progress)
    }
    lock.release()
  }
}
