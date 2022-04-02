import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notice_board/home_page.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

// flutter local notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    
// firebase background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A Background message just showed up :  ${message.messageId}');
}

class AddingNotice extends StatefulWidget {
  const AddingNotice({ Key? key }) : super(key: key);

  @override
  State<AddingNotice> createState() => _AddingNoticeState();
}

class _AddingNoticeState extends State<AddingNotice> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  bool indicator = false;

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription : channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_lancher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new messageopen app event was published');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("${notification.title}"),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text("${notification.body}")],
                  ),
                ),
              );
            });
      }
    });
  }

  void showNotification() {
    flutterLocalNotificationsPlugin.show(
        0,
        _title.text,
        _description.text,
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add a Notice'),
        centerTitle: true,
        backgroundColor: const Color(0xff1F1F1F),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _title,
                decoration: const InputDecoration(
                  hintText: 'Enter a Title',
                  hintStyle: TextStyle(color: Colors.white),
                  label: Text('Title'),
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff3700B3),width: 1,),),
                  focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                ),

                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              controller: _description,
              minLines: 18,
              maxLines: 50,
              decoration: const InputDecoration(
                hintText: 'Enter Details',
                hintStyle: TextStyle(color: Colors.white),
      
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
                    await FirebaseFirestore.instance.collection('notice').add({'title': _title.text,'description': _description.text});
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),));
                      setState(() {
                        indicator = false;
                      });
                      showNotification();
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
                      'Add',
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
      ),
    );
  }
}