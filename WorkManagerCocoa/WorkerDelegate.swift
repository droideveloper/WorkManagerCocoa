//
//  WorkerDelegate.swift
//  WorkManagerCocoa
//
//  Created by Fatih Şen on 15.02.2020.
//  Copyright © 2020 Fatih Sen. All rights reserved.
//

import Foundation

public protocol WorkerDelegate {
	
	func onComplete<T>(_ result: Result<T>)
}

public extension WorkerDelegate {
  
  func onProgress(progress: Float) {
    // we do have default implementation for making it optional
  }
}
