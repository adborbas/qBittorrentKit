//
//  Semver.swift
//  
//
//  Created by Adam Borbas on 2022. 02. 20..
//

import Foundation

public struct Semver: Equatable, Comparable {
    private enum Constants {
        static let separator: Character = "."
    }
    
    let major: Int
    let minor: Int
    let patch: Int
    
    public init?(_ sematicVersion: String) {
        let split = sematicVersion.split(separator: Constants.separator)
        
        guard split.count == 3,
              let major = Int(split[0]),
              let minor = Int(split[1]),
              let patch = Int(split[2]) else { return nil }
        
        self.init(major, minor, patch)
    }
    
    public init(_ major: Int, _ minor: Int, _ patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
    
    public static func <(lhs: Semver, rhs: Semver) -> Bool {
            guard lhs.major == rhs.major else {
                return lhs.major < rhs.major
            }
            guard lhs.minor == rhs.minor else {
                return lhs.minor < rhs.minor
            }
//            guard lhs.patch == rhs.patch else {
                return lhs.patch < rhs.patch
//            }
           
//            return lhs.prerelease.lexicographicallyPrecedes(rhs.prerelease) { lpr, rpr in
//                if lpr == rpr { return false }
//                // FIXME: deal with big integers
//                switch (UInt(lpr), UInt(rpr)) {
//                case let (l?, r?):  return l < r
//                case (nil, nil):    return lpr < rpr
//                case (_?, nil):     return true
//                case (nil, _?):     return false
//                }
//            }
        }
}
