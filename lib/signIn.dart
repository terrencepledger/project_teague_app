import 'package:google_sign_in/google_sign_in.dart';

class SignIn {

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      // 'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  GoogleSignInAccount currentUser;
  String userId;
  Function _listener;

  SignIn() {

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      if (currentUser != null) {
        if(_listener != null) {
          _listener.call(currentUser.displayName);
          currentUser.authentication.then((value) => userId = value.idToken);
        }
      }
    });
    
    handleSignIn();

  }

  Future<void> handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      currentUser = _googleSignIn.currentUser;
      // _listener.call(currentUser.displayName);
    } catch (error) {
      print(error);
    }
  }

  Future<void> handleSignOut() => _googleSignIn.disconnect();

  void listener(Function func) {
    if(currentUser != null)
    {
      func.call(currentUser.displayName);
    }
    else
    {
      _listener = func;
    }
  }

}

  // Widget _buildBody() {
//     GoogleSignInAccount? user = _currentUser;
//     if (user != null) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           ListTile(
//             leading: GoogleUserCircleAvatar(
//               identity: user,
//             ),
//             title: Text(user.displayName ?? ''),
//             subtitle: Text(user.email),
//           ),
//           const Text("Signed in successfully."),
//           Text(_contactText),
//           ElevatedButton(
//             child: const Text('SIGN OUT'),
//             onPressed: _handleSignOut,
//           ),
//           ElevatedButton(
//             child: const Text('REFRESH'),

//   }

// }