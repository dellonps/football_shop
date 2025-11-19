TUGAS 9

1. Jelaskan mengapa kita perlu membuat model Dart saat mengambil/mengirim data JSON? Apa konsekuensinya jika langsung memetakan Map<String, dynamic> tanpa model (terkait validasi tipe, null-safety, maintainability)?
    Saat mengambil/mengirim data JSON, kita perlu membuat model Dart karena:
    1. Validasi tipe & null-safety
        - Dengan model (class ProductEntry { ... }), setiap field punya tipe yang jelas: String, int, double, DateTime, dll.
        - Saat parsing dari JSON ke model (ProductEntry.fromJson), kita langsung tahu kalau ada tipe yang tidak cocok (misalnya harga harusnya int tapi ternyata String).
        - Null-safety di Dart bisa dimanfaatkan (String?, int?) untuk membedakan mana yang boleh null dan mana yang wajib ada.

    2. Menghindari error runtime yang susah dilacak

        - Kalau langsung pakai Map<String, dynamic>, semua tipe “dicampur” jadi dynamic.
        - Salah ketik key ("prce" instead of "price") atau salah tipe baru ketahuan saat runtime, biasanya dengan error yang lebih susah dilacak.
        - Dengan model, IDE bisa bantu auto-complete dan cek tipe waktu compile.

    3. Maintainability & scalability

        - Kalau struktur JSON berubah (misalnya tambah field baru createdAt), kita cukup update model dan method fromJson / toJson.
        - Model juga jadi satu sumber kebenaran (single source of truth) tentang bentuk data di aplikasi.
        - Kode yang menggunakan data jadi lebih rapi: product.name, product.price, bukan map["name"], map["price"] di mana-mana.

    4. Konsekuensi kalau hanya pakai Map<String, dynamic> tanpa model:

        - Sulit memastikan tipe data yang benar → rawan error runtime.
        - Null-safety tidak dimanfaatkan maksimal.
        - Kode jadi berantakan (banyak magic string "name", "price" tersebar).
        - Sulit dirawat kalau project makin besar dan banyak endpoint.

2. Apa fungsi package http dan CookieRequest dalam tugas ini? Jelaskan perbedaan peran http vs CookieRequest.
    http digunakan untuk melakukan request biasa—cocok untuk endpoint yang tidak membutuhkan login atau cookie, misalnya mengambil daftar produk publik.

    Sementara CookieRequest adalah versi “lebih pintar” yang menyimpan session cookie Django setelah login, lalu mengirimkannya otomatis di request berikutnya. CookieRequest wajib digunakan untuk endpoint yang butuh autentikasi seperti create product, my products, atau logout.Singkatnya: http = request umum, CookieRequest = request untuk user yang sudah login.

3. Jelaskan mengapa instance CookieRequest perlu untuk dibagikan ke semua komponen di aplikasi Flutter.
    Karena session login harus konsisten di semua halaman. Jika setiap halaman membuat instance baru, maka cookie login tidak terbawa dan Flutter tidak lagi dianggap login oleh Django. Dengan membagikan satu instance melalui Provider, seluruh aplikasi memiliki akses session yang sama sehingga autentikasi berjalan lancar.

4. Jelaskan konfigurasi konektivitas yang diperlukan agar Flutter dapat berkomunikasi dengan Django. Mengapa kita perlu menambahkan 10.0.2.2 pada ALLOWED_HOSTS, mengaktifkan CORS dan pengaturan SameSite/cookie, dan menambahkan izin akses internet di Android? Apa yang akan terjadi jika konfigurasi tersebut tidak dilakukan dengan benar?
    Agar Flutter (terutama emulator/web) bisa terhubung ke Django, beberapa konfigurasi perlu dilakukan:

    - Menambahkan 10.0.2.2 ke ALLOWED_HOSTS supaya emulator Android bisa mengakses server lokal.
    - Mengaktifkan CORS dan mengatur cookie/SameSite agar Django mengizinkan request dari origin Flutter.
    - Memberi izin internet di AndroidManifest agar aplikasi bisa melakukan request ke luar.

    Jika konfigurasi ini tidak benar, request dari Flutter akan gagal—mulai dari blocked host, CORS error, sampai gagal login karena cookie tidak terkirim.

5. Jelaskan mekanisme pengiriman data mulai dari input hingga dapat ditampilkan pada Flutter.
    User mengisi form di Flutter → data dikirim ke Django dalam format JSON → Django memproses dan menyimpan ke database → ketika Flutter meminta daftar produk, Django mengirim JSON ke Flutter → Flutter mem-parsing JSON tersebut ke model Dart → hasil akhirnya tampil sebagai daftar/halaman detail.

6. Jelaskan mekanisme autentikasi dari login, register, hingga logout. Mulai dari input data akun pada Flutter ke Django hingga selesainya proses autentikasi oleh Django dan tampilnya menu pada Flutter.
    - Untuk register, Flutter mengirim data ke Django dan Django membuat akun baru.
    - Untuk login, Flutter menggunakan CookieRequest yang menyimpan session cookie jika login berhasil. Cookie ini membuat setiap request berikutnya dikenali sebagai user yang sama.
    - Logout menghapus session dari Django dan membersihkan cookie di Flutter. Setelah itu, seluruh halaman yang butuh autentikasi tidak bisa lagi diakses.

7. Jelaskan bagaimana cara kamu mengimplementasikan checklist di atas secara step-by-step! (bukan hanya sekadar mengikuti tutorial).
    Dalam mengerjakan tugas ini, saya mengikuti seluruh checklist dengan langkah-langkah yang runtut dan saling berkaitan. Saya memulai dari sisi Django terlebih dahulu, kemudian beralih ke Flutter, dan terakhir menghubungkan keduanya agar saling berkomunikasi dengan baik.

    Langkah pertama yang saya lakukan adalah menyiapkan backend Django. Saya membuat model Product lengkap dengan field seperti name, price, description, category, thumbnail, user, dan created_at. Field user saya tambahkan agar setiap produk memiliki informasi siapa pembuatnya, yang nantinya digunakan untuk fitur “My Products”. Setelah model selesai, saya membuat beberapa view untuk menangani kebutuhan Flutter, yaitu view untuk mengirim seluruh produk (show_json), view untuk mengirim produk milik user tertentu (show_my_products_json), serta view untuk menerima data dari Flutter ketika user membuat produk baru (create_product_flutter). Semua view ini saya hubungkan ke URL masing-masing menggunakan urls.py.

    Setelah backend siap, saya memastikan Django dapat diakses oleh Flutter. Di sini saya menambahkan localhost, 127.0.0.1, dan 10.0.2.2 ke dalam ALLOWED_HOSTS. Saya juga memastikan pengaturan cookie, CORS, dan CSRF sudah sesuai agar login dan request Flutter dapat diterima Django tanpa error. Tanpa konfigurasi ini, request dari emulator maupun Flutter web tidak akan dianggap valid oleh Django.

    Setelah backend siap, saya pindah ke sisi Flutter. Saya mulai dengan membuat model Dart menggunakan Quicktype. Saya mengakses endpoint JSON Django di browser, menyalin output JSON-nya, dan memprosesnya menjadi class Dart ProductEntry. Model ini membantu saya membaca dan menampilkan data dari Django dengan rapi, serta memastikan tipe data selalu konsisten. Setelah itu saya membuat halaman-halaman dasar: halaman list semua produk, halaman detail produk, halaman form untuk create product, dan halaman “My Products”. Masing-masing halaman menggunakan model Dart yang sudah dibuat, sehingga parsing JSON ke data Flutter berjalan dengan mulus.

    Untuk autentikasi, saya menerapkan login dan register menggunakan package pbp_django_auth. Pada tahap ini saya membungkus aplikasi Flutter dengan Provider agar sebuah instance CookieRequest bisa dibagikan ke seluruh aplikasi. Dengan cara itu, begitu user berhasil login, cookie session Django akan otomatis tersimpan dan digunakan di semua request berikutnya, termasuk saat membuat produk atau mengambil data “My Products”. Saya membuat halaman login, register, dan logout yang semuanya mengakses endpoint Django sesuai keperluan.

    Langkah berikutnya adalah menghubungkan semua fitur tersebut satu per satu. Saya membuat tombol “Create Product” di menu utama untuk membuka form produk, dan setelah produk tersimpan, Flutter akan menampilkan snackbar sukses. Untuk tombol “All Products”, saya menampilkan seluruh produk dari endpoint /json/. Dan untuk tombol “My Products”, saya memastikan Flutter memanggil endpoint /json/my-products/ yang sudah difilter berdasarkan request.user. Di tahap ini saya memastikan bahwa produk yang dibuat lewat Flutter benar-benar memiliki atribut user yang sesuai, sehingga fitur “My Products” dapat berfungsi sebagaimana mestinya.

    Terakhir, saya melakukan pengujian end-to-end. Mulai dari login → membuat produk → melihat produk di halaman All Products → memastikan produk muncul di halaman My Products → membuka halaman detail produk. Saya juga memastikan semua operasi berjalan konsisten baik di Flutter web maupun emulator Android.

    Dengan langkah-langkah di atas, seluruh checklist dapat saya selesaikan secara utuh dan fitur-fitur utama aplikasi dapat berjalan dengan benar. Pendekatan bertahap ini membuat saya lebih mudah memetakan alur data dari Flutter ke Django dan sebaliknya, sehingga struktur aplikasi menjadi lebih jelas dan mudah dirawat.



TUGAS 8

1. Jelaskan perbedaan antara Navigator.push() dan Navigator.pushReplacement() pada Flutter. Dalam kasus apa sebaiknya masing-masing digunakan pada aplikasi Football Shop kamu?
    
    - Navigator.push() menambahkan halaman baru ke atas stack navigasi, sehingga pengguna bisa kembali ke halaman sebelumnya dengan tombol back.

    - Navigator.pushReplacement() menggantikan halaman saat ini dengan halaman baru, sehingga halaman sebelumnya dihapus dari stack dan pengguna tidak bisa kembali ke halaman itu.

    Implementasi dalam football_shop

        - Digunakan push() saat ingin pengguna bisa kembali ke halaman sebelumnya (misal, detail produk ke daftar produk).
        
        - Digunakan pushReplacement() saat ingin mengganti halaman sepenuhnya (misal, setelah submit form produk, langsung ke halaman utama tanpa bisa kembali ke form)

2. Bagaimana kamu memanfaatkan hierarchy widget seperti Scaffold, AppBar, dan Drawer untuk membangun struktur halaman yang konsisten di seluruh aplikasi?

    - Saya memanfaatkan Hierarchy Widget
        1. Scaffold: Menjadi kerangka utama setiap halaman, menyediakan struktur dasar seperti body, appBar, drawer.
        2. AppBar: Menampilkan judul dan aksi utama di bagian atas, menjaga konsistensi navigasi dan branding.
        3. Drawer: Menyediakan navigasi samping yang konsisten di seluruh aplikasi.

    - Contoh :
    return Scaffold(
        appBar: AppBar(
            title: const Center(child: Text('Add Product Form')),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
        ),
        endDrawer: RightDrawer(),
        body: Form(
            // ...form content...
        ),
    );

3. Dalam konteks desain antarmuka, apa kelebihan menggunakan layout widget seperti Padding, SingleChildScrollView, dan ListView saat menampilkan elemen-elemen form? Berikan contoh penggunaannya dari aplikasi kamu.

    - Kelebihan Layout Widget
        1. Padding: Memberi ruang antar elemen agar tampilan tidak terlalu rapat.
        2. SingleChildScrollView: Membuat seluruh form bisa di-scroll, penting untuk layar kecil.
        3. ListView: Untuk daftar elemen yang panjang dan dinamis.
    - Contoh implementasi di kode saya:
        body: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    // ...kode form...
                ),
                ),
                // ...kode lainnya...
            ],
            ),
        ),
        ),
4. Bagaimana kamu menyesuaikan warna tema agar aplikasi Football Shop memiliki identitas visual yang konsisten dengan brand toko?

    - Gunakan warna utama brand (misal, Colors.indigo) pada AppBar, tombol, dan elemen penting.
    - Atur ThemeData di root aplikasi agar warna konsisten di seluruh halaman.

    - Contoh implementasi di kode saya:

    MaterialApp(
    theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.indigo),
        ),
        ),
    ),
    // ...kode lainya...
    )






TUGAS 7

1. Apa itu widget tree di Flutter & hubungan parent-child antar widget
    - Widget tree adalah struktur hirarkis dari semua widget yang membentuk UI aplikasi Flutter. Setiap widget adalah sebuah node dalam pohon tersebut. Root node biasanya adalah widget paling atas (mis. MaterialApp), lalu anak-anaknya (children) melekat di bawahnya, dan seterusnya.
    - Hubungan Parent-child : setiap widget "memiliki" anak (child/children) — parent menentukan layout/penempatan dan sering meneruskan informasi (mis. constraints, theme). Child menerima ruang dari parent dan menggambar dirinya sendiri. Banyak widget adalah wrapper (mis. Center, Container, Padding) yang memengaruhi anaknya tanpa menggambar konten unik.

2. Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya.
    A. Widget khusus di proyek
        - MyApp (StatelessWidget)
            Fungsi: widget root aplikasi, mengembalikan MaterialApp dengan konfigurasi tema dan home.
        - MyHomePage (StatelessWidget)
            Fungsi: halaman utama. Membangun Scaffold yang menampilkan AppBar dan body berupa GridView berisi item menu.
        - ItemCard (StatelessWidget)
            Fungsi: kartu UI untuk setiap tombol menu (memvisualisasikan ItemHomepage), menerima tap dan menampilkan SnackBar.
        
    B. Widget Flutter bawaan yang dipakai (dan fungsinya)
 
        - MaterialApp
            Fungsi: root app yang menyediakan Material Design, navigasi, tema, lokal, dsb.
        - Scaffold
            Fungsi: kerangka halaman Material (AppBar, body, floatingActionButton, drawer, dll).
        - AppBar
            Fungsi: bar atas dengan title dan aksi.
        - Text
            Fungsi: menampilkan teks.
        - Center
            Fungsi: meratakan child di tengah parent.
        - GridView.count
            Fungsi: grid dengan jumlah kolom tetap (dipakai untuk tata letak menu).
        - Material
            Fungsi: menyediakan surface Material (elevation, ink effects) untuk child.
        - InkWell
            Fungsi: deteksi tap dengan ripple effect (splash) di atas material.
        - Container
            Fungsi: box model untuk padding, ukuran, background, dsb.
        - Column
            Fungsi: mengatur widget secara vertikal.
        - Icon
            Fungsi: menampilkan ikon.
        - SizedBox
            Fungsi: spacer dengan ukuran tetap (dipakai untuk memberi jarak).
        - SnackBar
            Fungsi: pesan singkat yang muncul di bawah layar (melalui ScaffoldMessenger).
        - ScaffoldMessenger
            Fungsi: menampilkan SnackBar di Scaffold.

3. Apa fungsi MaterialApp dan mengapa sering digunakan sebagai widget root
    - Fungsi utama MaterialApp:
        1. Menyediakan konfigurasi global untuk aplikasi Material: theme, darkTheme,  localizations, routes, navigatorKey, home, dsb.
        2. Mengelola Navigator (routing) dan Route default.
        3. Mengikat beberapa fitur Material UI seperti InheritedTheme sehingga child dapat menggunakan Theme.of(context).
    - Mengapa sering digunakan sebagai root:
        1. Banyak widget Material bergantung pada konteks yang disediakan MaterialApp (seperti Theme.of(context), Navigator.of(context), Localizations).
        2. MaterialApp menyiapkan lingkungan standar (Material visual effects, default text styles, directionality) sehingga widget lain dapat bekerja konsisten tanpa konfigurasi ulang.
        3. Seringkali paling mudah meletakkan MaterialApp di atas agar seluruh subtree mewarisi tema dan behavior Material.

4. Perbedaan antara StatelessWidget dan StatefulWidget. Kapan memilih salah satunya?
    1. StatelessWidget
        - Tidak menyimpan state yang berubah selama lifecycle setelah dibuat.
        - build(context) pure function yang bergantung hanya pada input (constructor dan InheritedWidgets seperti Theme).
        - Contoh pemakaian: tampilan statis, ikon, teks, layout yang tidak perlu merespons perubahan internal.
        - Keunggulan: sederhana, ringan, mudah diuji.
        - Gunakan StatelessWidget bila UI hanya tergantung pada properti yang diberikan (immutable).
    2. StatefulWidget
        - Memiliki State yang dapat berubah seiring waktu (setState, lifecycle seperti initState/dispose).
        - Berguna ketika widget perlu merespon input pengguna, timer, network updates, animasi, dsb.
        State memegang data yang kalau berubah akan memicu rebuild.
        - Gunakan StatefulWidget bila widget perlu menyimpan dan mengubah state lokal (mis. form dengan input, toggle, loading indicator, data fetch per-widget).

5. Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di metode build?

    - Apa itu BuildContext:
        1. BuildContext adalah objek yang merepresentasikan lokasi sebuah widget di dalam widget tree. Ia adalah handle untuk mengakses ancestor, theme, media query, navigator, dan lain-lain melalui metode statis seperti Theme.of(context), Navigator.of(context), ScaffoldMessenger.of(context).
        2. Secara teknis, setiap widget punya Element yang merepresentasikan instance runtime dari widget itu; BuildContext adalah interface untuk Element.
    - Mengapa penting:
        Dengan BuildContext Anda bisa:
        1. Mengambil InheritedWidget dan values (theme, localization, media query).
        2. Menavigasi (Navigator), menampilkan snackbars (ScaffoldMessenger), membuka dialog, dsb.
        3. Menghubungkan widget child dengan informasi dari ancestor.
    - Penggunaan di build():
        build(BuildContext context) menerima context yang menunjuk posisi widget; di sana Anda memanggil Theme.of(context), MediaQuery.of(context), ScaffoldMessenger.of(context), dsb.

6. Jelaskan konsep "hot reload" di Flutter dan bagaimana bedanya dengan "hot restart".
    - Hot reload:
    Hot reload adalah fitur di Flutter yang memungkinkan developer melihat perubahan kode secara langsung tanpa harus memulai ulang seluruh aplikasi. Flutter hanya memuat ulang kode yang berubah, lalu menyimpan state (keadaan) aplikasi sebelumnya. Jadi, kalau kamu mengubah teks, warna, layout, atau menambahkan widget baru, kamu bisa langsung melihat hasilnya dalam hitungan detik tanpa kehilangan data di layar.

    - Hot restart:
    Hot restart juga memuat ulang kode, tapi menghapus seluruh state aplikasi. Aplikasi akan dimulai ulang dari awal, seperti baru dijalankan lagi. Ini berguna kalau kamu mengubah variabel global, logika inisialisasi, atau ingin memastikan semuanya dimulai dari keadaan bersih.