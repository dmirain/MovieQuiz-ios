import Foundation

private let riddleDoubleFormatter: NumberFormatter = {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.minimumIntegerDigits = 1
    numberFormatter.minimumFractionDigits = 0
    numberFormatter.maximumFractionDigits = 1
    return numberFormatter
}()

extension Double {
    var asRiddleNum: String { riddleDoubleFormatter.string(for: self) ?? ""}
}
