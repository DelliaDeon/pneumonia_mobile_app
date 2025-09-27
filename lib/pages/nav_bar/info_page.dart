import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  List<dynamic> sections = [];
  final Map<String, GlobalKey> sectionKeys = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState(){
    super.initState();
    loadContent();
  }

  // function to load json file and assign variables
  Future<void> loadContent() async{
    // load json file, and turn it into structured data
    final jsonString = await rootBundle.loadString("lib/assets/info.json");
    final jsonData = json.decode(jsonString);

    // assign sections and section keys
    setState(() {
      sections = jsonData;
      sectionKeys.clear();
      for(var section in jsonData){
        sectionKeys[section["id"]] = GlobalKey();
        print("Section keys populated: ${sectionKeys.keys}");
      }
    });
  }

  // function to scroll to specific sections
  void scrollToSection(String id){
    final keyContent = sectionKeys[id]?.currentContext;

    // scroll to the section
    if (keyContent != null){
      print("Scrolling to section: $id");
      Scrollable.ensureVisible(
        keyContent,
        duration: Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        alignment: 0.0,
      );
    }
    else {
      print("Section key context not found for: $id");
      print("Available keys: ${sectionKeys.keys}");
      scrollToSectionByIndex(id);
    }
  }


  // Alternative method using scroll controller directly
  void scrollToSectionByIndex(String id) {
    final index = sections.indexWhere((section) => section['id'] == id);
    if (index != -1) {
      // Estimate item height
      double estimatedOffset = 0;
      for (int i = 0; i < index; i++){
        final section = sections[i];
        final titleHeight = 90.0;
        final bodyHeight = (section['body'].length);
        final padding = 60.0;
        estimatedOffset += titleHeight + bodyHeight + padding;
      }

      _scrollController.animateTo(
        estimatedOffset,
        duration: Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade50,
        foregroundColor: Colors.blue.shade800,
        title: Center(child:Text(
          'PNEUMONIA CHECKER',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Image.asset('lib/assets/images/logo_w_text.png'),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
                Text("Sections", style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 20,),

                Expanded(
                  child: ListView.builder(
                    itemCount: sections.length,
                    itemBuilder: (context, index){
                      final _section = sections[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            WidgetsBinding.instance.addPostFrameCallback((_){
                              scrollToSection(_section['id']);
                            });
                          },

                          child: Text(
                            _section['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          )
                        ),
                      );
                    }
                  ),
                ),

              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
            child: sections.isEmpty
            ? Center(child: CircularProgressIndicator(),)
            :Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: sections.length,
                    itemBuilder: (context, index){
                      final section = sections[index];
                      return Container(
                        key: sectionKeys[section['id']],
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Text(
                              section['title'],
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors.blue.shade900,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 15,),

                            Text(
                              section['body'],
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 20,),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
