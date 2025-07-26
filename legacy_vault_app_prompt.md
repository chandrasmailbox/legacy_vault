**Prompt for GitHub AI Code Assistant or GPT-based Code Generation Tool**

---

**Project Name:** Legacy Vault - Secure Offline Password Inheritance App

**Request:**
Build a full-stack application using **React Native with Expo Go and TypeScript**, supporting both **mobile and web** platforms (via Expo Web). The app is called **Legacy Vault**.

---

### App Concept:
Legacy Vault is a **secure digital inheritance application**. It helps users manage their digital assets and ensure that passwords, notes, or other secure information can be **safely shared with nominated family members** upon their death. The app functions **offline**, without the use of cloud or external servers.

---

### Key Features:

1. **User Vault Creation**
   - Users create a **secure local vault** protected by a master password.
   - Vault can contain credentials, notes, files, etc.
   - Data is encrypted and stored locally.

2. **Nominee Setup**
   - Users can **assign nominees** (e.g., family members) who also have the app installed.
   - Device-to-device secure pairing via QR code, Bluetooth, or LAN.

3. **Proof-of-Life Monitoring**
   - App periodically prompts the user to confirm activity.
   - If user fails to respond within a configured duration, vault access is released to nominee(s).

4. **Offline Architecture**
   - No use of cloud or external servers.
   - All storage is **local**.
   - Use **local encrypted storage** and **peer-to-peer communication** (e.g., QR, BLE, WebRTC).

5. **Web Compatibility**
   - Web version can allow vault viewing, editing, and nominee configuration.
   - Offline-first design. Fallback for web users without full functionality.

---

### Technical Requirements:

- **Framework:** React Native (Expo SDK) with TypeScript
- **Platform Support:** iOS, Android, Web
- **Libraries/Tools:**
  - `expo-secure-store` / `react-native-encrypted-storage` for secure vault storage
  - `expo-notifications` for proof-of-life pings
  - `react-native-ble-plx`, `react-native-webrtc`, or QR code libraries for local communication
  - `expo-router` for navigation
  - `react-hook-form`, `zod` for forms and validation

---

### Desired Output:

1. Scaffolded file/folder structure for the entire app
2. Code for:
   - Secure vault creation and encryption/decryption
   - Nominee registration and device pairing
   - Proof-of-life logic and triggers
   - Secure local transfer of vault data
3. Support for Expo Web version
4. Comments and documentation in code
5. Instructions on how to simulate death detection for dev/test

---

**Note:**
No cloud APIs should be used. Focus entirely on **offline-first** security and peer-to-peer encryption. Assume this app must run in isolated environments (e.g., personal phones not always connected to internet).

---

Please begin by scaffolding the folder structure and initial setup files.

