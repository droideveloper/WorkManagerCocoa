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
  
  private let delegate: WorkerDelegate
  
  private var disposable = Disposables.create()
  
  public init(_ delegate: WorkerDelegate) {
    self.delegate = delegate
  }
  
  open override func main() {
    let letch = CountDownLatch(count: 1)
    do {
      disposable = try createWork().subscribe { [weak self] (event: Event<Result<T>>) in
        switch event {
          case .next(let result): self?.delegate.onComplete(result)
          case .error(let error): self?.delegate.onComplete(Result<T>.error(error))
          case .completed: break
        }
      }
    } catch let error {
      let e = Result<T>.error(error)
      delegate.onComplete(e)
    }
    letch.await()
  }
  
  open func createWork<T>() throws -> Observable<Result<T>> {
    return .just(Result<T>.success(nil))
  }
  
  public func dispatchProgress(progress: Float) {
    delegate.onProgress(progress: progress)
  }
  
  deinit {
    disposable.dispose()
  }
}
