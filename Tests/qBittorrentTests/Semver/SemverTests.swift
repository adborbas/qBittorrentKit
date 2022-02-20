//
//  SemverTests.swift
//  
//
//  Created by Adam Borbas on 2022. 02. 20..
//

import XCTest
import qBittorrent

class SemverTests: XCTestCase {
    func test_Init() {
        struct Scenario {
            let raw: String
            let expected: Semver
            let message: String
            
            static let all: [Scenario] = [
                Scenario(raw: "1.2.3",
                         expected: Semver(1, 2, 3),
                         message: "\"1.2.3\" should result valid Semver")
            ]
        }
        
        Scenario.all.forEach { scenario in
            let actualSemver = Semver(scenario.raw)
            XCTAssertEqual(scenario.expected, actualSemver, scenario.message)
        }
    }
    
    func test_Compareable() {
        struct Scenario {
            let lhs: Semver
            let rhs: Semver
            let smaller: Bool
            var message: String {
                return "\(lhs) < \(rhs) should be \(smaller)"
            }
            
            var switchedMessage: String {
                return "\(lhs) < \(rhs) should be \(!smaller)"
            }
            
            static let all: [Scenario] = [
                Scenario(lhs: Semver(0, 0, 0),
                         rhs: Semver(0, 0, 0),
                         smaller: false),
                Scenario(lhs: Semver(0, 0, 0),
                         rhs: Semver(1, 0, 0),
                         smaller: true),
                Scenario(lhs: Semver(0, 0, 0),
                         rhs: Semver(0, 1, 0),
                         smaller: true),
                Scenario(lhs: Semver(0, 0, 0),
                         rhs: Semver(0, 0, 1),
                         smaller: true),
                
                Scenario(lhs: Semver(1, 0, 0),
                         rhs: Semver(1, 1, 0),
                         smaller: true),
                Scenario(lhs: Semver(1, 0, 0),
                         rhs: Semver(1, 0, 1),
                         smaller: true),
                
            ]
        }
        
        Scenario.all.forEach { scenario in
            XCTAssertEqual(scenario.lhs < scenario.rhs, scenario.smaller, scenario.message)
            
            if scenario.lhs != scenario.rhs {
                XCTAssertEqual(scenario.lhs > scenario.rhs, !scenario.smaller, scenario.switchedMessage)
            }
        }
    }
}
