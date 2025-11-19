import 'package:flutter/material.dart';
import 'package:football_shop/Screens/productlist_form.dart';
import 'package:football_shop/Screens/menu.dart';
import 'package:football_shop/Screens/product_entry_list.dart';

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
            title: const Text('Add product'),
            // Bagian redirection ke productFormPage
            onTap: () {
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) => ProductFormPage(),));
            },
          ),

          ListTile(
            leading: const Icon(Icons.add_reaction_rounded),
            title: const Text('Product List'),
            onTap: () {
                // Route to product list page
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProductEntryListPage()),
                );
            },
        ),


        ],
      ),
    );
  }

}