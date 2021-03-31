import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';




class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        title: Text(
          "Your's e-shop",
          style: TextStyle(fontSize: 55.0,color: Colors.white,fontFamily: "signatra"),
        ),
        centerTitle: true,
        ),
      body: AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{
  final TextEditingController _adminIdTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width,_screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.lightGreenAccent],
            begin: FractionalOffset(0.0,0.0),
            end : FractionalOffset(1.0,0.0),
            stops: [0.0,1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child:  Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 8.0),
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "images/admin.png",
                height: 240,
                width: 240,
              ),
            ),
            Padding(
              padding:EdgeInsets.all(8.0),
              child: Text(
                "Admin",
                style: TextStyle(color:Colors.white),
              ),
            ),
            SizedBox(height: 15.0,),
            Form(
                key:_formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _adminIdTextEditingController,
                      data : Icons.email_outlined,
                      hintText: "Email",
                      isObsecure: false,
                    ),
                    CustomTextField(
                      controller: _passwordTextEditingController,
                      data : Icons.person,
                      hintText: "Password",
                      isObsecure: true,
                    ),
                  ],
                )
            ),
            SizedBox(height: 20.0,),
            RaisedButton(
              onPressed: () {
                _adminIdTextEditingController.text.isNotEmpty
                    &&_passwordTextEditingController.text.isNotEmpty
                    ? loginAdmin()
                    : showDialog(
                    context:context,
                    builder :(c){
                      return ErrorAlertDialog(message: "Please enter password and email properly");
                    }
                );
              },
              color: Colors.pink,
              child: Text("Login", style: TextStyle(color:Colors.white,),),
            ),
            SizedBox(height: 30.0,),
            Container(
              height: 4.0,
              color:Colors.pink,
              width: _screenWidth*0.8,

            ),
            SizedBox(height: 15.0,),
            FlatButton.icon(
              onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => AuthenticScreen())),
              icon: (Icon(Icons.nature_people, color:Colors.pink)),
              label: Text("I'm not a Admin",style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 50.0,),
          ],
        ),
      ),
    );
  }
  loginAdmin(){
    Firestore.instance.collection("admins").getDocuments().then((snapshot){
      snapshot.documents.forEach((result) {
        if(result.data["id"] != _adminIdTextEditingController.text.trim())
        {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("your id is not Correct"),));
        }

        else if(result.data["password"] != _passwordTextEditingController.text.trim())
          {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("your password is not Correct"),));
          }
        else{
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Welcom to admin Page" + result.data["name"] ),));
          setState(() {
            _adminIdTextEditingController.text = "";
            _passwordTextEditingController.text = "";
          });
          Route route = MaterialPageRoute(builder: (_)=>UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
