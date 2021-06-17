import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;

class SignIn {

  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  GoogleSignInAccount currentUser;
  Function _listener;

  SignIn() {
    print("Sign in  called");
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      currentUser = account;
      if (currentUser != null) {
        _handleGetContact(currentUser);
        if(_listener != null) {_listener.call(currentUser.displayName);}
      }
    });
    _handleSignIn();
    // _googleSignIn.signInSilently();

  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    print(currentUser.displayName);
    // final http.Response response = await http.get(
    //   Uri.parse('https://people.googleapis.com/v1/people/me/connections'
    //       '?requestMask.includeField=person.names'),
    //   headers: await user.authHeaders,
    // );
    // if (response.statusCode != 200) {
    //   print('People API ${response.statusCode} response: ${response.body}');
    //   return;
    // }
    // final Map<String, dynamic> data = json.decode(response.body);
    // final String namedContact = _pickFirstNamedContact(data);
    // setState(() {
    //   if (namedContact != null) {
    //     _contactText = "I see you know $namedContact!";
    //   } else {
    //     _contactText = "No contacts to display.";
    //   }
    // });
  }

  // String? _pickFirstNamedContact(Map<String, dynamic> data) {
  //   final List<dynamic>? connections = data['connections'];
  //   final Map<String, dynamic>? contact = connections?.firstWhere(
  //     (dynamic contact) => contact['names'] != null,
  //     orElse: () => null,
  //   );
  //   if (contact != null) {
  //     final Map<String, dynamic>? name = contact['names'].firstWhere(
  //       (dynamic name) => name['displayName'] != null,
  //       orElse: () => null,
  //     );
  //     if (name != null) {
  //       return name['displayName'];
  //     }
  //   }
  //   return null;
  // }

  Future<void> _handleSignIn() async {
    print("Inside handle");
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

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