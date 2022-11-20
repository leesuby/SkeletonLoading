//
//  DispatchQueue.swift
//  SkeletonLoading
//
//  Created by LAP15335 on 21/11/2022.
//

import Foundation
extension DispatchQueue {
    
    private static var _onceTracker = [String]()

    class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        guard !_onceTracker.contains(token) else { return }

        _onceTracker.append(token)
        block()
    }

    class func removeOnce(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        guard let index = _onceTracker.firstIndex(of: token) else { return }
        _onceTracker.remove(at: index)
        block()
    }
    
}
