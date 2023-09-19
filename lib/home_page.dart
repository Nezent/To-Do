import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notice_board/add.dart';
import 'package:notice_board/details_page.dart';
import 'package:notice_board/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Drawer(
          backgroundColor: const Color(0xff121212),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/name.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ListTile(
                          leading: FirebaseAuth.instance.currentUser == null
                              ? const Icon(
                                  Icons.admin_panel_settings_outlined,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.logout_outlined,
                                  color: Colors.white,
                                ),
                          title: FirebaseAuth.instance.currentUser == null
                              ? const Text(
                                  'Login',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                )
                              : const Text(
                                  'Log Out',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                          onTap: FirebaseAuth.instance.currentUser == null
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                }
                              : () {
                                  FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const HomePage(),
                                      ));
                                }),
                    ],
                  ),
                  const Text(
                    'Alpha-1.0',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: FirebaseAuth.instance.currentUser == null ? false : true,
        child: FloatingActionButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddingNotice(),
              )),
          backgroundColor: const Color(0xff03DAC5),
          child: const Icon(
            Icons.add_outlined,
            color: Colors.black,
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xff1F1F1F),
        title: const Text("ECE-20"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: StreamBuilder<Object>(
            stream: FirebaseFirestore.instance.collection('notice').snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> document =
                      snapshot.data.docs[index].data() as Map<String, dynamic>;
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(
                          title: document['title'],
                          description: document['description'],
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff2C2C2C),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            )
                          ],
                        ),
                        height: 56,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.task_alt_outlined,
                                      color: Color(0xffBB86FC),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                        child: Text(
                                      document['title'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      maxLines: 1,
                                    )),
                                  ],
                                ),
                              ),
                              Visibility(
                                  visible:
                                      FirebaseAuth.instance.currentUser == null
                                          ? false
                                          : true,
                                  child: IconButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('notice')
                                          .doc(snapshot.data.docs[index].id)
                                          .delete();
                                    },
                                    icon: const Icon(
                                      Icons.delete_outlined,
                                      color: Color(0xffFF0266),
                                    ),
                                    splashRadius: 24,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
