import UIKit
import CoreML

class ViewController: UIViewController {

    // Sample data for the questionnaire
    let questions: [String] = [
        "What is your subject interest?",
        "What is your activity preference?",
        "How would you describe your technical skills?",
        "How do you approach decision-making?",
        "How do you handle stress?",
        "What is your job preference?"
    ]
    
    let options: [[String]] = [
        ["Math", "Science", "Art", "Technology", "Literature"],
        ["Coding", "Sports", "Reading", "Writing", "Painting"],
        ["Highly technical", "Moderately technical", "Not technical"],
        ["Logic and analysis", "Combination of both", "Intuition and feelings"],
        ["Calm", "Anxious but manage", "Procrastinate"],
        ["Remote", "On-site", "Office-based", "Mix of both"]
    ]
    
    var currentQuestionIndex = 0
    var selectedAnswers: [String?] = Array(repeating: nil, count: 6)

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        displayQuestion()
    }

    func displayQuestion() {
        questionLabel.text = questions[currentQuestionIndex]
        
        option1Button.setTitle(options[currentQuestionIndex][0], for: .normal)
        option2Button.setTitle(options[currentQuestionIndex].count > 1 ? options[currentQuestionIndex][1] : nil, for: .normal)
        option3Button.setTitle(options[currentQuestionIndex].count > 2 ? options[currentQuestionIndex][2] : nil, for: .normal)
        option4Button.setTitle(options[currentQuestionIndex].count > 3 ? options[currentQuestionIndex][3] : nil, for: .normal)
        
        nextButton.isHidden = true
    }

    @IBAction func optionSelected(_ sender: UIButton) {
        selectedAnswers[currentQuestionIndex] = sender.title(for: .normal)
        nextButton.isHidden = false
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        currentQuestionIndex += 1
        
        if currentQuestionIndex < questions.count {
            displayQuestion()
        } else {
            predictCareerField()
        }
    }

    func predictCareerField() {
        guard let model = try? CareerPredictionModel(configuration: MLModelConfiguration()) else {
            print("Failed to load model")
            return
        }

        // Check if all answers have been selected
        for answer in selectedAnswers {
            if answer == nil {
                // Show an alert to the user to select all answers
                let alert = UIAlertController(title: "Incomplete Answers", message: "Please answer all the questions before predicting your career field.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }
        }

        // Map selected answers to indices
        let subjectInterestIndex = mapToIndex(selectedAnswers[0]!)
        let activityPreferenceIndex = mapToIndex(selectedAnswers[1]!)
        let technicalSkillsIndex = mapToIndex(selectedAnswers[2]!)
        let decisionMakingIndex = mapToIndex(selectedAnswers[3]!)
        let stressHandlingIndex = mapToIndex(selectedAnswers[4]!)
        let jobPreferenceIndex = mapToIndex(selectedAnswers[5]!)

        // Prepare input for the model
        let input = CareerPredictionModelInput(
            subject_interest: Double(subjectInterestIndex),
            activity_preference: Double(activityPreferenceIndex),
            technical_skills: Double(technicalSkillsIndex),
            decision_making: Double(decisionMakingIndex),
            stress_handling: Double(stressHandlingIndex),
            job_preference: Double(jobPreferenceIndex)
        )
        
        // Make prediction
        do {
            let output = try model.prediction(input: input)
            let careerField = output.career_field
            showResult(careerField: careerField)
        } catch {
            print("Error making prediction: \(error)")
        }
    }
       
    func showResult(careerField: Int64) {
        let careerFields = [
            "Engineering",    // 0
            "Business",       // 1
            "Creative Arts",  // 2
            "Technology",     // 3
            "Education"       // 4
        ]
        
        // Ensure the index is within range
        let careerFieldString: String
        if careerField >= 0 && careerField < Int64(careerFields.count) {
            careerFieldString = careerFields[Int(careerField)]
        } else {
            careerFieldString = "Unknown"
        }
        
        let alert = UIAlertController(title: "Career Prediction", message: "Your predicted career field is: \(careerFieldString)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func mapToIndex(_ answer: String) -> Int64 {
        let answers = [
            options[0], // Subject Interest
            options[1], // Activity Preference
            options[2], // Technical Skills
            options[3], // Decision Making
            options[4], // Stress Handling
            options[5]  // Job Preference
        ]
        
        for (_, answerArray) in answers.enumerated() {
            if let answerIndex = answerArray.firstIndex(of: answer) {
                return Int64(answerIndex)
            }
        }
        return -1 // If the answer is not found
    }
}
