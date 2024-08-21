import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    // MARK: - Private variables
    private let questionsAmount = 10
    private var correctAnswers = 0
    private var currentQuestionIndex = 0
    
    private var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private lazy var questionFactory: QuestionFactoryProtocol = QuestionFactory(
        delegate: self,
        moviesLoader: MoviesLoader())
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    // MARK: - Lifecycle
    init(viewController: MovieQuizViewControllerProtocol) {
            self.viewController = viewController
            
            questionFactory.loadData()
            viewController.changeLoadingIndicator(isHidden: false)
        }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func yesButtonClicked() {
        didAnswer(true)
    }
    
    func noButtonClicked() {
        didAnswer(false)
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.changeLoadingIndicator(isHidden: true)
        questionFactory.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func restartGame() {
        resetStatistics()
        questionFactory.requestNextQuestion()
    }
    
    // MARK: - Private functions
    private func showAnswerResult(isCorrect: Bool) {
        if (isCorrect) { correctAnswers += 1 }
        
        viewController?.showAnswer(isAnswerCorrect: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            statisticService.store(result: GameResult(
                correct: correctAnswers,
                total: questionsAmount,
                date: Date()))
            
            let resultViewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: """
            Ваш результат: \(self.correctAnswers)/\(self.questionsAmount)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.correct)/\(self.questionsAmount) (\(statisticService.bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """,
                buttonText: "Сыграть еще раз")
            
            viewController?.show(result: resultViewModel)
        } else {
            viewController?.changeLoadingIndicator(isHidden: false)
            viewController?.changeStateButton(isEnabled: true)
            self.switchToNextQuestion()
            
            questionFactory.requestNextQuestion()
        }
    }
    
    private func didAnswer(_ answer: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == answer)
    }
    
    private func isLastQuestion() -> Bool {
            currentQuestionIndex == questionsAmount - 1
    }
    
    private func resetStatistics() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
}
