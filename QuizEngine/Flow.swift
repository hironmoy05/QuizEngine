//
//  Flow.swift
//  QuizEngine
//
//  Created by Repcard on 22/10/23.
//

import Foundation

protocol Router {
    typealias AnswerCallback = (String) -> Void
    func routeTo(question: String, answerCallback: @escaping AnswerCallback)
    func routeTo(result: [String: String])
}

class Flow {
    private let router: Router
    private let questions: [String]
    
    private var result: [String: String] = [:]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, answerCallback: routeNext(from: firstQuestion))
        } else {
            router.routeTo(result: result)
        }
    }
    
    private func routeNext(from question: String) -> Router.AnswerCallback {
        return { [weak self] answer in
            if let strongSelf = self {
                strongSelf.routeNext(question: question, answer: answer)
            }
        }
    }
    
    private func routeNext(question: String, answer: String) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            result[question] = answer
            
            if currentQuestionIndex + 1 < questions.count {
                let nextQuestion = questions[currentQuestionIndex + 1]
                
                router.routeTo(question: nextQuestion, answerCallback: routeNext(from: nextQuestion))
            } else {
                router.routeTo(result: result)
            }
        }
    }
}
