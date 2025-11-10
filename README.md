# 🧾 Smart Quote Builder

**Smart Quote Builder** is a Flutter-based application that enables users to create, manage, and share professional business quotations digitally.  
It is designed for **freelancers, agencies, and businesses** who frequently prepare product or service quotes and want to simplify and modernize the process.

---

## 📘 Project Overview

The **Smart Quote Builder App** provides an intuitive interface to build product quotations by dynamically adding multiple items, applying discounts, taxes, and generating final totals in real-time.  
Users can input client information, save their progress locally, and export their quotes as **professional PDF documents**.

This project demonstrates skills in **Flutter UI design, state management, local data storage, and PDF generation**, following best software engineering practices.

---

## 🎯 Objectives

- Develop an interactive and responsive quote form for products and services.
- Perform automatic real-time calculations of totals, discounts, and taxes.
- Enable adding and removing multiple quote line items dynamically.
- Support **local saving** of quotes for offline use.
- Provide **PDF generation** and **sharing features** for final quotations.
- Deliver a clean, responsive, and professional **Material 3 UI**.

---

## 🧩 Key Features

### 🧾 1. Client Information Management
Users can input essential client details such as:
- Client name
- Address
- Reference or quotation ID

### 📦 2. Dynamic Line Item Management
Each quotation can include multiple line items with:
- Product/Service name
- Quantity
- Rate (price per unit)
- Discount (optional)
- Tax percentage (%)

Users can dynamically add or remove rows as needed.

### 💰 3. Automatic Calculations
Real-time quote calculations are handled using:
- Per-item total formula:  

((Rate - Discount) * Quantity) + Tax

- Subtotal: Sum of all item totals
- Grand Total: Final payable amount after applying taxes

### 💾 4. Local Data Persistence
- Uses `SharedPreferences` to store the last created quote.
- When reopened, the app automatically loads the saved quote for editing or reuse.

### 📤 5. PDF Generation & Sharing
- Users can preview the complete quote in a professional layout.
- The quote can be exported as a **PDF document** using the `pdf` package.
- Includes a **share** feature (via WhatsApp, email, or cloud drives) using `share_plus`.

### 🎨 6. Professional Light Theme UI
- Built with **Flutter Material 3 (M3)** design guidelines.
- Clean typography using **Google Fonts (Poppins)**.
- Consistent spacing, shadows, and color scheme for a premium look.

### ⚙️ 7. Responsive Layout
- Works smoothly across different screen sizes (phones and tablets).
- Scrollable and adaptive for both portrait and landscape modes.

---

## 🧱 Project Architecture

lib/
┣ 📁 models/
┃ ┗ quote_item.dart # Quote item data model and total calculation logic
┣ 📁 screens/
┃ ┣ quote_form_screen.dart # Main form screen for creating and editing quotes
┃ ┗ quote_preview_screen.dart # Displays a formatted quote preview and handles PDF export
┣ 📁 widgets/
┃ ┗ quote_item_row.dart # Reusable widget for each quote line item
┗ main.dart # App entry point, theme configuration



---

## ⚙️ Technologies & Packages Used

| Purpose | Package | Description |
|----------|----------|-------------|
| UI Framework | **Flutter** | For building responsive and cross-platform UI |
| Programming Language | **Dart 3.x** | Null-safe, modern backend logic |
| Local Storage | **shared_preferences** | To persist the last saved quote |
| PDF Generation | **pdf**, **printing** | To create and render professional PDF quotations |
| File Sharing | **share_plus** | Enables sharing the generated PDF |
| Currency Formatting | **intl** | Formats currency values (₹, $, €, etc.) |
| Fonts & Styling | **google_fonts** | For professional typography (Poppins font) |

---

## 💡 Technical Highlights

1. **Real-Time State Management**  
   The app uses Flutter’s built-in `setState()` for managing quote updates dynamically without external state libraries.

2. **Data Model Encapsulation**  
   All business logic for quote calculations resides in `quote_item.dart`, maintaining separation of concerns.

3. **Offline Storage**  
   Persistent storage is implemented with `SharedPreferences`, ensuring quotes remain available between sessions.

4. **PDF Builder Logic**  
   The app uses the `pdf` package to dynamically create pages, tables, and text elements for export-ready documents.

5. **Responsive Design**  
   Layouts are built with adaptive widgets like `SingleChildScrollView`, `Expanded`, and `ListView.builder` to handle varying screen sizes.

---

## 🧮 Core Formula Logic

```dart
double get total {
  final discounted = rate - discount;
  final base = discounted * quantity;
  final taxed = base + (base * (tax / 100));
  return taxed;
}
