class BookingListFilter {
  final String? owner;
  final List<String>? status;
  final String? renter;
  final String? search;
  final String? sortby;

  const BookingListFilter({
    this.owner,
    this.status,
    this.renter,
    this.search,
    this.sortby,
  });

  /// Create initial filter with required owner
  factory BookingListFilter.initial({String? owner}) {
    return BookingListFilter(owner: owner);
  }

  /// Create filter for owner's bookings
  factory BookingListFilter.forOwner({
    required String owner,
    List<String>? status,
    String? sortby,
  }) {
    return BookingListFilter(owner: owner, status: status, sortby: sortby);
  }

  /// Create filter for renter's bookings
  factory BookingListFilter.forRenter({
    required String owner,
    required String renter,
    List<String>? status,
    String? sortby,
  }) {
    return BookingListFilter(
      owner: owner,
      renter: renter,
      status: status,
      sortby: sortby,
    );
  }

  /// Create search filter
  factory BookingListFilter.search({
    required String owner,
    required String searchQuery,
    List<String>? status,
    String? sortby,
  }) {
    return BookingListFilter(
      owner: owner,
      search: searchQuery,
      status: status,
      sortby: sortby,
    );
  }

  BookingListFilter copyWith({
    String? owner,
    List<String>? status,
    String? renter,
    String? search,
    String? sortby,
  }) {
    return BookingListFilter(
      owner: owner ?? this.owner,
      status: status ?? this.status,
      renter: renter ?? this.renter,
      search: search ?? this.search,
      sortby: sortby ?? this.sortby,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BookingListFilter &&
        other.owner == owner &&
        other.status == status &&
        other.renter == renter &&
        other.search == search &&
        other.sortby == sortby;
  }

  @override
  int get hashCode {
    return owner.hashCode ^
        status.hashCode ^
        renter.hashCode ^
        search.hashCode ^
        sortby.hashCode;
  }

  @override
  String toString() {
    return 'BookingListFilter(owner: $owner, status: $status, renter: $renter, search: $search, sortby: $sortby)';
  }
}
