//
//  RxWorker.swift
//  WorkManagerCocoa
//
//  Created by Fatih Sen on 1.05.2020.
//  Copyright © 2020 Fatih Sen. All rights reserved.
//

import Foundation
import RxSwift

open class RxWorker<T>: Worker<T> {
  
  private let lock = SpinLock()
  
  private var disposable = Disposables.create()
  
  public override init(_ delegate: WorkerDelegate? = nil) {
    super.init(delegate)
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
  
  open func createWork() throws -> Observable<Result<T>> {
    return .just(Result<T>.success(nil))
  }
  
  deinit {
    disposable.dispose()
  }
}
