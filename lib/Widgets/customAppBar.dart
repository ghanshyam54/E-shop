import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyAppBar extends StatelessWidget with PreferredSizeWidget
{
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white
      ),
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
      bottom: bottom,
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
                      color: Colors.lightGreenAccent,
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
                              style:TextStyle(color: Colors.black, fontSize: 15.0,fontWeight: FontWeight.w500),
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
    );
      }


  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}
