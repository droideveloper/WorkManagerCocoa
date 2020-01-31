//
//  JobParams.swift
//  WorkManagerCocoa
//
//  Created by Fatih Sen on 26.01.2020.
//  Copyright © 2020 Fatih Sen. All rights reserved.
//

import Foundation

public struct JobParam {
  
  private var data: Dictionary<String, Any> = [:]
  
  public mutating func putString(key: String, value: String) {
    data[key] = value
  }
  
  public mutating func putDouble(key: String, value: Double) {
    data[key] = value
  }
  
  public mutating func putInt(key: String, value: Int) {
    data[key] = value
  }
  
  public mutating func putFloat(key: String, value: Float) {
    data[key] = value
  }
  
  public mutating func putObject<T>(key: String, value: T) {
    data[key] = value
  }
  
  public mutating func putAny(key: String, value: Any) {
    data[key] = value
  }
}
