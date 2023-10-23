import 'package:firebase_auth/firebase_auth.dart';
import 'favorite_place.dart'; 

class UserModel {
   String uid;
   String displayName;
   String email;
   String photoURL;
   List<FavoritePlace> favoritePlaces; 

  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoURL,
    required this.favoritePlaces, 
  });

  factory UserModel.fromJson(User? user) {
    return UserModel(
      uid: user!.uid,
      displayName: user.displayName ?? '',
      email: user.email ?? '',
      photoURL: user.photoURL ?? '',
      favoritePlaces: [], 
    );
  }
}
