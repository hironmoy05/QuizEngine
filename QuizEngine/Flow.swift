//
//  Flow.swift
//  QuizEngine
//
//  Created by Repcard on 22/10/23.
//

import Foundation

protocol Router {
    func routeTo(question: String, answerCallback: @escaping (String) -> Void)
}

class Flow {
    let router: Router
    let questions: [String]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion) { [weak self] _ in
                guard let strongSelf = self else { return }
                
                let nextQuestionIndex = strongSelf.questions.firstIndex(of: firstQuestion)!
                let nextQuestion = strongSelf.questions[nextQuestionIndex + 1]
                
                strongSelf.router.routeTo(question: nextQuestion) { _ in }
            }
        }
    }
}
