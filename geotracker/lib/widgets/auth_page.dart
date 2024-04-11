import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geotracker/widgets/user_image_picker.dart';

final _firebase = FirebaseAuth.instance;

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // Create a global key to get access to the form state
  final _form = GlobalKey<FormState>();

  var _isLogin = true;

  var _enteredEmail = '';
  var _enteredPassword = '';

  // Use async to handle the Future<UserCredentials>
  void _submit() async {
    final _isValid = _form.currentState!.validate();

    if (!_isValid) {
      return;
    }

    _form.currentState!.save();
    
    try {
      if (_isLogin) {
        // Log user in
        final UserCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        // Register user
        final UserCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      }
    } on FirebaseAuthException catch (error) {
        // Handle the error
        if (error.code == 'email-already-in-use') {
          //...
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication failed.'),
          ),
        );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
            child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 30,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            width: 200,
            child: Image.asset('assets/images/logo.png'),
          ),
          Card(
            margin: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!_isLogin) const UserImagePicker(),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                          floatingLabelStyle:
                              Theme.of(context).textTheme.bodySmall,
                          enabledBorder: const UnderlineInputBorder(
                            // Border style when enabled
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            // Border style when focused
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        // validator to handle the input validation
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredEmail = value!;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                          floatingLabelStyle:
                              Theme.of(context).textTheme.bodySmall,
                          enabledBorder: const UnderlineInputBorder(
                            // Border style when enabled
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            // Border style when focused
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        obscureText: true,
                        // Make sure the password is longer than 7 characters
                        validator: (value) {
                          if (value == null || value.trim().length < 7) {
                            return 'Password must be at least 7 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredPassword = value!;
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _submit,
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                              const Size(200, 40)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(80, 7, 120, 1),
                          ), // Background Color
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(5)), //
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10.0), // Round Radius
                            ),
                          ),
                        ),
                        child: Text(
                          _isLogin ? 'Login' : 'Register',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(
                          _isLogin
                              ? 'Create an account'
                              : 'I already have an account.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )));
  }
}
