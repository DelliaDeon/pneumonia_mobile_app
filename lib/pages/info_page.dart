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
  int _selectedIndex = 0;
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
      for(var section in jsonData){
        sectionKeys[section['id']] = GlobalKey();
      }
    });
  }

  // function to scroll to specific sections
  scrollToSection(String id){
    // get content of key; section
    final keyContent = sectionKeys[id]?.currentContext;

    // scroll to the section
    if (keyContent != null){
      Scrollable.ensureVisible(
        keyContent,
        duration: Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      drawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
                ListView.builder(
                  itemCount: sections.length,
                  itemBuilder: (context, index){
                    final _section = sections[index];
                    return Container(
                      key: sectionKeys[index],
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => scrollToSection(_section['id']),
                            child: Text(_section['id'])
                          ),
                        ],
                      ),
                    );
                  }
                )

              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                NavigationRail(
                  destinations: sections.map(
                      (s) => NavigationRailDestination(
                        icon: Icon(Icons.arrow_right),
                        label: Text(s['title']),
                      )
                  ).toList(),
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index){
                    scrollToSection(sections[index]['id']);
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),

                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: sections.length,
                    itemBuilder: (context, index){
                      final section = sections[index];
                      return Container(
                        key: sectionKeys[section['id']],
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              section['title'],
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 15,),

                            Text(
                              section['body'],
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
