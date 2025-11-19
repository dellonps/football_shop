import 'package:flutter/material.dart';
import 'package:football_shop/widgets/right_drawer.dart';
import 'package:football_shop/Screens/menu.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';


class ProductFormPage extends StatefulWidget {
    const ProductFormPage({super.key});

    @override
    State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _desc = "";
  String _category = "Baju";
  int? _price;
  String _thumbnail = ""; 

  final List<String> _categories = [
    'Baju',
    'Celana',
    'Aksesoris',
    'Sports Gear',
    'Sepatu',
  ];
    @override
    Widget build(BuildContext context) {
        final request = context.watch<CookieRequest>();
        return Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text(
                'Add Product Form',
              ),
            ),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
          endDrawer:RightDrawer(),
          body: Form(            
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  // === name Produk ===
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Name Produk",
                          labelText: "Name Produk",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _name = value!;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "name tidak boleh kosong!";
                          }
                          if(value.length < 5){
                            return 'Judul minimal harus 5 karakter.';
                          }
                          if(value.length > 100){
                            return 'Judul maksimal 100 karakter.';
                          }
                          return null;
                        },
                      ),
                    ),
                    // === Deskripsi Produk ===
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration : InputDecoration(
                          hintText: "Deskripsi Produk",
                          labelText: "Deskripsi Produk",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: 
                        (String? value){
                          setState(() {
                          _desc =value!;
                          });
                        },
                        validator: (String? value){
                          if(value == null || value.isEmpty){
                            return "Deskripsi produk tidak boleh kosong!";
                          }
                          if(value.length < 5){
                            return 'Deskripsi minimal harus 5 karakter.';
                          }
                          if(value.length > 500){
                            return 'Deskripsi maksimal 500 karakter.';
                          }
                          return null;
                        },
                      )
                    ),
                    // === Harga Produk ===
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Harga Produk",
                          labelText: "Harga Produk",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: 
                        (String? value){
                          final int? parsedPrice = int.tryParse(value ?? '');
                          setState(() {
                            _price = parsedPrice;
                          });

                        },
                        validator:(value){
                          if (value == null || value.isEmpty) {
                            return 'Harga tidak boleh kosong.';
                          }
                          final price = int.tryParse(value);
                          if(price== null){
                            return 'Masukan harga dalam bentuk angka.';

                          }
                          if(price<0){
                            return 'Harga tidak boleh negatif.';
                          }

                          return null;
                        },

                      ),
                    ),
                   // === Kategori Produk === 
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child : DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Kategori",
                          border:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        value: _category,
                        items: _categories
                              .map((cat) => DropdownMenuItem(
                                value: cat,
                                child : Text(
                                  cat[0].toUpperCase() + cat.substring(1)),
                                ))
                              .toList(),
                            onChanged: (String? newValue){
                              setState(() {
                                _category= newValue!;
                              });
                            },
                          ),
                    ),
                    // === URL Produk ===
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "URL Thumbnail (opsional)",
                          labelText: "URL Thumbnail",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _thumbnail = value!;
                          });
                        },
                      ),
                    ),

                    // === Tombol Simpan ===

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: 
                             WidgetStateProperty.all(Colors.indigo),
                          ),
                          onPressed: ()async{
                            if(_formKey.currentState!.validate()){
                              final response = await request.postJson(
                                  "http://localhost:8000/create-flutter/",
                                  jsonEncode({
                                    "name": _name,
                                    "price": _price,
                                    "description": _desc,
                                    "thumbnail": _thumbnail,
                                    "category": _category,
                                    
                                    
                                  }),
                                );
                                if (context.mounted) {
                                  if (response['status'] == 'success') {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("News successfully saved!"),
                                    ));
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage()),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Something went wrong, please try again."),
                                    ));
                                  }
                                }
                                
                                showDialog(
                                context: context, 
                                builder: (context){
                                  return AlertDialog(
                                    title: const Text('Berita berhasil disimpan!'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text('Name: $_name'),
                                          Text('Deskripsi: $_desc'),
                                          Text('Harga: $_price'),
                                          Text('Kategori: $_category'),
                                          Text('Thumbnail: $_thumbnail')
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _formKey.currentState!.reset();

                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              // Ganti MyHomePage() dengan widget halaman menu Anda
                                              builder: (context) => const MyHomePage(), 
                                            ),
                                          );
                                        }, 
                                      ),
                                    ],
                                  );
                                },
                              );
                              
                            }
                          }, 
                          child: const Text(
                            "Simpan",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),


                ],

              ),
            ),
          ),
        );


    }
}

