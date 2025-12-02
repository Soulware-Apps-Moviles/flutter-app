class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({
    required this.latitude,
    required this.longitude,
  });

  UserLocation copyWith({
    double? latitude,
    double? longitude,
  }) {
    return UserLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}