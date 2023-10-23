class FavoritePlace {
  int? id; 
  String name;
  double latitude;
  double longitude;
  String? imageUrl;
  String userId;

  FavoritePlace(
      {this.id,
      required this.name,
      required this.latitude,
      required this.longitude,
      required this.imageUrl,
      required this.userId});

  factory FavoritePlace.fromMap(Map<String, dynamic> map) {
    return FavoritePlace(
        id: map['id'],
        name: map['name'],
        latitude: map['latitude'],
        longitude: map['longitude'],
        imageUrl: map['imageUrl'],
        userId: map['userId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'userId': userId
    };
  }
}
