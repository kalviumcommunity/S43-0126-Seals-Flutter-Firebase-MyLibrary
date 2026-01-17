
# 📚 Library Management Mobile Application

## 📌 Problem Statement

Public libraries often rely on **manual registers** for managing book inventories and borrowing records. This traditional approach causes:

- Inefficient book discovery  
- No real-time book availability  
- Long queues for reservations  
- Poor overall user experience  

Readers, students, and researchers expect **instant access and real-time updates**, which manual systems fail to provide.

---

## 💡 Solution Overview

We propose a **mobile-first Library Management Application** built using **Flutter** and **Firebase**.

The application enables users to:

- 🔍 Search and discover books instantly  
- 📖 Check real-time availability status  
- 🗓️ Reserve books digitally  
- 👤 Track borrowed and reserved books  

A **mobile app** is ideal because most library users primarily access services via smartphones and expect fast, real-time responses.

---

## 🚀 In Scope (Sprint #2)

- Flutter mobile application (Android-first)
- Firebase Authentication (Email/Password)
- Firestore database integration
- Book listing & availability status
- Book reservation functionality
- Core UI screens

---

## ❌ Out of Scope

- Push notifications  
- Admin analytics dashboard  
- Payment or fine collection  
- Barcode / QR code scanning  
- Multi-language support  

---

## ⭐ MVP Features

- User Authentication (Sign Up / Login / Logout)
- Book list fetched from Firestore
- Book availability status (Available / Reserved)
- Book reservation by logged-in user
- User dashboard showing reserved books
- Responsive Flutter UI
- Working APK build

---

## 🧩 Core App Components

### 🔐 Authentication
- Sign Up  
- Login  
- Logout  
- Forgot Password  

### 📱 Main Screens
- Splash Screen  
- Login / Signup Screen  
- Home Dashboard  
- Book List Screen  
- Book Details Screen  
- My Reservations Screen  
- Profile Page  

### 🗄️ Database (Firebase Firestore)
- `users` collection  
- `books` collection  
- `reservations` collection  

---

## ✅ Functional Requirements

- Users can register and authenticate securely using Firebase Auth  
- Users can view a list of available books  
- Users can reserve available books  
- Book availability updates in real time  
- User-specific reservations are stored in Firestore  

---

## ⚙️ Non-Functional Requirements

- **Performance:** Screen transitions under 200 ms  
- **Scalability:** Support at least 100 concurrent users  
- **Security:** Firestore rules based on authenticated users  
- **Reliability:** No data loss during refresh or app relaunch  
- **Responsiveness:** Adaptive UI for different screen sizes  

---

## 🛠️ Tech Stack

- **Frontend:** Flutter  
- **Backend:** Firebase  
- **Authentication:** Firebase Authentication  
- **Database:** Cloud Firestore  

---

## 📦 Build Output

- Android APK 

---

## 📄 License

This project is developed for academic and learning purposes for now.



- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/)