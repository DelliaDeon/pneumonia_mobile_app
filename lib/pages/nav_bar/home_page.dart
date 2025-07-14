import 'dart:io';
import 'dart:typed_data';
import 'package:final_year_p/components/custom_button.dart';
import 'package:final_year_p/components/custom_icon_size_button.dart';
import 'package:final_year_p/logic/offline_pred_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:final_year_p/logic/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../logic/prediction_page.dart';

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
      backgroundColor: Colors.blueGrey.shade50,

      appBar: AppBar(
        leading: Image.asset('lib/assets/images/logo_w_text.png'),
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
            child: Icon(
              CupertinoIcons.person_alt_circle,
              color: Colors.blueGrey,
              size: 40,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40,),

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
                    height: width * 0.85,
                    width: width * 0.8,
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade600, width: 2),
                    ),
                    child:  imageBytes != null
                      ? Image.memory(imageBytes!)
                      : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(height: 10),
                            CircleAvatar(
                              radius: width * 0.3,
                              backgroundImage: AssetImage('lib/assets/images/Pneumonia_image.png')
                            ),
                            SizedBox(height: 10,),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                'Upload an X-ray image to check for pneumonia.',
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                          ],
                        ),
                      ),
                  ),
                ),
                SizedBox(height: 20,),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // upload single image button
                      CustomIconSizeButton(
                        onTap: () async{
                          final pickedFiles = await imageHelper.pickImage();
                          if (pickedFiles.isNotEmpty) {
                            final pickedImage = pickedFiles.first;

                            // read bytes from XFile for display
                            final bytes = await pickedImage.readAsBytes();
                            setState(() {
                              imageBytes = bytes;
                              imageName = pickedImage.name;
                            });
                          }
                        },
                        text: 'Upload image', icon: Icons.file_upload_outlined,
                        color: Colors.blueGrey.shade800,
                        height: width * 0.25,
                        width: width * 0.36,
                        textcolor: Colors.white,
                      ),
                      SizedBox(width: width * 0.05,),

                      // predict image
                      CustomIconSizeButton(
                        onTap: () async {
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
                        text: 'Predict Image',
                        icon: Icons.online_prediction,
                        color: Colors.blue.shade800,
                        height: width * 0.25,
                        width: width * 0.35,
                        textcolor: Colors.grey.shade200,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    children: [
                      Expanded(child: Divider(
                        color: Colors.grey,
                        thickness: 2,
                      )),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text('OR', style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),

                      Expanded(child: Divider(
                        color: Colors.grey,
                        thickness: 2,
                      )),
                    ],
                  ),
                ),

                SizedBox(height: 10,),

                // predict offline button
                CustomButton(
                  text: 'Predict Offline (No Grad-CAM Interpretation)',
                  color: Colors.blue.shade800,
                  textcolor: Colors.grey.shade200,
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OfflinePredictionPage(
                          imageBytes: imageBytes!,
                          filename: imageName!,
                        )
                      ),
                    );
                  }
                ),

                SizedBox(height: 20,),
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



