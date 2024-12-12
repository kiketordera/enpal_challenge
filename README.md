# Solar Data Monitoring App

A Flutter-based mobile application for monitoring solar energy system data including solar generation, household consumption, and battery consumption. This project uses an API to fetch data, and visualizes it through interactive charts. Additionally, it supports multiple features such as unit toggling (W/kW), pull-to-refresh, dark mode, date filtering, and periodic data polling.

## Features

### Data Visualization
The application displays real-time power generation and consumption metrics using line charts. Three metrics are displayed, each on their own tab:
- Solar Generation
- House Consumption
- Battery Consumption

Each metric tab uses `fl_chart` for line visualization. The charts are scrollable horizontally if the number of data points exceed screen width.


### Date Filtering
Users can select a specific date using a date picker before viewing the data. The chosen date is passed to the API, and the corresponding data for that day is displayed on the charts.

### Unit Switching
A toggle in the AppBar allows users to switch between Watts (W) and Kilowatts (kW). The API returns values in watts, but the UI can scale and display them in kilowatts for convenience.
### Pull-to-Refresh
Swipe down on the charts to trigger a manual data refresh. The app will re-fetch data for the currently selected date and metric from the API.

### Data Polling
Data is automatically refreshed at a set interval (e.g., every 60 seconds) to ensure the displayed information remains up-to-date.

### Dark Mode Support
The application supports both light and dark mode, following the system theme by default. Themes are defined using Flutter’s `ThemeData` and `darkTheme` attributes.

## Architecture Overview
The project uses a clean architecture approach:
- **Domain Layer**: Contains business logic and entity definitions.
- **Data Layer**: Responsible for fetching data from the API and caching results.
- **Presentation Layer**: Implements the UI using Flutter widgets, and uses the BLoC architecture (`flutter_bloc`) for state management.


## State Management
All state handling is done using the [BLoC pattern](https://bloclibrary.dev/):
- **MonitoringBloc**: Manages the fetching and caching of monitoring data, as well as toggling units and clearing the cache.
- **MonitoringEvent**: Defines events such as `FetchMonitoringData`, `ClearMonitoringCache`, and `ToggleUnit`.
- **MonitoringState**: Represents different states: `MonitoringInitial`, `MonitoringLoading`, `MonitoringLoaded`, and `MonitoringError`.


## API Setup
A Dockerized API is provided. To run the API locally:

1. Ensure Docker is installed on your machine.
2. Run `docker-compose up` or the provided command in the repository.
3. The API will run on `http://localhost:3000`.
4. The application fetches data using `http://localhost:3000/monitoring?date=YYYY-MM-DD&type=TYPE`, where `TYPE` can be `solar`, `house`, or `battery`.

## How to Run
1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Make sure the API is running (e.g., via Docker).
4. Run `flutter run` to launch the app on an emulator or physical device.

The application should display a date picker initially. Select a date and then tap "Show Data" to navigate to the charts.


## Testing
### Unit Tests
The `bloc_test` package is used to ensure BLoC logic is correct:
- Tests cover transitions from `MonitoringInitial` to `MonitoringLoading`, and finally to either `MonitoringLoaded` or `MonitoringError`.
- The `ToggleUnit` and `ClearMonitoringCache` functionalities are also tested.

Run all tests:
```bash
flutter test
```

# Widget Tests

Widget tests validate the UI:

- Ensure the date picker displays the selected date.
- Confirm that charts show loading indicators, error states, or the correct data.
- Verify that pull-to-refresh triggers data fetching and that UI elements appear as expected.

All tests reside in the `test` directory and can be run using:
```bash
flutter test
```
