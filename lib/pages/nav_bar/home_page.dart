import 'dart:io';
import 'dart:typed_data';
import 'package:final_year_p/components/custom_button.dart';
import 'package:final_year_p/components/custom_icon_size_button.dart';
import 'package:final_year_p/logic/offline_pred_page.dart';
import 'package:final_year_p/pages/intro_screen.dart';
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
        leading: GestureDetector(
          onTap: (){
            Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(
                builder: (context)=> IntroScreen()),
                (Route<dynamic> route) => false,
            );
          },
          child: Icon(Icons.arrow_back_ios)),
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

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40,),
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
                      ? Stack (
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(imageBytes!,
                              height: width * 0.7, width: width * 0.8,
                              fit: BoxFit.cover,
                            )
                          ),
                        ),

                        // Delete icon (top-right corner)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                          onTap: () {
                        // confirm before deleting
                        showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text("Delete Image"),
                          content: const Text("Are you sure you want to remove this image?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context), // cancel
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  imageBytes = null;
                                  imageName = null;
                                });
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            ],
                           ),
                        );
                          },
                            child: const CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.delete, color: Colors.red),
                            ),
                          ),
                        ),
              ],
                    )
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
                          if (imageBytes != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PredictionPage(
                                  imageBytes: imageBytes!,
                                  filename: imageName!,
                                )
                              ),
                            );
                          } else {
                            showDialog(
                              context: context, 
                              builder: (context) => AlertDialog(
                                icon: Icon(Icons.error_outline),
                                title: Text('Image Not Selected'),
                                content: Text('Upload an Image to Predict'),
                                actions: [
                                  CustomButton(
                                    text: 'OK',
                                    color: Colors.blue.shade900,
                                    textcolor: Colors.white,
                                    onTap: () => Navigator.pop(context)
                                  ),
                                ],
                              ),
                            );
                          }
                          
                        },
                        text: 'Check Image',
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
                  text: 'Check Offline (No Grad-CAM Interpretation)',
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



