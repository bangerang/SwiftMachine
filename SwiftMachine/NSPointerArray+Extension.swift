//
//  NSPointerArray+Extension.swift
//
//  Created by Johan Thorell on 2018-06-27.
//


/*
    Full credit for this extension to Marco Santarossa from his excellent blog post https://marcosantadev.com/swift-arrays-holding-elements-weak-references/
*/
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
	
	func removeObject(at index: Int) {
		guard index < count else {
			assert(false)
			return
		}
		removePointer(at: index)
	}
	// NSPointerArray's own compact method doesnt work - https://gist.github.com/benvium/6854ed90c5bc3861afdd
	func compact() {
		for i in (0..<count).reversed() {
			if object(at: i) == nil {
				removePointer(at: i)
			}
		}
	}
}
