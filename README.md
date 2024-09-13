# Flutter Real-Time Vocabulary Quiz Coding Challenge
Author: BaoTDK

## System Design Documents
### Architecture Diagram
![architecture](https://github.com/user-attachments/assets/9a233cb5-dc14-4be8-87ec-52a12ef3aa1e)

### Component Descriptions

1. **Mobile App (Flutter)**:
   - Provides the user interface for quiz participation
   - Manages user authentication and quiz state
   - Communicates with Firebase services for data storage and retrieval

2. **Firebase Authentication**:
   - Handles user authentication, primarily through anonymous sign-in
   - Ensures secure access to quiz features

3. **Firebase Realtime Database**:
   - Stores quiz data, including questions, user answers, and scores
   - Provides real-time updates for the leaderboard and quiz progression

4. **Firebase Remote Config**:
   - Stores and manages configuration data, including quiz questions
   - Allows for easy updates to quiz content without app redeployment

5. **Firebase Analytics**:
   - Tracks user interactions and quiz events
   - Provides insights into app usage and user behavior

6. **Firebase Crashlytics**:
   - Monitors and reports app crashes
   - Helps in identifying and fixing stability issues

### Data Flow

1. **User Joins Quiz**:
   - User enters room code and username in the mobile app
   - App authenticates user anonymously via Firebase Authentication
   - User data is added to the quiz participants in Firebase Realtime Database

2. **Quiz Progression**:
   - App fetches questions from Firebase Realtime Database
   - User submits answers through the app interface
   - Answers are sent to Firebase Realtime Database
   - Scores are calculated and updated in Firebase Realtime Database

3. **Leaderboard Updates**:
   - App listens to score changes in Firebase Realtime Database
   - Leaderboard is updated in real-time as scores change
   - Users see live updates of their ranking and others' scores

### Technology Justification

1. **Flutter**:
   - Enables cross-platform development for iOS and Android from a single codebase
   - Provides rich UI capabilities and good performance
   - Has a growing ecosystem and strong community support

2. **Firebase**:
   - Offers a suite of integrated services (Authentication, Realtime Database, Analytics, etc.)
   - Realtime Database enables live updates without complex server setup
   - Easily scalable and manageable, reducing backend development time

3. **GetX**:
   - Provides efficient state management and dependency injection
   - Simplifies reactive programming in Flutter
   - Reduces boilerplate code and improves app performance

4. **Go Router**:
   - Offers an efficient and flexible routing solution for Flutter apps
   - Supports deep linking and web URLs

### Screenshot App
<img width="914" alt="Screenshot 2024-09-13 at 19 53 31" src="https://github.com/user-attachments/assets/a922a78a-c194-4c6c-aa98-1b4a228d2e20">
<img width="914" alt="Screenshot 2024-09-13 at 19 53 18" src="https://github.com/user-attachments/assets/9e39ed4f-a79c-467d-8f67-10f95ced50f1">
<img width="914" alt="Screenshot 2024-09-13 at 19 53 09" src="https://github.com/user-attachments/assets/c9a5aa2a-91d5-4bdb-ab16-e84183df93ed">


### APK Install
https://drive.google.com/drive/folders/1pHN24a4TN2iqOLXHYeizvQDfN8bHAAD8?usp=sharing
