import 'package:flutter/material.dart';
import 'package:responsi2mobilepaket2_h1d023088/model/inventaris.dart';
import 'package:responsi2mobilepaket2_h1d023088/bloc/inventaris_bloc.dart';
import 'package:responsi2mobilepaket2_h1d023088/ui/inventaris_page.dart';
import 'package:responsi2mobilepaket2_h1d023088/widget/warning_dialog.dart';
import 'package:responsi2mobilepaket2_h1d023088/ui/inventaris_detail.dart';

class InventarisForm extends StatefulWidget {
  final Inventaris? inventaris;

  const InventarisForm({Key? key, this.inventaris}) : super(key: key);

  @override
  _InventarisFormState createState() => _InventarisFormState();
}

class _InventarisFormState extends State<InventarisForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String judul = "Tambah Inventaris Sholem Mart";
  String tombolSubmit = "Simpan";

  final _namaTextboxController = TextEditingController();
  final _hargaTextboxController = TextEditingController();
  final _jumlahTextboxController = TextEditingController();
  final _tglMasukTextboxController = TextEditingController();
  final _tglKedaluwarsaTextboxController = TextEditingController();

  final Color _green = const Color(0xFF1DB954);

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  void isUpdate() {
    if (widget.inventaris != null) {
      setState(() {
        judul = "Ubah Inventaris Sholem Mart";
        tombolSubmit = "Update";
        _namaTextboxController.text = widget.inventaris!.nama ?? '';
        _hargaTextboxController.text =
            widget.inventaris!.harga != null ? widget.inventaris!.harga.toString() : '';
        _jumlahTextboxController.text =
            widget.inventaris!.jumlah != null ? widget.inventaris!.jumlah.toString() : '';
        _tglMasukTextboxController.text = widget.inventaris!.tanggalMasuk ?? '';
        _tglKedaluwarsaTextboxController.text =
            widget.inventaris!.tanggalKedaluwarsa ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(judul, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: _green,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _namaTextField(),
                const SizedBox(height: 16),
                _hargaTextField(),
                const SizedBox(height: 16),
                _jumlahTextField(),
                const SizedBox(height: 16),
                _dateField("Tanggal Masuk", _tglMasukTextboxController),
                const SizedBox(height: 16),
                _dateField("Tanggal Kedaluwarsa", _tglKedaluwarsaTextboxController),
                const SizedBox(height: 40),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _customInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: Icon(icon, color: _green),
      filled: true,
      fillColor: Colors.grey.shade50,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: _green, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Widget _namaTextField() {
    return TextFormField(
      controller: _namaTextboxController,
      decoration: _customInputDecoration('Nama Barang', Icons.inventory),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Nama Barang harus diisi';
        return null;
      },
    );
  }

  Widget _hargaTextField() {
    return TextFormField(
      controller: _hargaTextboxController,
      keyboardType: TextInputType.number,
      decoration: _customInputDecoration('Harga (Rp)', Icons.attach_money),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Harga harus diisi';
        return null;
      },
    );
  }

  Widget _jumlahTextField() {
    return TextFormField(
      controller: _jumlahTextboxController,
      keyboardType: TextInputType.number,
      decoration: _customInputDecoration('Jumlah Stok', Icons.numbers),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Jumlah harus diisi';
        return null;
      },
    );
  }

  Widget _dateField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: _customInputDecoration(label, Icons.calendar_today),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(primary: _green),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          String formattedDate = pickedDate.toString().split(' ')[0];
          setState(() {
            controller.text = formattedDate;
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) return '$label harus diisi';
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return SizedBox(
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 3,
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                tombolSubmit,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate && !_isLoading) {
            if (widget.inventaris != null) {
              ubah();
            } else {
              simpan();
            }
          }
        },
      ),
    );
  }

  void simpan() {
    setState(() { _isLoading = true; });

    Inventaris createInventaris = Inventaris(id: null);
    createInventaris.nama = _namaTextboxController.text;
    createInventaris.harga = int.parse(_hargaTextboxController.text);
    createInventaris.jumlah = int.parse(_jumlahTextboxController.text);
    createInventaris.tanggalMasuk = _tglMasukTextboxController.text;
    createInventaris.tanggalKedaluwarsa = _tglKedaluwarsaTextboxController.text;

    InventarisBloc.addInventaris(inventaris: createInventaris).then((value) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => const InventarisPage()),
        (Route<dynamic> route) => false,
      );
    }, onError: (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(description: "Simpan gagal, silahkan coba lagi"),
      );
    }).whenComplete(() {
      if (mounted) setState(() { _isLoading = false; });
    });
  }

  void ubah() {
    setState(() { _isLoading = true; });

    Inventaris updateInventaris = Inventaris(id: widget.inventaris!.id!);
    updateInventaris.nama = _namaTextboxController.text;
    updateInventaris.harga = int.parse(_hargaTextboxController.text);
    updateInventaris.jumlah = int.parse(_jumlahTextboxController.text);
    updateInventaris.tanggalMasuk = _tglMasukTextboxController.text;
    updateInventaris.tanggalKedaluwarsa = _tglKedaluwarsaTextboxController.text;

    InventarisBloc.updateInventaris(inventaris: updateInventaris).then((value) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => InventarisDetail(inventaris: updateInventaris)
        ),
      );
      
    }, onError: (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(description: "Permintaan ubah data gagal, silahkan coba lagi"),
      );
    }).whenComplete(() {
      if (mounted) setState(() { _isLoading = false; });
    });
  }
}