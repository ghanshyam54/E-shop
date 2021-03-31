import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
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
          actions: [
            Stack(
              children: [
                IconButton(
                    icon: Icon(Icons.shopping_cart_sharp ,color :Colors.white, ),
                    onPressed: (){
                      Route route = MaterialPageRoute(builder: (c)=>CartPage());
                      Navigator.pushReplacement(context, route);
                    }
                ),
                Positioned(
                  child:Stack(
                    children: [
                      Icon(
                        Icons.brightness_1,
                        size : 20,
                        color: Colors.black87,
                      ),
                      Positioned(
                          top: 3.0,
                          bottom : 4.0,
                          left : 4,
                          child: Consumer<CartItemCounter>(
                            builder :(context,counter,_)
                            {
                              return Text(
                                counter.count.toString(),
                                style:TextStyle(color: Colors.white, fontSize: 13.0,fontWeight: FontWeight.w500),
                              );
                            },
                          )
                      ),
                    ],
                  )

                ),
              ],
            )
          ],
        ),
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers:[
            SliverPersistentHeader(pinned: true ,delegate: SearchBoxDelegate()),
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("items").limit(15).orderBy("publishedDate",descending: true).snapshots(),

                builder: (context,dataSnapshot)
                {
                  return  !dataSnapshot.hasData
                      ? SliverToBoxAdapter(child: Center(child: circularProgress(),),):
                      SliverStaggeredGrid.countBuilder(
                          crossAxisCount: 1, 
                          staggeredTileBuilder: (c)=>StaggeredTile.fit(1), 
                          itemBuilder: (context,index){
                            ItemModel model = ItemModel.fromJson(dataSnapshot.data.documents[index].data);
                            return sourceInfo(model, context);
                          }, 
                          itemCount: dataSnapshot.data.documents.length);
                }
            ),
          ]
        )
      ),
    );
  }
}



Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  //print(EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList));
  return InkWell(
    onTap: ()
    {
      Route route = MaterialPageRoute(builder: (c)=>ProductPage(itemModel:model));
      Navigator.pushReplacement(context, route);
    },
    splashColor: Colors.pink,
    child: Padding(
      padding: EdgeInsets.all(6),
      child: Container(
        height: 190,
        width: width,
        child: Row(
          children: [
            Image.network(model.thumbnailUrl,width: 140,height: 140,),
            SizedBox(width: 4.0,),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15,),
                      Container(
                        child : Row(
                          children: [
                            Expanded(
                                child:Text(model.title,style: TextStyle(color:Colors.black,fontSize: 14),),
                            ),
                          ],
                        )
                      ),
                      SizedBox(height: 5,),
                      Container(
                          child : Row(
                            children: [
                              Expanded(
                                child:Text(model.shortInfo ,style: TextStyle(color:Colors.black54,fontSize: 12),),
                              ),
                            ],
                          )
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.pink,
                            ),
                            alignment: Alignment.topLeft,
                            width:40,
                            height: 43,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "50%",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    "OFF",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(top: 0.0),
                                child: Row(
                                  children:[
                                    Text(
                                      r"Origional Price $ ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),

                                    Text(
                                      (model.price+ model.price).toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    )
                                  ]
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0.0),
                                child: Row(
                                    children:[
                                      Text(
                                        "New Price ",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          //decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                      Text(
                                        r"$ ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.red
                                        ),
                                      ),
                                      Text(
                                        (model.price).toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          //decoration: TextDecoration.lineThrough,
                                        ),
                                      )
                                    ]
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Flexible(
                          child: Container(

                            ) ,
                          ),
                      Align(
                        alignment: Alignment.centerRight,
                          child: removeCartFunction == null
                        ?IconButton(icon: Icon(Icons.add_shopping_cart, color: Colors.pinkAccent,)
                          ,onPressed: ()
                            {
                              checkItemInCart(model.shortInfo, context);
                            },
                          )
                              :IconButton(icon: Icon(Icons.delete, color: Colors.pinkAccent,))

                      ),
                      Divider(
                        height: 5,
                        color: Colors.pink,
                      )
                    ],
                )
            ),
          ],
        ),

      ),
    ),
  );
}



Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container();
}



void checkItemInCart(String shortInfoAsID, BuildContext context)
{
  EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).contains(shortInfoAsID)
      ?Fluttertoast.showToast(msg: "Item is already in cart.")
      : addItemToCart(shortInfoAsID,context);
}

addItemToCart(String shortInfoAsID,BuildContext context)
{
  List tempCartList =EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  tempCartList.add(shortInfoAsID);
  EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
  .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
  .updateData({
    EcommerceApp.userCartList: tempCartList,
  }).then((v){
    Fluttertoast.showToast(msg: "Item Added to Cart Succeddfully.");

    EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempCartList);
    Provider.of<CartItemCounter>(context,listen: false).displayResult();
  });

}