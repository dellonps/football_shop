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