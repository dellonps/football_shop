import 'package:flutter/material.dart';
import 'package:football_shop/newslist_form.dart';
import 'package:football_shop/menu.dart';

class RightDrawer extends StatelessWidget{
  const RightDrawer({super.key});


  @override
  Widget build (BuildContext context){
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  Text(
                    'Football Shop',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Text(
                    "Seluruh kebutuhan olahraga sepak bola mu ada disini!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),

                      // TODO: Tambahkan gaya teks dengan center alignment, font ukuran 15, warna putih, dan weight biasa
                      ),
                ],
              ),
            ),
          ListTile(
            leading: const Icon(Icons.home_filled),
            title: const Text('Home'),
            onTap: (){
               Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
            }
          ),

          ListTile(
            leading: const Icon(Icons.post_add_rounded),
            title: const Text('Add News'),
            // Bagian redirection ke NewsFormPage
            onTap: () {
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) => ProductFormPage(),));
            },
          ),


        ],
      ),
    );
  }

}