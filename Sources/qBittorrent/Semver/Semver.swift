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
        return lhs.patch < rhs.patch
    }
}
