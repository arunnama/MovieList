
import Foundation

extension NSError {
    static func createError(_ code: Int, description: String) -> NSError {
        return NSError(domain: "Movie error",
                       code: code,
                       userInfo: [
                        "NSLocalizedDescription" : description
            ])
    }
}
