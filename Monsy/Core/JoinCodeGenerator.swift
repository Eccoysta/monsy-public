import Foundation

enum JoinCodeGenerator {
    static func generate() -> String {
        String(format: "%05d", Int.random(in: 0...99_999))
    }
}
