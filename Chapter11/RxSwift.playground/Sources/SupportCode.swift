import Foundation

public func example(for desc: String, actionToPerform: () -> Void) {
    print("\n... Example for:", desc, ".....")
    actionToPerform()
}

public enum CustomError: Error {
    case test
}
