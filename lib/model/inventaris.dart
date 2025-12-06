class Inventaris {
  String? id;
  String? nama;
  int? harga;
  int? jumlah;
  String? tanggalMasuk;
  String? tanggalKedaluwarsa;

  Inventaris({
    this.id,
    this.nama,
    this.harga,
    this.jumlah,
    this.tanggalMasuk,
    this.tanggalKedaluwarsa,
  });

  factory Inventaris.fromJson(Map<String, dynamic> obj) {
    return Inventaris(
      id: obj['id']?.toString(),
      
      nama: obj['nama'],       
     
      harga: int.tryParse(obj['harga'].toString()), 
      
      jumlah: int.tryParse(obj['jumlah'].toString()), 
      
      tanggalMasuk: obj['tanggal_masuk'],
      
      tanggalKedaluwarsa: obj['tanggal_kedaluwarsa'], 
    );
  }
}