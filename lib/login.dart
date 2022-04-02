import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:notice_board/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool indicator = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: Column(
          children: [
            const Text('Login',style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold,color: Colors.white,),),
            const SizedBox(height: 32,),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your E-mail',
                    hintStyle: TextStyle(color: Colors.white),
                    label: Text('E-mail'),
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff3700B3),width: 1,),),
                    focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                  ),

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: _passController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    
                    hintText: 'Enter your Password',
                    hintStyle: TextStyle(color: Colors.white),
                    label: Text('Password'),
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff3700B3),width: 1,),),
                    focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                  ),

                  ),
                ),
              ),
              const SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                child: InkWell(
                  onTap: () async{
                    setState(() {
                      indicator = true;
                    });
                    try {
                      await firebaseAuth.signInWithEmailAndPassword(email: _emailController.text, password: _passController.text);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),));
                      setState(() {
                        indicator = false;
                      });
                    }
                    catch(e){
                      final snackbar = SnackBar(content: Text(e.toString()));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      setState(() {
                        indicator = false;
                      });
                    }
                  },
                  child: Container(
                    height: 46,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xff3700B3),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Center(
                      child: indicator? const CircularProgressIndicator() : const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
      ),
        ),),
    );
  }
}