import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(result: QuizResultsViewModel)
    
    func showAnswer(isAnswerCorrect: Bool)
    
    func changeLoadingIndicator(isHidden: Bool)
    
    func changeStateButton(isEnabled: Bool)
    
    func showNetworkError(message: String)
}
