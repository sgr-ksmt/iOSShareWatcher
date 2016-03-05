//
//  String+Extensions.swift
//  iOSShareWatcher
//
//  Created by Suguru Kishimoto on 2016/03/05.
//
//

import Foundation

extension String {
    
    private var ns: NSString {
        return (self as NSString)
    }
    
    func substringFromIndex(index: Int) -> String {
        return ns.substringFromIndex(index)
    }
    
    func substringToIndex(index: Int) -> String {
        return ns.substringToIndex(index)
    }
    
    func substringWithRange(range: NSRange) -> String {
        return ns.substringWithRange(range)
    }
    
    var lastPathComponent: String {
        return ns.lastPathComponent
    }
    
    var pathExtension: String {
        return ns.pathExtension
    }
    
    var stringByDeletingLastPathComponent: String {
        return ns.stringByDeletingLastPathComponent
    }
    
    var stringByDeletingPathExtension: String {
        return ns.stringByDeletingPathExtension
    }
    
    var pathComponents: [String] {
        return ns.pathComponents
    }
    
    var length: Int {
        return characters.count
    }
    
    var range: NSRange {
        return NSRange(location: 0, length: length)
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        return ns.stringByAppendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(ext: String) -> String? {
        return ns.stringByAppendingPathExtension(ext)
    }
    
}
