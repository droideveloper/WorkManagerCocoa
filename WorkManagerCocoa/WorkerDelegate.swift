//
//  WorkerDelegate.swift
//  WorkManagerCocoa
//
//  Created by Fatih Şen on 15.02.2020.
//  Copyright © 2020 Fatih Sen. All rights reserved.
//

import Foundation

public protocol WorkerDelegate: class { } // Type defined for delegation

public extension WorkerDelegate {
  
  func progress(_ progress: Float) {
    // we do have default implementation for making it optional
  }
  
  func complete<T>(_ result: Result<T>) {
    // we do have default implementation for making it optional
  }
}
