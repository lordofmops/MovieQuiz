import Foundation

struct GameResult : Comparable {
    // количество правильных ответов
    let correct: Int
    // количество вопросов квиза
    let total: Int
    // дата завершения раунда
    let date: Date
    
    static func < (lhs: GameResult, rhs: GameResult) -> Bool {
        return lhs.correct < rhs.correct
    }
}
