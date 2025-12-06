import 'package:flutter/material.dart';
import 'package:responsi2mobilepaket2_h1d023088/bloc/inventaris_bloc.dart';
import 'package:responsi2mobilepaket2_h1d023088/model/inventaris.dart';
import 'package:responsi2mobilepaket2_h1d023088/ui/inventaris_form.dart';
import 'package:responsi2mobilepaket2_h1d023088/ui/inventaris_page.dart';
import 'package:responsi2mobilepaket2_h1d023088/widget/warning_dialog.dart';

class InventarisDetail extends StatefulWidget {
  final Inventaris? inventaris;

  const InventarisDetail({Key? key, this.inventaris}) : super(key: key);

  @override
  _InventarisDetailState createState() => _InventarisDetailState();
}

class _InventarisDetailState extends State<InventarisDetail> {
  final Color _green = const Color(0xFF1DB954);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Detail Inventaris Sholem Mart",
            style: TextStyle(color: Colors.white)),
        backgroundColor: _green,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _produkIcon(),
                const SizedBox(height: 20),
                Text(
                  widget.inventaris!.nama ?? "Nama Barang",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Rp ${widget.inventaris!.harga.toString()}",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: _green,
                  ),
                ),
                const SizedBox(height: 30),

                _detailInfoCard(),

                const SizedBox(height: 40),
                _tombolHapusEdit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _produkIcon() {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: _green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Icon(
        Icons.inventory_2, 
        size: 80,
        color: _green,
      ),
    );
  }

  Widget _detailInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _rowDetail("Jumlah Stok", "${widget.inventaris!.jumlah} Pcs"),
          const Divider(),
          _rowDetail(
              "Tanggal Masuk", widget.inventaris!.tanggalMasuk ?? "-"),
          const Divider(),
          _rowDetail("Kedaluwarsa",
              widget.inventaris!.tanggalKedaluwarsa ?? "-",
              isRed: true),
        ],
      ),
    );
  }

  Widget _rowDetail(String label, String value, {bool isRed = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              color: isRed ? Colors.redAccent : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 3,
            ),
            child: const Text(
              "EDIT DATA",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      InventarisForm(inventaris: widget.inventaris!),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.redAccent, width: 2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text(
              "HAPUS DATA",
              style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            onPressed: () => confirmHapus(),
          ),
        ),
      ],
    );
  }

  void confirmHapus() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Inventaris"),
        content: const Text(
            "Yakin ingin menghapus data ini? Tindakan ini tidak bisa dibatalkan."),
        actions: [
          TextButton(
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Hapus",
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.pop(context); 

              int? idHapus;
              if (widget.inventaris!.id != null) {
                idHapus = int.tryParse(widget.inventaris!.id.toString());
              }

              if (idHapus == null) {
                print("Error: ID null");
                return;
              }

              InventarisBloc.deleteInventaris(id: idHapus).then((value) {
                if (!mounted) return;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const InventarisPage()),
                );
              }).catchError((error) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => const WarningDialog(
                    description: "Hapus gagal, silahkan coba lagi",
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}