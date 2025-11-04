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