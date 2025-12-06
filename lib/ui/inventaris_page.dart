import 'package:flutter/material.dart';
import 'package:responsi2mobilepaket2_h1d023088/bloc/logout_bloc.dart';
import 'package:responsi2mobilepaket2_h1d023088/model/inventaris.dart';
import 'package:responsi2mobilepaket2_h1d023088/ui/login_page.dart';
import 'package:responsi2mobilepaket2_h1d023088/ui/inventaris_detail.dart';
import 'package:responsi2mobilepaket2_h1d023088/ui/inventaris_form.dart';
import 'package:responsi2mobilepaket2_h1d023088/bloc/inventaris_bloc.dart';
import 'package:responsi2mobilepaket2_h1d023088/helpers/user_info.dart'; // Import ini wajib

class InventarisPage extends StatefulWidget {
  const InventarisPage({Key? key}) : super(key: key);
  @override
  _InventarisPageState createState() => _InventarisPageState();
}

class _InventarisPageState extends State<InventarisPage> {
  final Color _green = const Color(0xFF1DB954);
  
  String _nama = "Loading...";
  String _email = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }
  void _loadUserInfo() async {
    String? nama = await UserInfo().getNama();
    String? email = await UserInfo().getEmail();
    
    setState(() {
      _nama = nama ?? "Admin"; 
      _email = email ?? "admin@tokokita.com";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
        title: const Text(
          'List Inventaris Sholem Mart',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _green,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: _green),
                accountName: Text(
                  _nama, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                accountEmail: Text(_email),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.grey),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text('Logout',
                    style: TextStyle(color: Colors.black87)),
                onTap: () async {
                  await LogoutBloc.logout().then(
                    (value) => {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false,
                      ),
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: FutureBuilder<List<Inventaris>>(
          future: InventarisBloc.getInventaris(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            return snapshot.hasData
                ? ListInventaris(
                    list: snapshot.data, accentColor: _green)
                : Center(
                    child: CircularProgressIndicator(color: _green));
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: _green,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InventarisForm()),
          );
          setState(() {});
        },
      ),
    );
  }
}

class ListInventaris extends StatelessWidget {
  final List<Inventaris>? list;
  final Color accentColor;

  const ListInventaris({Key? key, this.list, required this.accentColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (list == null || list!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.inbox, size: 70, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              "Belum ada data inventaris.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: list!.length,
      itemBuilder: (context, i) {
        return ItemInventaris(
            inventaris: list![i], accentColor: accentColor);
      },
    );
  }
}

class ItemInventaris extends StatelessWidget {
  final Inventaris inventaris;
  final Color accentColor;

  const ItemInventaris(
      {Key? key, required this.inventaris, required this.accentColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InventarisDetail(inventaris: inventaris)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1), 
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.inventory_2_outlined,
                color: accentColor), ),

          title: Text(
            inventaris.nama ?? "Tanpa Nama",
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              "Rp ${inventaris.harga.toString()}",
              style: TextStyle(
                color: accentColor, 
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ),
      ),
    );
  }
}