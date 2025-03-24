# 🎡 random-choice-app

A beautiful Flutter application that lets users create a customizable spinning wheel for random selections. Perfect for making decisions, games, or any situation where you need a random choice.

## ✨ Features

- **Interactive Spinning Wheel**: Visually appealing wheel that spins to select a random choice
- **Custom Choices**: Add your own choices to the wheel
- **Persistent Storage**: Your choices are saved between sessions
- **Customization Options**:
  - Remove selected choices after spinning
  - Reset all choices after spinning
- **Clean UI**: Modern, minimalist design with smooth animations
- **Thai Language Support**: Full Thai language interface

## 🛠️ Tech Stack

- **Framework**: Flutter
- **State Management**: GetX
- **Animations**: Flutter Fortune Wheel
- **Storage**: SharedPreferences
- **Ad Integration**: Google Mobile Ads

## 📋 Usage

1. **Add Choices**:
   - Enter choices in the text field at the bottom
   - You can add multiple choices at once by separating them with spaces
   - Press "เพิ่ม" (Add) or hit Enter to add the choice(s)

2. **Spin the Wheel**:
   - Tap the "หมุน" (Spin) button to start the wheel
   - Wait for the wheel to stop spinning
   - View your randomly selected result

3. **Manage Choices**:
   - Delete individual choices by tapping the trash icon
   - Clear all choices by tapping "ลบทั้งหมด" (Delete All)

4. **Settings**:
   - Access settings by tapping the gear icon
   - Toggle "ลบตัวเลือกหลังหมุน" to remove selected choices after spinning
   - Toggle "รีเซ็ตหลังหมุน" to clear all choices after spinning

## 📥 Installation

```bash
# Clone the repository
git clone https://github.com/Phongphisut-Khenchat-Personal/random-choice-app.git

# Navigate to the project directory
cd random-choice-app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 📝 Project Structure

```
lib/
├── bindings/
│   └── app_binding.dart
├── controllers/
│   └── choice_controller.dart
├── services/
│   └── ad_service.dart
├── views/
│   └── home_view.dart
└── main.dart
```

## 🔧 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.x.x
  flutter_fortune_wheel: ^1.x.x
  shared_preferences: ^2.x.x
  google_mobile_ads: ^x.x.x
```

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

Made with ❤️ and Flutter
