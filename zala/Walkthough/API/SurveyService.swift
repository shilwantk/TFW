//
//  SurveyService.swift
//  zala
//
//  Created by Kyle Carriedo on 5/11/24.
//

import Foundation
import Observation
import ZalaAPI

@Observable class SurveyService {
    
    var currentQuestion: ZalaQuestion? = nil
    var currentQuestionIndex: Int = 0
    var currentGroupIndex: Int = 0
    var complete: Bool = false
    
    var zalaConsent: AgreementModel? = nil
    var baseline: AssessmentModel? = nil
    var hasConsented: Bool = false
    var answers: Set<AnswerInput> = []
    var surveyStartTime: Date = .now
    var saving: Bool = false
    
    init() {
        complete = false
        loadQuestion()
        fetchPreference(key: .consent)
    }
    
    func reset() {
        currentQuestion = nil
        currentQuestionIndex = 0
        currentGroupIndex = 0
        answers = []
    }
    
    func insert(_ selection: AnswerInput?) {
        if let selection {
            answers.remove(selection)
            answers.insert(selection)
        }
    }
    
    func insert(_ selections:[AnswerInput]) {
        for selection in selections {
            answers.remove(selection)
        }
        answers.formUnion(selections)
    }
    
    
    func fetchPreference(key: String) {
        guard let userId = Network.shared.userId() else { return  }
        Network.shared.apollo.fetch(query: FetchPreferenceQuery(id: .some(userId))) { response in
            switch response {
            case .success(let result):
                let model = result.data?.user?.preferences?.first(where: {$0.fragments.preferenceModel.key == key})?.fragments.preferenceModel
                self.hasConsented = model != nil
                
            case .failure( _ ):
                self.hasConsented = false
            }
        }
    }
    
    func fetchData() {
        Network.shared.apollo.fetch(query: FetchConsentsQuery(org: .zalaOrg), cachePolicy: .fetchIgnoringCacheCompletely) { response in
            switch response {
            case .success(let result):
                let agreements = result.data?.org?.agreements?.nodes?.compactMap({$0?.fragments.agreementModel}) ?? []
                let assessments = result.data?.org?.assessments?.nodes?.compactMap({$0?.fragments.assessmentModel}) ?? []
                self.zalaConsent = agreements.last
                self.baseline = assessments.last
                
            case .failure(_):
                break
            }
        }
    }   
    
    func saveAssessment() {
        guard let userId = Network.shared.userId() else { return }
        guard !answers.isEmpty else { return }
        saving.toggle()
        let allAnswers = Array(answers)
        let input = UserAddDataInput(user: .some(userId),
                                     kind: .some(baseline?.kind ?? "zala_baseline"),
                                     name: .some(baseline?.name ?? "Zala Baseline"),
                                     beginEpoch: .some(Int(surveyStartTime.timeIntervalSince1970)),
                                     data: .some(allAnswers))
        
        Network.shared.apollo.perform(mutation: CreateVitalMutation(input: .some(input))) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                saving.toggle()
            case .failure(_):
                saving.toggle()
            }
        }
    }
        
    func didSignConsent() {
        guard let userId = Network.shared.userId() else { return }
        let input = UserUpdateInput(id: userId, preferences: .some([.init(key: "consent", value: ["true"])]))
        Network.shared.apollo.perform(mutation: UpdateUserMutation(input: .some(input), labels: .some([.superUserProfile]))){ response in
            switch response {
            case .success(_):
                self.hasConsented = true
                self.complete.toggle()
            case .failure(_):
                self.hasConsented = false
                self.complete.toggle()
                break
            }
        }
    }
 
    fileprivate func programActions() -> [Any] {
        if let json  = baseline?.program?._jsonValue as? [String: Any] {
            return json["actions"] as? [Any] ?? []
        } else {
            return questionnaireData["actions"] as? [Any] ?? []
        }
    }
    
    fileprivate func typeOf(group:[Any]) -> [String: String] {
        return group[1] as? [String : String] ?? [:]
    }
    
    fileprivate func questionsOf(group:[Any]) -> [Any] {
        return group.last as? [Any] ?? []
    }
    
    fileprivate func isQuestion(questions:[Any]) ->  Bool {
        guard let condition  = questions.first as? String else { return false }
        return condition.lowercased() == "question"
    }
    
    fileprivate func questionFrom(questions:[Any]) ->  ZalaQuestion? {
        guard let json = questions.last as? [String: Any] else { return nil }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) else { return nil }
        guard let question = try? JSONDecoder().decode(ZalaQuestion.self, from: jsonData) else { return nil }
        return question
    }
    
    fileprivate func getQuestionFrom(questions:[Any]) -> [Any] {
        return questions[currentQuestionIndex] as? [Any] ?? []
    }
    
    func questionsForGroup() -> [Any] {
        guard let group = programActions()[currentGroupIndex] as? [Any] else { return [] }
        let questions = questionsOf(group: group)
        return questions
    }
    
    fileprivate func hasNextGroup() -> Bool {
        return currentGroupIndex < programActions().count - 1
    }
    
    fileprivate func hasPreviousGroup() -> Bool {
        return currentGroupIndex != 0
    }
    
    fileprivate func atBeganing() -> Bool {
        return currentGroupIndex == 0 && currentQuestionIndex == 0
    }
    
    fileprivate func atStartOfGroup() -> Bool {
        return currentQuestionIndex == 0
    }
    
    func readyForNextQuestion() -> Bool {
        return currentQuestionIndex <= questionsForGroup().count
    }
    
    func getQuestion() -> ZalaQuestion? {
        return questionFrom(questions: getQuestionFrom(questions: questionsForGroup()))
    }
    
    func loadQuestion() {
        if isNew(question: questionFrom(questions: getQuestionFrom(questions: questionsForGroup()))) {
            currentQuestion = questionFrom(questions: getQuestionFrom(questions: questionsForGroup()))
        }
    }
    
    func isNew(question: ZalaQuestion?) -> Bool {
        if let question {
            return question.text != currentQuestion?.text
        } else {
            return false
        }
    }
    
    func moveForward() {
        if currentQuestionIndex < questionsForGroup().count - 1 {
            currentQuestionIndex += 1

        }
        else if hasNextGroup() {
            currentGroupIndex += 1
            currentQuestionIndex = 0
        }
        else {
            complete = true            
        }
    }
    
    func moveBack() {
        if currentQuestionIndex != 0 {
            currentQuestionIndex -= 1
            
        } else if hasPreviousGroup() {
            currentGroupIndex -= 1
            currentQuestionIndex = questionsForGroup().count - 1
        }
    }
}
