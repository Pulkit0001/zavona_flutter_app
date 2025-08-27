/// Base class for all request and query parameter classes
/// All parameter classes must extend this class and implement toJson method
abstract class BaseParams {
  /// Converts the parameters to a JSON map
  /// This method will be used to serialize the parameters for API calls
  Map<String, dynamic> toJson();
}

/// Base class for query parameters used in GET requests
abstract class BaseQueryParams extends BaseParams {
  @override
  Map<String, dynamic> toJson();
}

/// Base class for request body parameters used in POST, PUT, PATCH requests
abstract class BaseRequestParams extends BaseParams {
  @override
  Map<String, dynamic> toJson();
}
