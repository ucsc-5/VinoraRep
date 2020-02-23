import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:targets/models/user_repository.dart';


class MockFirebaseAuth extends Mock implements FirebaseAuth{}
class MockFirebaseUser extends Mock implements FirebaseUser{}
class MockAuthResult extends Mock implements AuthResult{}

void main(){ 
  MockFirebaseAuth _auth=MockFirebaseAuth();
  BehaviorSubject<MockFirebaseUser> _user=BehaviorSubject<MockFirebaseUser>();
  when(_auth.onAuthStateChanged).thenAnswer((_){
    return _user;
  });
  UserRepository _repo=UserRepository.instance(auth: _auth);
  group('user repository test', (){
    when(_auth.signInWithEmailAndPassword(email: 'ret4@gmail.com', password: '123456')).thenAnswer((_)async{
      _user.add(MockFirebaseUser());
      return MockAuthResult();
    });

    when(_auth.signInWithEmailAndPassword(email: "mail",password: "pass")).thenThrow((){
      return null;
    });
    /*test('sign in with email and password', ()async{
      bool signedIn=await _repo.signIn('ret4@gmail.com', '1234856');
      expect(signedIn, true);
      expect(_repo.status, Status.Authenticating);
    });

    test("sing in fails with incorrect email and password",() async {
      bool signedIn = await _repo.signIn("mail", "pass");
      expect(signedIn, false);
      expect(_repo.status, Status.Unauthenticated);
    });

    test('sign out', ()async{
      await _repo.signOut();
      expect(_repo.status, Status.Authenticated);
    });*/
  });
}