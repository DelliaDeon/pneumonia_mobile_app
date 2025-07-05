import 'dart:io';
import 'dart:typed_data';
import 'package:final_year_p/pages/info_page.dart';
import 'package:final_year_p/pages/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:final_year_p/logic/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../logic/prediction_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final imageHelper = ImageHelper();  // use provider later

class _HomePageState extends State<HomePage> {
  // storing image as bytes for web compatibility
  Uint8List? imageBytes;
  String? imageName;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        title: Center(child:Text(
          'PNEUMONIA DETECTION APP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w400,
          ),
        ),)
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey.shade100,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                // icon


                // home page
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context)=> HomePage()
                      ),
                    );
                  },
                  icon: Icon(CupertinoIcons.home),
                  label: const Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    foregroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                ),
                SizedBox(height: 20,),
            
                // info page
                // home page
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context)=> InfoPage()
                      ),
                    );
                  },
                  icon: Icon(CupertinoIcons.home),
                  label: const Text(
                    "Research",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
                SizedBox(height: 20,),


                // detected images
                // home page
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context)=> HomePage()
                      ),
                    );
                  },
                  icon: Icon(CupertinoIcons.home),
                  label: const Text(
                    "Storage",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
                SizedBox(height: 20,),


                // settings
                // home page
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context)=> SettingsPage()
                      ),
                    );
                  },
                  icon: Icon(CupertinoIcons.home),
                  label: const Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
                SizedBox(height: 20,),

              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Row(
                  children: [
                    // get started for free

                    // sign up

                    // sign in
                  ],
                ),
                SizedBox(height: 30,),

                // picture display widget
                // when tapped, a pop up of whether to delete
                GestureDetector(
                  onTap: (){

                  },

                  child: Container(
                    height: width * 0.8,
                    width: width * 0.8,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade300, width: 2),
                    ),
                    child:  imageBytes != null
                        ? Image.memory(imageBytes!)
                        : const Center(
                          child: Text(
                            'No Image Selected',
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                        ),
                  ),
                ),
                SizedBox(height: 20,),

                // upload single image button
                ElevatedButton.icon(
                  onPressed: () async {
                    final pickedFiles = await imageHelper.pickImage();
                    if (pickedFiles.isNotEmpty) {
                      final pickedImage = pickedFiles.first;

                      // read bytes from XFile for display
                      final bytes = await pickedImage.readAsBytes();
                      setState((){
                        imageBytes = bytes;
                        imageName = pickedImage.name;
                      });
                    }
                  },
                  icon: Icon(Icons.upload_file_outlined, size: 25,),
                  label: const Text("Upload X-Ray Photo",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                ),
                SizedBox(height: 30,),

                // uploading multiple images
                //MultipleImages(),


                // predict image button
                ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PredictionPage(
                            imageBytes: imageBytes!,
                            filename: imageName!,
                          )
                      ),
                    );
                  },
                  label: Text("Predict Image",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  icon: Icon(Icons.online_prediction),
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.blue.shade50,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),

              ],
            ),
          ),
        )
      ),
    );
  }
}



/*class MultipleImages extends StatefulWidget {
  const MultipleImages({super.key});

  @override
  State<MultipleImages> createState() => _MultipleImagesState();
}

class _MultipleImagesState extends State<MultipleImages> {
  // store multiple images as byte
  List<Uint8List> _imagesBytesList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _imagesBytesList.map(
              (bytes) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.blueGrey, width:1),
                ),
                child: Image.memory(
                  bytes,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
          ).toList(),
        ),
        const SizedBox(height: 20,),

        // upload image button
        ElevatedButton.icon(
          onPressed: () async {
            final pickedFiles = await imageHelper.pickImage(multiple: true);
            if (pickedFiles.isNotEmpty){
              // read bytes for each picked file concurrently
              final bytesList = await Future.wait(
                pickedFiles.map((file) => file.readAsBytes())
              );
              setState(() {
                _imagesBytesList = bytesList;
              });
            }
          },

          icon: Icon(Icons.collections_outlined),
          label: const Text("Upload Multiple Photos"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.blue,
            backgroundColor: Colors.blue.shade50,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )
          ),
        ),
        SizedBox(height: 20,),
      ],
    );
  }
}*/



