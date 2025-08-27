# Postman to Flutter Service Generator

This Node.js script automatically generates Flutter service classes from Postman collection JSON files. It creates type-safe service classes that use the BaseApiService mixin with proper error handling using the Either pattern.

## Features

- ✅ **Automatic Service Generation**: Creates complete Flutter service classes from Postman collections
- ✅ **Type-Safe Parameters**: Generates parameter classes for request/query parameters
- ✅ **Error Handling**: Uses Either<String, Map<String, dynamic>?> for robust error handling
- ✅ **BaseApiService Integration**: Generated services use your existing BaseApiService mixin
- ✅ **Smart Naming**: Intelligent method and class name generation
- ✅ **Parameter Type Inference**: Automatically infers Dart types from JSON values
- ✅ **Path Parameters**: Handles dynamic URL parameters like {userId}
- ✅ **Nested Objects**: Supports complex JSON request bodies
- ✅ **Multiple HTTP Methods**: Supports GET, POST, PUT, PATCH, DELETE

## Installation

1. Navigate to the scripts directory:
```bash
cd scripts
```

2. Install dependencies:
```bash
npm install
```

## Usage

### Basic Usage

```bash
node generator.js -i your_collection.json
```

### Advanced Usage

```bash
node generator.js -i your_collection.json -o ./lib/services -n CustomService -u https://api.myapp.com
```

### Command Line Options

- `-i, --input <file>` (required): Postman collection JSON file
- `-o, --output <dir>`: Output directory for generated files (default: ./generated_services)
- `-n, --name <name>`: Custom service class name (extracted from collection if not provided)
- `-u, --url <url>`: Base URL override (extracted from collection if not provided)

### Examples

1. **Generate from sample collection:**
```bash
node generator.js -i sample_collection.json
```

2. **Custom output directory:**
```bash
node generator.js -i my_api.json -o ../lib/core/services
```

3. **Custom service name:**
```bash
node generator.js -i users_api.json -n UserManagementService
```

## Generated Code Structure

The generator creates:

### 1. Parameter Classes
```dart
class GetAllUsersQueryParams extends BaseQueryParams {
  final int? page;
  final int? limit;
  final String? search;
  
  // Constructor and toJson method
}

class CreateUserRequestParams extends BaseRequestParams {
  final String name;
  final String email;
  final int? age;
  
  // Constructor and toJson method
}
```

### 2. Service Class
```dart
class UserManagementApiService with BaseApiService {
  static const String _baseUrl = 'https://api.example.com';

  Future<Either<String, Map<String, dynamic>?>> getAllUsers({
    GetAllUsersQueryParams? queryParams,
  }) async {
    // Implementation with error handling
  }

  Future<Either<String, Map<String, dynamic>?>> createUser({
    required CreateUserRequestParams requestParams,
  }) async {
    // Implementation with error handling
  }
}
```

## Postman Collection Requirements

### Collection Structure
Your Postman collection should include:

1. **Collection Info**: Name and description
2. **Variables**: Base URL (optional, can be extracted from requests)
3. **Requests**: Organized in folders (optional)

### Request Requirements
Each request should have:
- **Method**: GET, POST, PUT, PATCH, DELETE
- **URL**: Complete URL or relative path
- **Parameters**: Query parameters, path parameters
- **Body**: JSON body for POST/PUT/PATCH requests

### Example Collection Structure
```json
{
  "info": {
    "name": "My API",
    "description": "API description"
  },
  "variable": [
    {
      "key": "baseUrl",
      "value": "https://api.example.com"
    }
  ],
  "item": [
    {
      "name": "Users",
      "item": [
        {
          "name": "Get All Users",
          "request": {
            "method": "GET",
            "url": "{{baseUrl}}/users?page=1&limit=10"
          }
        }
      ]
    }
  ]
}
```

## Generated File Integration

After generation:

1. **Copy the generated file** to your Flutter project's services directory
2. **Update imports** if necessary:
```dart
import '../core/data/base_api_service.dart';
import '../core/data/base_params.dart';
```

3. **Use the service** in your app:
```dart
final userService = UserManagementApiService();

final result = await userService.getAllUsers(
  queryParams: GetAllUsersQueryParams(page: 1, limit: 10),
);

result.fold(
  (error) => print('Error: $error'),
  (data) => print('Success: $data'),
);
```

## Type Inference

The generator automatically infers Dart types:

| JSON Type | Dart Type |
|-----------|-----------|
| `"string"` | `String` |
| `123` | `int` |
| `123.45` | `double` |
| `true/false` | `bool` |
| `[...]` | `List<String>` |
| `{...}` | Flattened properties |

### Special Cases
- Email fields → `String`
- ID fields → `int`
- Price/Amount → `double`
- Flag/Enabled → `bool`

## Troubleshooting

### Common Issues

1. **File not found**: Ensure the Postman collection path is correct
2. **Invalid JSON**: Validate your collection JSON format
3. **No requests found**: Check that your collection has valid request items
4. **Import errors**: Update import paths in generated files

### Generated Code Issues

1. **Type mismatches**: Review and adjust inferred types manually
2. **Missing parameters**: Add any custom parameters not in the collection
3. **Complex objects**: Simplify nested JSON or handle manually

## Contributing

To extend the generator:

1. **Add new parameter types** in `inferParamType()`
2. **Customize naming** in `generateMethodName()`
3. **Add new templates** in `generateServiceMethod()`

## Sample Output

Run with the included sample collection:
```bash
node generator.js -i sample_collection.json
```

This generates a complete `UserManagementApiService` with methods for:
- `getAllUsers()` - GET with query parameters
- `getUserById()` - GET with path parameter
- `createUser()` - POST with request body
- `updateUser()` - PUT with path parameter and body
- `deleteUser()` - DELETE with path parameter
- `searchProducts()` - GET with query parameters
- `createProduct()` - POST with complex request body
