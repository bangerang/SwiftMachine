//
//  NSPointerArray+Extension.swift
//
//  Created by Johan Thorell on 2018-06-27.
//



import Foundation

extension NSPointerArray {
	func addObject(_ object: AnyObject) {
		let pointer = Unmanaged.passUnretained(object).toOpaque()
		addPointer(pointer)
	}
	
	func object(at index: Int) -> AnyObject? {
		guard index < count, let pointer = self.pointer(at: index) else { return nil }
		return Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue()
	}

	func removeNilValues() {
		for i in (0..<count).reversed() {
			if object(at: i) == nil {
				removePointer(at: i)
			}
		}
	}
}
