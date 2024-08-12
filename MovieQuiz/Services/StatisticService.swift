import Foundation

final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case gamesCount
        case correctAnswers
        case totalAnswers
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalAccuracy
    }
    
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    private var correctAnswers: Int {
        get {
            return storage.integer(forKey: Keys.correctAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
        }
    }
    
    private var totalAnswers: Int {
        get {
            return storage.integer(forKey: Keys.totalAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalAnswers.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            return GameResult(
                correct: storage.integer(forKey: Keys.bestGameCorrect.rawValue),
                total: storage.integer(forKey: Keys.bestGameTotal.rawValue),
                date: storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date())
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            return storage.double(forKey: Keys.totalAccuracy.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalAccuracy.rawValue)
        }
    }
    
    func store(result: GameResult) {
        gamesCount += 1
        correctAnswers += result.correct
        totalAnswers += result.total
        
        totalAccuracy = (totalAnswers == 0) ? 0.0 : Double(correctAnswers) / Double(totalAnswers) * 100
        
        if (bestGame < result) {
            bestGame = result
        }
    }
}
