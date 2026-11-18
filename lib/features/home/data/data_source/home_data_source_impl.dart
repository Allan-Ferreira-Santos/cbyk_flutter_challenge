import 'package:firebase_auth/firebase_auth.dart';

import 'package:cbyk_flutter_challenge/features/home/data/data_source/home_data_source.dart';

class HomeDataSourceImpl implements HomeDataSource {
  HomeDataSourceImpl({required FirebaseAuth auth}) : _auth = auth;

  final FirebaseAuth _auth;

  @override
  Future<void> signOut() => _auth.signOut();
}
