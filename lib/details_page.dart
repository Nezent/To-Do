import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({ Key? key, required this.title, required this.description }) : super(key: key);
  final String title;
  final String description;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1F1F1F),
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back_outlined,),splashRadius: 24,),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w600,color: Colors.white,),),
                  const SizedBox(height: 16,),
                  // Text(widget.description,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.white,),),
                  Linkify(text: widget.description,onOpen: _onOpen,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.white,),),

                ],
              ),
            ),
      ),
    );
  }
  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
}

