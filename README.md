# Flutter Frontend for Company and Service Management

This is the frontend Flutter app for managing **companies** and their **services**. The app allows users to list companies, create new companies, and add services to companies. It interacts with the backend API for data management.

## Technologies Used
- **Flutter**: The mobile app framework for building the user interface.
- **Dart**: Programming language used for writing the Flutter app.
- **Provider**: For state management.
- **http**: For making API requests to the backend.
- **JSON**: For data exchange with the backend API.

## Setup Instructions

1. **Clone the repository**:
   
   First, clone the repository to your local machine:

   ```bash
   git clone <repo-url>
   cd frontend

2. **Install dependencies:**
   
   Flutter uses `pub` to manage dependencies. Run the following command to install the necessary packages:
   
   ```bash
   flutter pub get
   
3. **Run the app:**
   
   Once the dependencies are installed, you can run the app on your emulator or physical device:
   
   ```bash
   flutter run
   ```
   
   The app should now be running on your local machine.

## Screens
The app contains the following key screens:
- **CompanyListScreen**: Displays a list of all companies, along with their services.
- **CreateCompanyScreen**: A form to create a new company (name and registration number).
- **CreateServiceScreen**: A form to create a new service (name, description, price, and company dropdown selector).
- **EditCompanyScreen**: A form to edit an existing company's details.
- **EditServiceScreen**: A form to edit the details of an existing service.
- **ServiceDetailScreen**: Displays detailed information about a service, with options to edit or delete it.

## API Integration
The frontend communicates with the backend API to perform the following actions:
- **Fetch** companies and their services.
- **Create**, **Edit**, and **Delete** companies and services.

## Example API Requests:
- **Fetch companies**: `GET /companies`
- **Create company**: `POST /companies`
- **Fetch service by ID**: `GET /services/:id`
- **Create service**: `POST /services`
  
Make sure the backend API is running before launching the Flutter app.

## Additional Notes
- Ensure the backend API is running on `http://localhost:5000` or the configured URL.
- Use either **Provider** or **Bloc** for state management.
- The app handles API errors and shows appropriate messages to users.
