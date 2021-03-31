import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;


class UploadPage extends StatefulWidget
{
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>
{
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptionTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _shortInfoTextEditingController = TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool Uploading = false;

  @override
  Widget build(BuildContext context) {
    return file == null ? displayAdminHomeScreen() : displayAdminUploadFormScreen();
  }

  displayAdminHomeScreen()
  {
    return Scaffold(


      appBar: AppBar(
        flexibleSpace : Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.lightGreenAccent],
              begin: FractionalOffset(0.0,0.0),
              end : FractionalOffset(1.0,0.0),
              stops: [0.0,1.0],
              tileMode: TileMode.mirror,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.border_color,color: Colors.white,),
          onPressed: ()
          {
            Route route = MaterialPageRoute(builder: (c)=>AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },

        ),
        actions: [
          FlatButton(
            child: Text("Logout",style: TextStyle(color: Colors.pink,fontSize: 16,fontWeight:FontWeight.bold),),
            onPressed:()
            {
              Route route = MaterialPageRoute(builder: (c)=>SplashScreen());
              Navigator.pushReplacement(context, route);
            },
          )
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }
  getAdminHomeScreenBody()
  {
    return  Container(
      //width: MediaQuery.of(context).size.height ;
      //height: MediaQuery.of(context).size.height ;
      decoration: BoxDecoration(

        gradient: LinearGradient(
          colors: [Colors.pink, Colors.lightGreenAccent],
          begin: FractionalOffset(0.0,0.0),
          end : FractionalOffset(1.0,0.0),
          stops: [0.0,1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.shop_two_rounded,color: Colors.pink,size: 200,),
            Padding(
              padding: EdgeInsets.only(top:20,),
              child:RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                child: Text(
                  "Add New Item",
                  style: TextStyle(fontSize: 20,color: Colors.white),

                ),
                color: Colors.green,
                onPressed: () => takeImage(context),
              )
            )
          ],
        ),
      ),
    );
  }

  takeImage(mcontext){
    return showDialog(
      context: mcontext,
      builder:(con)
        {
          return SimpleDialog(
            title: Text("Item Image",style: TextStyle(color:Colors.green,fontWeight: FontWeight.bold,)),
            children: [
              SimpleDialogOption(
                child: Text("Capture with Camera",style: TextStyle(color: Colors.green),),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text("Capture from  Gallary",style: TextStyle(color: Colors.green),),
                onPressed: capturePhotoFromGallary,
              ),
              SimpleDialogOption(
                child: Text("Cancek",style: TextStyle(color: Colors.green),),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),

            ],
          );
        }
    );
  }
  capturePhotoWithCamera() async
  {
    Navigator.pop(context);
    File imageFile =  await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 680,maxWidth: 970);
    setState((){
      file = imageFile;
    });
  }



  capturePhotoFromGallary() async
  {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery,);

    setState(() {
      file = imageFile;
    });
  }


  displayAdminUploadFormScreen(){
    return Scaffold(
      appBar: AppBar(
        flexibleSpace : Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
            colors: [Colors.pink, Colors.lightGreenAccent],
            begin: FractionalOffset(0.0,0.0),
            end : FractionalOffset(1.0,0.0),
            stops: [0.0,1.0],
            tileMode: TileMode.mirror,
            ),
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: clearFormInfo
          ),
        title:Text("New Product",style: TextStyle(color:Colors.white, fontSize: 24,fontWeight: FontWeight.bold)),
        actions:[
          FlatButton(
              onPressed: Uploading ? null: ()=> uploadImageandSaveItemInfo(),
              child: Text("Add",style: TextStyle(color:Colors.white, fontSize: 24,fontWeight: FontWeight.bold)),
          )
        ]
        ),
      body: ListView(
        children:[
          Uploading? linearProgress(): Text(""),
          Container(
           height: 230,
           width: MediaQuery.of(context).size.width *0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(image: DecorationImage(image:FileImage(file),fit: BoxFit.cover)),

                )
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12),),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Colors.pink,),
            title:Container(
              width:250,
              child:TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _shortInfoTextEditingController,
                decoration: InputDecoration(
                  hintText: "Short Info",
                  hintStyle: TextStyle(
                    color: Colors.deepPurpleAccent
                  ),
                  border: InputBorder.none,
                ),
              )
            )
          ),
          Divider(color: Colors.pink,),
          ListTile(
              leading: Icon(Icons.perm_device_information,color: Colors.pink,),
              title:Container(
                  width:250,
                  child:TextField(
                    style: TextStyle(color: Colors.deepPurpleAccent),
                    controller: _titleTextEditingController,
                    decoration: InputDecoration(
                      hintText: "Title",
                      hintStyle: TextStyle(
                          color: Colors.deepPurpleAccent
                      ),
                      border: InputBorder.none,
                    ),
                  )
              )
          ),
          Divider(color: Colors.pink,),
          ListTile(
              leading: Icon(Icons.perm_device_information,color: Colors.pink,),
              title:Container(
                  width:250,
                  child:TextField(
                    style: TextStyle(color: Colors.deepPurpleAccent),
                    controller: _descriptionTextEditingController,
                    decoration: InputDecoration(
                      hintText: "Description",
                      hintStyle: TextStyle(
                          color: Colors.deepPurpleAccent
                      ),
                      border: InputBorder.none,
                    ),
                  )
              )
          ),
          Divider(color: Colors.pink,),
          ListTile(
              leading: Icon(Icons.perm_device_information,color: Colors.pink,),
              title:Container(
                  width:250,
                  child:TextField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.deepPurpleAccent),
                    controller: _priceTextEditingController,
                    decoration: InputDecoration(
                      hintText: "Price",
                      hintStyle: TextStyle(
                          color: Colors.deepPurpleAccent
                      ),
                      border: InputBorder.none,
                    ),
                  )
              )
          ),
          Divider(color: Colors.pink,),
        ]
      ),
      );
  }
  clearFormInfo(){
    setState(() {
      file = null;
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _titleTextEditingController.clear();
      _shortInfoTextEditingController.clear();
    });
  }
  uploadImageandSaveItemInfo() async {
    setState(() {
      Uploading = true;
    });
    String imageDownloadUrl = await uploadItemImage(file);
    SaveItemInfo(imageDownloadUrl);

  }

  Future <String> uploadItemImage(mFileImage) async{

    final StorageReference storageReference = FirebaseStorage.instance.ref().child("Items");
    StorageUploadTask uploadTask = storageReference.child("product_$productId.jpg").putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  SaveItemInfo(String DownloadUrl){
    final itemsRef = Firestore.instance.collection("items");
    itemsRef.document(productId).setData({
     "title" : _titleTextEditingController.text.trim(),
     "shortInfo":_shortInfoTextEditingController.text.trim(),
     "publishedDate" : DateTime.now(),
     "thumbnailUrl": DownloadUrl,
     "longDescription" : _descriptionTextEditingController.text.trim(),
     "status" : "available",
     "price" :int.parse( _priceTextEditingController.text.trim()),
    });
    setState(() {
      file = null;
      Uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _titleTextEditingController.clear();
      _shortInfoTextEditingController.clear();
    });
  }
}


