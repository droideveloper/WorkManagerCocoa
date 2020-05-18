//
//  WorkerManager.swift
//  WorkManagerCocoa
//
//  Created by Fatih Şen on 15.02.2020.
//  Copyright © 2020 Fatih Sen. All rights reserved.
//

import Foundation

public class WorkerManager: OperationQueue {
		
  private var cache = Dictionary<AnyHashable, WorkerDelegate>()
  private var policyCache = Dictionary<AnyHashable, Double>()
  private let defaultDispatchDelay = 3.0
  
  private let lock = SpinLock()
  
  public static let shared: WorkerManager = {
    return WorkerManager() // we create defaults
  }()
  
  public init(_ maxConcurrent: Int = 2, _ name: String = String(describing: WorkerManager.self)) {
		super.init()
		self.maxConcurrentOperationCount = maxConcurrent
		self.name = name
	}
	
	public func enqueu<T>(_ worker: Worker<T>) {
    lock.hold()
		addOperation(worker)
    registerDelegate(key: worker, StateDelegate({ [weak self] state in
      // unregister it immediaetly
      self?.unregisterDelegate(key: worker)
      
      // we do call register this state
      let delay = self?.defaultDispatchDelay ?? 0.0
      let future = DispatchTime.now() + delay
      
      if state == .retry {
        DispatchQueue.main.asyncAfter(deadline: future, execute: { [weak self] in
          self?.enqueu(worker)
        })
      }
    }))
    lock.release()
	}
  
  private func registerDelegate<T>(key: Worker<T>,_ delegate: WorkerDelegate) {
    cache[key] = delegate
  }
  
  private func unregisterDelegate<T>(key: Worker<T>) {
    cache.removeValue(forKey: key)
  }
  
  // internal state management
  internal enum State {
    case success
    case retry
  }
  
  // internal state callbacks
  internal class StateDelegate: WorkerDelegate {
    
    private let callback: (State) -> Void
    
    init(_ callback: @escaping (State) -> Void) {
      self.callback = callback
    }
    
    func complete<T>(_ result: Result<T>) {
      switch result {
        case .success(_):
          callback(.success)
        default:
          callback(.retry)
        }
    }
  }
}
