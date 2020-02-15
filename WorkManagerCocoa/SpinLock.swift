//
//  SpinLock.swift
//  WorkManagerCocoa
//
//  Created by Fatih Şen on 15.02.2020.
//  Copyright © 2020 Fatih Sen. All rights reserved.
//

import Foundation

public class SpinLock: Lock {
	
	private var obj = os_unfair_lock_s()
	
	public func hold() {
		if #available(iOS 10.0, *) {
			os_unfair_lock_lock(&obj)
		}
	}
	
	public func release() {
		if #available(iOS 10.0, *) {
			os_unfair_lock_unlock(&obj)
		}
	}
}
