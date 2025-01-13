let questions = [];
let selectedAnswers = {};

// Aktualisiere den Fortschrittsbalken
function updateProgress() {
    const total = questions.length;
    const answered = Object.keys(selectedAnswers).length;
    const progressText = document.getElementById('progress');
    const progressFill = document.querySelector('.progress-fill');
    
    progressText.textContent = `${answered}/${total}`;
    progressFill.style.width = `${(answered / total) * 100}%`;
}

// Initialisiere das Quiz
window.addEventListener('message', function(event) {
    if (event.data.type === "showQuiz") {
        document.getElementById('quiz-container').style.display = 'block';
        // Hole die Fragen vom Server
        fetch('https://whitelist_quiz/getQuestions', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        });
    } else if (event.data.type === "setQuestions") {
        questions = event.data.questions;
        selectedAnswers = {};
        updateProgress();
        renderQuestions();
    } else if (event.data.type === "hidequiz") {
        document.getElementById('quiz-container').style.display = 'none';
        // Zurücksetzen der ausgewählten Antworten
        selectedAnswers = {};
        questions = [];
        updateProgress();
    }
});

// Rendere die Fragen
function renderQuestions() {
    const questionsContainer = document.getElementById('questions');
    questionsContainer.innerHTML = '';

    questions.forEach((question, index) => {
        const questionDiv = document.createElement('div');
        questionDiv.className = 'question';
        
        const questionTitle = document.createElement('h3');
        questionTitle.textContent = `Frage ${index + 1}: ${question.question}`;
        
        const optionsDiv = document.createElement('div');
        optionsDiv.className = 'options';
        
        question.options.forEach((option) => {
            const optionDiv = document.createElement('div');
            optionDiv.className = 'option';
            optionDiv.textContent = option;
            optionDiv.onclick = () => selectAnswer(index, option);
            
            if (selectedAnswers[index] === option) {
                optionDiv.classList.add('selected');
            }
            
            optionsDiv.appendChild(optionDiv);
        });
        
        questionDiv.appendChild(questionTitle);
        questionDiv.appendChild(optionsDiv);
        questionsContainer.appendChild(questionDiv);
    });
}

// Wähle eine Antwort aus
function selectAnswer(questionIndex, answer) {
    selectedAnswers[questionIndex] = answer;
    
    // Aktualisiere die visuelle Darstellung
    const options = document.querySelectorAll(`.question:nth-child(${questionIndex + 1}) .option`);
    options.forEach(option => {
        option.classList.remove('selected');
        if (option.textContent === answer) {
            option.classList.add('selected');
        }
    });
    
    // Aktualisiere den Fortschritt
    updateProgress();
    
    // Aktiviere den Submit-Button wenn alle Fragen beantwortet sind
    const submitButton = document.getElementById('submit-quiz');
    submitButton.disabled = Object.keys(selectedAnswers).length !== questions.length;
}

// Submit Button Event
document.getElementById('submit-quiz').addEventListener('click', function() {
    if (Object.keys(selectedAnswers).length === questions.length) {
        const answers = questions.map((_, index) => selectedAnswers[index]);
        fetch('https://whitelist_quiz/quizComplete', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                answers: answers
            })
        });
    }
}); 