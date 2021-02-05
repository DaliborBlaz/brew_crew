import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brew_crew/models/myuser.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object baser on FireBaseUser
  MyUser _userFromFireBase(User user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  //auth chagne user stream
  Stream<MyUser> get user {
    return _auth.authStateChanges().map(_userFromFireBase);
  }

  //sing in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFireBase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  //sing in with email & pass

  Future signInWithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFireBase(user);
    } catch (e) {
      return null;
    }
  }

  //register with email and pass
  Future registerWithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      //create a new document for the new user
      await DatabaseService(uid: user.uid)
          .updateUserData('0', 'new crew member', 100);
      return _userFromFireBase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sing out

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
