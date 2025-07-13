# Legacy Vault System Architecture

## 🏗️ Architecture Overview

Legacy Vault follows a clean, modular architecture designed for security, maintainability, and cross-platform consistency. The application uses Flutter's reactive architecture with a focus on offline-first functionality and local data encryption.

## 📊 High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
├─────────────────────────────────────────────────────────────┤
│  Password Vault  │  Digital Will  │  Family Mgmt  │  Auth   │
│     Screens      │     Setup      │    Screens    │ Screens │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                      Widget Layer                           │
├─────────────────────────────────────────────────────────────┤
│   Custom Widgets   │   Reusable Components   │   Forms      │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                     Business Logic                          │
├─────────────────────────────────────────────────────────────┤
│  Password Mgmt  │ Inheritance  │  Encryption  │ Biometrics  │
│     Logic       │    Engine    │   Service    │   Service   │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                     Data Layer                              │
├─────────────────────────────────────────────────────────────┤
│   Local Storage   │   SQLite DB   │   Secure Store   │ Cache│
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                   Platform Layer                            │
├─────────────────────────────────────────────────────────────┤
│    iOS Native     │   Android Native   │   Device APIs     │
│     Services      │     Services       │   & Hardware     │
└─────────────────────────────────────────────────────────────┘
```

## 🎯 Architectural Principles

### 1. Offline-First Design
- **Local Data Storage**: All user data stored locally using SQLite
- **No Cloud Dependencies**: Application functions completely offline
- **Sync-Free Architecture**: No data synchronization with external servers
- **Local Encryption**: All sensitive data encrypted on device

### 2. Security-First Approach
- **Zero-Knowledge Architecture**: No sensitive data leaves the device
- **Multi-Layer Encryption**: AES-256 encryption with biometric key derivation
- **Secure Memory Management**: Sensitive data cleared from memory after use
- **Platform Security Integration**: Leverages iOS Keychain and Android Keystore

### 3. Modular Design
- **Feature-Based Modules**: Each major feature in its own module
- **Separation of Concerns**: Clear boundaries between layers
- **Reusable Components**: Shared widgets and utilities
- **Plugin Architecture**: Platform-specific functionality abstracted

### 4. Reactive Architecture
- **State Management**: Using Flutter's built-in state management
- **Event-Driven**: User actions trigger state changes
- **Reactive UI**: UI updates automatically based on state changes
- **Declarative Widgets**: UI declared based on current state

## 📱 Presentation Layer

### Screen Architecture
```
lib/presentation/
├── password_vault/           # Main password management
│   ├── password_vault.dart  # Main screen with tabs
│   └── widgets/             # Screen-specific widgets
├── digital_will_setup/      # Digital will configuration
│   ├── digital_will_setup.dart # Multi-step setup wizard
│   └── widgets/             # Setup flow widgets
├── family_management/       # Family member management
│   ├── family_management.dart # Family overview
│   └── widgets/             # Family-specific widgets
├── biometric_authentication_setup/ # Security setup
│   ├── biometric_authentication_setup.dart
│   └── widgets/             # Security widgets
└── add_edit_password/       # Password entry/editing
    ├── add_edit_password.dart
    └── widgets/             # Form widgets
```

### Navigation Architecture
- **Named Routes**: All navigation uses named routes for maintainability
- **Route Guards**: Authentication checks before sensitive screens
- **Deep Linking**: Support for direct navigation to specific features
- **Back Stack Management**: Proper navigation state management

### State Management Pattern
```dart
// StatefulWidget with local state management
class PasswordVault extends StatefulWidget {
  @override
  State<PasswordVault> createState() => _PasswordVaultState();
}

class _PasswordVaultState extends State<PasswordVault> {
  // Local state variables
  List<Map<String, dynamic>> _passwordEntries = [];
  String _selectedCategory = 'All';
  bool _isRefreshing = false;
  
  // State update methods
  void _filterEntries() {
    setState(() {
      // Update filtered entries
    });
  }
}
```

## 🧩 Widget Layer

### Custom Widget Architecture
```
lib/widgets/
├── custom_icon_widget.dart      # Standardized icon handling
├── custom_image_widget.dart     # Image loading and caching
└── custom_error_widget.dart     # Error display and handling
```

### Reusable Component Pattern
```dart
// Feature-specific widgets within each screen module
// Example: password_vault/widgets/
├── category_filter_widget.dart     # Category filtering
├── password_card_widget.dart       # Password display card
└── proof_of_life_banner_widget.dart # Check-in reminder
```

### Widget Design Principles
- **Single Responsibility**: Each widget has one clear purpose
- **Parameterized**: Widgets accept configuration through parameters
- **Reusable**: Common patterns extracted to shared widgets
- **Accessible**: Support for screen readers and accessibility features

## 🔧 Business Logic Layer

### Service Architecture
```
services/
├── encryption_service.dart      # AES-256 encryption/decryption
├── biometric_service.dart       # Biometric authentication
├── storage_service.dart         # Local data persistence
├── notification_service.dart    # Proof-of-life notifications
├── inheritance_service.dart     # Digital will logic
└── password_service.dart        # Password generation/validation
```

### Core Business Logic Components

#### 1. Encryption Service
```dart
class EncryptionService {
  // AES-256 encryption with biometric key derivation
  static Future<String> encrypt(String data, String key);
  static Future<String> decrypt(String encryptedData, String key);
  static Future<String> generateKey();
  static Future<bool> validateKey(String key);
}
```

#### 2. Inheritance Engine
```dart
class InheritanceEngine {
  // Manages digital will logic
  static Future<void> scheduleProofOfLife();
  static Future<void> processInheritance();
  static Future<void> notifyEmergencyContacts();
  static Future<void> transferData(List<FamilyMember> inheritors);
}
```

#### 3. Biometric Service
```dart
class BiometricService {
  // Platform-specific biometric authentication
  static Future<bool> isAvailable();
  static Future<bool> authenticate();
  static Future<String> generateBiometricKey();
  static Future<bool> validateBiometricKey();
}
```

## 💾 Data Layer

### Local Storage Architecture
```
data/
├── models/                  # Data models
│   ├── password_entry.dart # Password data structure
│   ├── family_member.dart  # Family member model
│   └── will_config.dart    # Digital will configuration
├── database/               # SQLite database
│   ├── database_helper.dart # Database initialization
│   ├── password_dao.dart   # Password data access
│   └── family_dao.dart     # Family data access
└── repositories/           # Data repositories
    ├── password_repository.dart
    └── family_repository.dart
```

### Database Schema
```sql
-- Passwords table (encrypted data)
CREATE TABLE passwords (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  encrypted_data TEXT NOT NULL,
  category TEXT NOT NULL,
  inheritance_status TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Family members table
CREATE TABLE family_members (
  id TEXT PRIMARY KEY,
  encrypted_data TEXT NOT NULL,
  relationship TEXT NOT NULL,
  is_emergency_contact BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Digital will configuration
CREATE TABLE will_config (
  id INTEGER PRIMARY KEY DEFAULT 1,
  check_in_interval TEXT NOT NULL,
  inheritance_delay_days INTEGER NOT NULL,
  last_check_in TIMESTAMP,
  is_active BOOLEAN DEFAULT TRUE
);
```

### Data Access Pattern
```dart
class PasswordRepository {
  static Future<List<PasswordEntry>> getAllPasswords();
  static Future<void> savePassword(PasswordEntry password);
  static Future<void> updatePassword(PasswordEntry password);
  static Future<void> deletePassword(String id);
  static Future<List<PasswordEntry>> searchPasswords(String query);
}
```

## 🔐 Security Architecture

### Encryption Strategy
1. **Master Key Derivation**: Generated from biometric authentication
2. **Data Encryption**: AES-256-GCM for all sensitive data
3. **Key Storage**: Platform keystore (iOS Keychain, Android Keystore)
4. **Memory Protection**: Sensitive data cleared after use

### Authentication Flow
```
User Input → Biometric Auth → Key Derivation → Data Decryption → UI Display
```

### Security Layers
1. **Device Security**: Screen lock and device encryption
2. **App Security**: Biometric authentication and PIN backup
3. **Data Security**: AES-256 encryption for all stored data
4. **Memory Security**: Secure memory handling for keys and passwords

## 🎨 UI/UX Architecture

### Theme System
```dart
// Centralized theme management
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme(...),
    textTheme: TextTheme(...),
    // ... other theme properties
  );
  
  static ThemeData darkTheme = ThemeData(
    // Dark theme configuration
  );
}
```

### Responsive Design
- **Sizer Package**: Percentage-based sizing for responsive layout
- **Breakpoint Management**: Different layouts for various screen sizes
- **Accessibility**: Support for dynamic text sizing and screen readers

### Design System Components
- **Color Palette**: Consistent color scheme based on "Trusted Depth" theme
- **Typography**: Inter font family with semantic sizing
- **Spacing**: 8px grid system for consistent spacing
- **Icons**: Material Design icons with custom security-focused icons

## 📱 Platform Integration

### iOS-Specific Features
- **Face ID/Touch ID**: Biometric authentication integration
- **Keychain Services**: Secure key storage
- **Background App Refresh**: Proof-of-life notifications
- **Privacy Indicators**: Respect for iOS privacy features

### Android-Specific Features
- **Biometric Prompt**: Fingerprint and face authentication
- **Android Keystore**: Hardware-backed key storage
- **Work Profile Support**: Enterprise device compatibility
- **Adaptive Icons**: Dynamic icon support

### Cross-Platform Abstractions
```dart
// Platform-agnostic interfaces
abstract class BiometricAuthProvider {
  Future<bool> isAvailable();
  Future<bool> authenticate();
}

class IOSBiometricProvider implements BiometricAuthProvider {
  // iOS-specific implementation
}

class AndroidBiometricProvider implements BiometricAuthProvider {
  // Android-specific implementation
}
```

## 🔄 Data Flow Architecture

### User Action Flow
```
User Interaction → Widget Event → State Update → Business Logic → Data Layer → UI Update
```

### Example: Adding a Password
1. User taps "Add Password" button
2. Navigation to `AddEditPassword` screen
3. User fills form and submits
4. Form validation in widget
5. Business logic encrypts password data
6. Data stored in local database
7. UI updates to show new password in vault
8. Success notification displayed

### Proof-of-Life Flow
1. Background timer triggers notification
2. User opens app and authenticates
3. Check-in recorded in database
4. Next check-in scheduled
5. UI updates proof-of-life status

## 🚀 Performance Architecture

### Memory Management
- **Widget Disposal**: Proper cleanup of StatefulWidgets
- **Image Caching**: Efficient image loading and caching
- **List Virtualization**: Lazy loading for large password lists

### Database Optimization
- **Indexed Queries**: Efficient database queries with proper indexing
- **Batch Operations**: Grouped database operations for performance
- **Connection Pooling**: Optimized database connection management

### UI Performance
- **Widget Rebuilding**: Minimal widget rebuilds using keys and const constructors
- **Animation Performance**: 60fps animations with proper optimization
- **List Performance**: Efficient list rendering with ListView.builder

## 🔧 Extension Points

### Plugin Architecture
- **Custom Authentication**: Support for additional authentication methods
- **Import/Export**: Pluggable data import/export mechanisms
- **Notification Providers**: Multiple notification delivery systems
- **Encryption Algorithms**: Support for different encryption methods

### Configuration System
- **Feature Flags**: Runtime feature enabling/disabling
- **Security Policies**: Configurable security requirements
- **UI Themes**: Customizable appearance and branding
- **Behavioral Settings**: User preference management

## 📈 Scalability Considerations

### Data Scalability
- **Efficient Storage**: Compressed and optimized data storage
- **Query Performance**: Indexed searches for large datasets
- **Memory Usage**: Minimal memory footprint for large vaults

### Feature Scalability
- **Modular Architecture**: Easy addition of new features
- **Plugin System**: Third-party feature integration
- **API Abstraction**: Clean interfaces for feature extension

### Platform Scalability
- **Cross-Platform Code**: Maximum code sharing between platforms
- **Platform Adaptation**: Easy platform-specific customization
- **Future Platform Support**: Architecture supports additional platforms

---

**Related Documentation:**
- [Security Architecture](./security-architecture.md)
- [Database Schema](./database-schema.md)
- [Development Setup](./development-setup.md)