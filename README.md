# Task Management App for Gig Workers

A Flutter mobile application for managing tasks with user authentication, built using Clean Architecture and BLoC state management pattern.

## Screenshot

![WhatsApp Image 2025-12-24 at 6 16 49 PM](https://github.com/user-attachments/assets/9997774d-04e4-4140-95f7-b1ea367a3ded)
![WhatsApp Image 2025-12-24 at 6 16 47 PM](https://github.com/user-attachments/assets/546aabc0-4d6f-43e3-8f6c-a1c4e7ce5597)
![WhatsApp Image 2025-12-24 at 6 16 49 PM (1)](https://github.com/user-attachments/assets/0fe847c1-cec1-47a7-9e00-4a52cfb44492)
![WhatsApp Image 2025-12-24 at 6 16 50 PM](https://github.com/user-attachments/assets/d4a784c5-bd31-43e8-97b3-bd565b21be0d)
![WhatsApp Image 2025-12-24 at 6 16 50 PM (1)](https://github.com/user-attachments/assets/ace50123-a7b8-4b85-a762-acfa32232f3b)
![WhatsApp Image 2025-12-24 at 6 16 50 PM (2)](https://github.com/user-attachments/assets/c051f704-d5f3-4b50-989c-d3d9ef1d14aa)
![WhatsApp Image 2025-12-24 at 6 16 51 PM](https://github.com/user-attachments/assets/2f9205cb-8bf3-4f6a-b487-ac957462955c)
![WhatsApp Image 2025-12-24 at 6 16 51 PM (1)](https://github.com/user-attachments/assets/506ee9f3-34cd-4721-8db5-42bb638c0323)
![WhatsApp Image 2025-12-24 at 6 16 52 PM](https://github.com/user-attachments/assets/cc9001c1-e8c3-46c0-955a-84e38881375c)
![WhatsApp Image 2025-12-24 at 6 16 53 PM](https://github.com/user-attachments/assets/e33439c9-6fcb-45ab-b972-badd1315a154)
![WhatsApp Image 2025-12-24 at 6 16 54 PM](https://github.com/user-attachments/assets/7876ec43-e561-49b3-89e9-cce0a79a774c)


## 📱 Features


### Authentication
- ✅ User registration with email/password
- ✅ User login with email/password
- ✅ Automatic session management
- ✅ Secure logout functionality
- ✅ Error handling with user-friendly messages

### Task Management
- ✅ Create tasks with title, description, due date, and priority
- ✅ Edit existing tasks
- ✅ Delete tasks (with confirmation dialog)
- ✅ Mark tasks as complete/incomplete
- ✅ Real-time task synchronization

### Task Filtering & Sorting
- ✅ Filter by priority (Low, Medium, High)
- ✅ Filter by status (Complete, Incomplete)
- ✅ Automatic sorting by due date (earliest first)
- ✅ View all tasks option

### UI/UX
- ✅ Clean and responsive Material Design
- ✅ Adaptive layouts for different screen sizes
- ✅ Custom color scheme
- ✅ Loading indicators
- ✅ Empty state messaging
- ✅ Success/Error notifications
- ✅ Smooth animations

## 🏗️ Architecture

The app follows **Clean Architecture** principles with three main layers:

1. **Presentation Layer**: UI components, screens, widgets, and BLoC
2. **Domain Layer**: Business logic, entities, and use cases
3. **Data Layer**: Repository implementations and data sources

### State Management
- **BLoC (Business Logic Component)** pattern for predictable state management
- Separation of events, states, and business logic

### Dependency Injection
- **GetIt** for service locator pattern
- Lazy loading of dependencies

## 📦 Packages Used

```yaml
dependencies:
  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  
  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  
  # Dependency Injection
  get_it: ^7.6.4
  
  # Responsive Design
  responsive_sizer: ^3.3.0+1
  
  # Utilities
  intl: ^0.18.1
  dartz: ^0.10.1
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase account

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd task_management_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Setup Firebase**
   - Follow instructions in `FIREBASE_SETUP.md`
   - Add `google-services.json` to `android/app/`
   - Add `GoogleService-Info.plist` to iOS project (if needed)

4. **Run the app**
```bash
flutter run
```

## 🔥 Firebase Configuration

### Required Services
1. **Firebase Authentication**
   - Enable Email/Password authentication

2. **Cloud Firestore**
   - Create database in test mode
   - Apply security rules from `FIREBASE_SETUP.md`

### Firestore Structure
```
tasks/
  └── {taskId}
      ├── userId: string
      ├── title: string
      ├── description: string
      ├── dueDate: timestamp
      ├── priority: string (low|medium|high)
      ├── isCompleted: boolean
      └── createdAt: timestamp
```

## 📂 Project Structure

```
lib/
├── core/
│   ├── constants/          # App colors and strings
│   └── error/             # Error handling
├── data/
│   ├── datasources/       # Firebase data sources
│   ├── models/            # Data models
│   └── repositories/      # Repository implementations
├── domain/
│   ├── entities/          # Business entities
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business use cases
├── presentation/
│   ├── bloc/              # BLoC state management
│   ├── screens/           # UI screens
│   └── widgets/           # Reusable widgets
├── injection_container.dart
└── main.dart
```

## 🎨 Design Decisions

### Color Scheme
- **Primary**: Purple (#6C63FF)
- **Success**: Green (#10B981)
- **Warning**: Amber (#F59E0B)
- **Error**: Red (#EF4444)

### Typography
- Roboto font family
- Responsive font sizes using ResponsiveSizer

### Responsive Design
- Uses ResponsiveSizer for adaptive layouts
- Percentages for spacing (width % and height %)
- Adapts to different screen sizes and orientations

## 🧪 Testing

### Manual Testing Checklist
- [ ] User registration
- [ ] User login
- [ ] Create task
- [ ] Edit task
- [ ] Delete task
- [ ] Toggle task completion
- [ ] Filter by priority
- [ ] Filter by status
- [ ] Logout

## 📞 Support
For issues or questions, please create an issue in the repository.

---

**Built with ❤️ by Rakesh**
