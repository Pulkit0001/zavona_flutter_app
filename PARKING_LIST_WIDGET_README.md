# Parking List Widget

A comprehensive Flutter widget for displaying and managing parking lists with filtering, pagination, and pull-to-refresh functionality.

## Features

- **Pagination**: Automatically loads more data as user scrolls
- **Pull-to-refresh**: Swipe down to refresh the list
- **Filtering**: Advanced filters for availability, verification, price range, distance, and society
- **Search**: Filter by various criteria
- **Loading States**: Proper loading, error, and empty states
- **Responsive Design**: Adapts to different screen sizes
- **Customizable**: Highly customizable callbacks and styling

## Components

### 1. ParkingListFilter
A model class that encapsulates all filtering parameters:

```dart
class ParkingListFilter {
  final String? owner;
  final String? societyName;
  final String? isVerified;
  final String? minSellingPrice;
  final String? maxSellingPrice;
  final String? minRentPricePerDay;
  final String? maxRentPricePerDay;
  final String? minRentPricePerHour;
  final String? maxRentPricePerHour;
  final String? availableToSell;
  final String? availableToRent;
  final String maxDistance;
  final double latitude;
  final double longitude;
  // ... constructor and methods
}
```

### 2. ParkingListState
State management for the parking list:

```dart
class ParkingListState {
  final EListState listState;
  final List<Datum> parkingList;
  final String? errorMessage;
  final ParkingListFilter? filter;
  final Pagination? pagination;
  final int currentPage;
  final int limit;
  final bool hasReachedMax;
  final bool isRefreshing;
  final bool isLoadingMore;
  // ... constructor and getters
}
```

### 3. ParkingListCubit
Business logic for managing parking list operations:

```dart
class ParkingListCubit extends Cubit<ParkingListState> {
  // Initialize with location
  Future<void> initialize({required double latitude, required double longitude});
  
  // Fetch parkings with pagination
  Future<void> fetchParkings({bool isRefresh = false, bool isLoadMore = false});
  
  // Pull-to-refresh
  Future<void> refresh();
  
  // Load more (pagination)
  Future<void> loadMore();
  
  // Apply filters
  Future<void> updateFilter(ParkingListFilter newFilter);
  Future<void> filterByAvailability({bool? availableToSell, bool? availableToRent});
  Future<void> filterByPriceRange({...});
  Future<void> filterBySociety(String? societyName);
  Future<void> filterByVerification(bool? isVerified);
  Future<void> updateMaxDistance(String maxDistance);
  
  // Clear filters
  Future<void> clearFilters();
}
```

### 4. ParkingListWidget
The main UI widget:

```dart
class ParkingListWidget extends StatefulWidget {
  final ParkingListFilter? initialFilter;
  final void Function(Datum parking)? onParkingTap;
  final void Function(Datum parking)? onBookNowTap;
  final bool showFilters;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollController? scrollController;
  // ... constructor
}
```

## Usage Examples

### Basic Usage

```dart
// In your page
class ParkingListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ParkingListCubit()..initialize(
        latitude: 19.0760,
        longitude: 72.8777,
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('Parking Spots')),
        body: ParkingListWidget(
          onParkingTap: (parking) {
            // Navigate to parking details
            Navigator.push(context, /* parking details page */);
          },
          onBookNowTap: (parking) {
            // Navigate to booking page
            Navigator.push(context, /* booking page */);
          },
        ),
      ),
    );
  }
}
```

### With Initial Filters

```dart
// Show only parking spots for rent
final filter = ParkingListFilter(
  availableToRent: 'true',
  isVerified: 'true',
  maxDistance: '5',
  latitude: 19.0760,
  longitude: 72.8777,
);

ParkingListWidget(
  initialFilter: filter,
  showFilters: true,
  onParkingTap: (parking) => _handleParkingTap(parking),
  onBookNowTap: (parking) => _handleBookNow(parking),
)
```

### Using Factory Methods

```dart
// Using the factory class for quick setups
Widget forRentPage = ParkingListPageFactory.forRent(
  latitude: 19.0760,
  longitude: 72.8777,
);

Widget forSalePage = ParkingListPageFactory.forSale(
  latitude: 19.0760,
  longitude: 72.8777,
);

Widget verifiedOnlyPage = ParkingListPageFactory.verifiedOnly(
  latitude: 19.0760,
  longitude: 72.8777,
);

Widget societyPage = ParkingListPageFactory.inSociety(
  societyName: "Green Valley Society",
  latitude: 19.0760,
  longitude: 72.8777,
);

Widget priceRangePage = ParkingListPageFactory.withPriceRange(
  latitude: 19.0760,
  longitude: 72.8777,
  minRentPricePerHour: '10',
  maxRentPricePerHour: '100',
);
```

### Manual Filter Updates

```dart
// In your widget with access to ParkingListCubit
void _applyFilters() {
  final cubit = context.read<ParkingListCubit>();
  
  // Filter by availability
  cubit.filterByAvailability(
    availableToRent: true,
    availableToSell: false,
  );
  
  // Filter by price range
  cubit.filterByPriceRange(
    minRentPricePerHour: '20',
    maxRentPricePerHour: '100',
  );
  
  // Filter by verification
  cubit.filterByVerification(true);
  
  // Update distance
  cubit.updateMaxDistance('15');
}
```

### Custom Styling

```dart
ParkingListWidget(
  padding: EdgeInsets.all(20),
  shrinkWrap: true,
  showFilters: false, // Hide default filters
  onParkingTap: (parking) {
    // Custom tap handling
  },
)
```

## Integration Steps

1. **Add dependencies** (already in pubspec.yaml):
   ```yaml
   dependencies:
     flutter_bloc: ^9.1.1
     cached_network_image: ^3.4.1
     google_fonts: ^6.3.0
   ```

2. **Register in locator** (if using dependency injection):
   ```dart
   // In your locator setup
   locator.registerFactory<ParkingListCubit>(() => ParkingListCubit());
   ```

3. **Use in your app**:
   ```dart
   // Example: Adding to a tab or navigation
   class HomePage extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return DefaultTabController(
         length: 3,
         child: Scaffold(
           appBar: AppBar(
             bottom: TabBar(
               tabs: [
                 Tab(text: 'All'),
                 Tab(text: 'For Rent'),
                 Tab(text: 'For Sale'),
               ],
             ),
           ),
           body: TabBarView(
             children: [
               // All parkings
               BlocProvider(
                 create: (_) => ParkingListCubit(),
                 child: ParkingListExamplePage(),
               ),
               // For rent
               ParkingListPageFactory.forRent(),
               // For sale
               ParkingListPageFactory.forSale(),
             ],
           ),
         ),
       );
     }
   }
   ```

## API Integration

The widget automatically integrates with your `ParkingsRepository.listParkings()` method. Make sure your repository returns `GetParkingListResponse` with proper pagination data.

## Customization

- **Styling**: Modify `AppColors` values to match your theme
- **Layout**: Adjust padding, margins, and sizing in the widget
- **Behavior**: Override methods in `ParkingListCubit` for custom business logic
- **UI Components**: Modify individual UI components in `ParkingListWidget`

## Error Handling

The widget includes comprehensive error handling:
- Network errors
- Location permission errors
- Empty states
- Loading states
- Retry functionality

## Performance Considerations

- Uses `ListView.builder` for efficient scrolling
- Implements pagination to avoid loading too much data
- Includes image caching with `CachedNetworkImage`
- Proper disposal of resources