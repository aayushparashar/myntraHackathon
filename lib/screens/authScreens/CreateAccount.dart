import 'dart:io';

import 'package:MyntraHackathon/firebaseFunctions/firestoreFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class OnBoardFields extends StatefulWidget {
//  Function detailsUploaded;
  OnBoardFields();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OnBoardState();
  }
}

class OnBoardState extends State<OnBoardFields> {
  bool loading = false;
  Map<String, String> details = {
    'name': '',
    'description': '',
    'username': '',
  };
  ImageSource source;
  File _img;

  Future<void> selectImage() async {
    PickedFile img = await ImagePicker.platform.pickImage(source: source);
    if (img == null) return;
    _cropImage(File(img.path));
  }

  Future<Null> _cropImage(File image) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ]
          : [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio7x5,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Profile Picture',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      cropStyle: CropStyle.circle,
    );
    if (croppedFile != null) {
      setState(() {
        _img = croppedFile;
      });
    }
  }

  void getImage() async {
    showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                setState(() {
                  source = ImageSource.camera;
                });
                selectImage();
                Navigator.of(ctx).pop();
              },
              label: Text('Click From Camera'),
            ),
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                setState(() {
                  source = ImageSource.gallery;
                });
                selectImage();
                Navigator.of(ctx).pop();
              },
              label: Text('Choose from Gallery'),
            ),
          ],
        ));
  }

  var key = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return loading
        ? Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    )
        : Scaffold(
      bottomNavigationBar: Builder(
        builder: (context) => MaterialButton(
          color: Theme.of(context).accentColor,
          onPressed: () async {
            if (key.currentState.validate()) {
              setState(() {
                loading = true;
              });
              key.currentState.save();
              await FirestoreFunction.updateUserProfile(
                image: _img,
                description: details['description'],
                name: details['name'],
                username: details['username'],
              );
              setState(() {
                loading = false;
              });
              Navigator.of(context).pop();
            } else {
              Fluttertoast.showToast(
                  msg: 'Please fill all the fields');
            }
          },
          child: Text(
            'CREATE ACCOUNT',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          padding:
          EdgeInsets.symmetric(vertical: 14, horizontal: 79),
        ),
      ),
      body: GestureDetector(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: _img != null
                    ? Image.file(
                  _img,
                  height: 150,
                )
//                    CircleAvatar(
//                      child: CircleAvatar(
//                        radius: 50,
//                        backgroundImage: FileImage(_img),
//                      ),
//                      radius: 54,
//                      backgroundColor: Colors.white,
//                    )
                    : Image.asset(
                  'assets/profilePicture.png',
                  height: 100,
                ),
                onTap: getImage,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 27),
                child: Form(
                  key: key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'NAME',
                        style: TextStyle(
                            color: Color(0xFF555555).withOpacity(0.9),
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: TextFormField(
                          cursorColor: Theme.of(context).accentColor,
                          style: TextStyle(
//                                height: 0.5,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          validator: (val) {
                            if (val.length == 0) {
                              return 'Please Enter a name';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            details['name'] = val;
                          },
                          textCapitalization:
                          TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            hoverColor: Theme.of(context).accentColor,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                  color: Color(0xFFC4C4C4), width: 1),
                            ),
                          ),
                        ),
//                            height: 50,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'USERNAME',
                        style: TextStyle(
                            color: Color(0xFF555555).withOpacity(0.9),
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: TextFormField(
                          cursorColor: Theme.of(context).accentColor,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter(
                              RegExp("[a-zA-Z0-9_]"),
                              allow: true,
                            )
                          ],
                          onChanged: (val) {
                            if (val.length < 3) {
                              return 'Username too short';
                            }
                            return null;
                          },
                          validator: (val) {
                            if (val.length < 5)
                              return 'Username should at least be 5 characters';
                            return null;
                          },
                          onSaved: (val) {
                            details['username'] = val;
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your username',
                            hoverColor: Theme.of(context).accentColor,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                  color: Color(0xFFC4C4C4), width: 1),
                            ),
                          ),
                        ),
//                            height: 50,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'BIO',
                        style: TextStyle(
                            color: Color(0xFF555555).withOpacity(0.9),
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: TextFormField(
                          cursorColor: Theme.of(context).accentColor,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          validator: (val) {
                            if (val.length > 40) {
                              return 'Description should have less than 40 characters with new line character';
                            }
                            return null;
                          },
                          textCapitalization:
                          TextCapitalization.sentences,
                          inputFormatters: [
                            FilteringTextInputFormatter(
                              RegExp("[a-zA-Z0-9@\$%#!&* ]"),
                              allow: true,
                            )
                          ],
                          onSaved: (val) {
                            details['description'] = val;
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your bio',
                            hoverColor: Theme.of(context).accentColor,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                  color: Color(0xFFC4C4C4), width: 1),
                            ),
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                        ),
//                            height: 50,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
      ),
    );
  }
}