import UIKit

protocol MovieRiddle {
    var name: String { get }
    var image: UIImage { get }
    var text: String { get }
    var correctAnswer: Answer { get }
    
    init(name: String, rating: Double, image: UIImage, riddleValue: Double, riddleSign: RiddleSign)
}
