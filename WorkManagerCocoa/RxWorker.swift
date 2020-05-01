//
//  RxWorker.swift
//  WorkManagerCocoa
//
//  Created by Fatih Sen on 1.05.2020.
//  Copyright © 2020 Fatih Sen. All rights reserved.
//

import Foundation
import RxSwift

open class RxWorker<T>: Operation {
  
  private let lock = SpinLock()
  
  private var disposable = Disposables.create()
  private var delegates = Array<WorkerDelegate>()
  
  public init(_ delegate: WorkerDelegate? = nil) {
    if let delegate = delegate {
      self.delegates.append(delegate)
    }
  }
  
  public override func main() {
    let letch = CountDownLatch(count: 1)
    do {
      disposable = try createWork().subscribe { [weak self] (event: Event<Result<T>>) in
        switch event {
          case .next(let result):
            self?.dispatchResult(result)
          case .error(let error):
            let result = Result<T>.error(error)
            self?.dispatchResult(result)
          case .completed: break
        }
      }
    } catch let error {
      let result = Result<T>.error(error)
      dispatchResult(result)
    }
    letch.await()
  }
  
  open func createWork<T>() throws -> Observable<Result<T>> {
    return .just(Result<T>.success(nil))
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
  
  public func dispatchProgress(progress: Float) {
    lock.hold()
    for delegate in delegates {
      delegate.progress(progress)
    }
    lock.release()
  }
  
  public func dispatchResult<T>(_ result: Result<T>) {
    lock.hold()
    for delegate in delegates {
      delegate.complete(result)
    }
    lock.release()
  }
  
  deinit {
    disposable.dispose()
  }
}
