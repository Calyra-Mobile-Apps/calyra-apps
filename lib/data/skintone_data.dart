// Lokasi file: lib/data/skintone_data.dart

import 'package:flutter/material.dart';

class SkintoneDetail {
  final int id;
  final String name;
  final Color color;

  const SkintoneDetail({
    required this.id,
    required this.name,
    required this.color,
  });
}

// Data lengkap 1-20 sesuai request
final List<SkintoneDetail> skintoneData = [
  // Baris 1 (Undertone Kuning/Emas - Terang ke Gelap)
  const SkintoneDetail(id: 1, name: 'Warm Marble', color: Color(0xFFFBE3BF)),
  const SkintoneDetail(id: 2, name: 'Warm Ivory', color: Color(0xFFE2BB99)),
  const SkintoneDetail(id: 3, name: 'Coral Ivory', color: Color(0xFFDEA97D)),
  const SkintoneDetail(id: 4, name: 'Creme Beige', color: Color(0xFFE3AF7B)),
  const SkintoneDetail(id: 5, name: 'Warm Beige', color: Color(0xFFD39763)),

  // Baris 2 (Undertone Oranye/Tan - Terang ke Gelap)
  const SkintoneDetail(id: 6, name: 'Honey Beige', color: Color(0xFFE7B286)),
  const SkintoneDetail(id: 7, name: 'Coral Sand', color: Color(0xFFD99A78)),
  const SkintoneDetail(id: 8, name: 'Warm Sand', color: Color(0xFFCC926D)),
  const SkintoneDetail(id: 9, name: 'Creme Tan', color: Color(0xFFD49778)),
  const SkintoneDetail(id: 10, name: 'Creme Cocoa', color: Color(0xFF99674C)),

  // Baris 3 (Undertone Merah/Pink - Terang ke Gelap)
  const SkintoneDetail(id: 11, name: 'Pink Ivory', color: Color(0xFFF0B7A3)),
  const SkintoneDetail(id: 12, name: 'Pink Beige', color: Color(0xFFE4A681)),
  const SkintoneDetail(id: 13, name: 'Cool Sand', color: Color(0xFFC5917B)),
  const SkintoneDetail(id: 14, name: 'Cool Tan', color: Color(0xFFB38875)),
  const SkintoneDetail(id: 15, name: 'Rich Cocoa', color: Color(0xFF845D48)),

  // Baris 4 (Undertone Netral/Pucat - Terang ke Gelap)
  const SkintoneDetail(id: 16, name: 'Marble', color: Color(0xFFFAD7C2)),
  const SkintoneDetail(id: 17, name: 'Ivory', color: Color(0xFFF6CCB6)),
  const SkintoneDetail(id: 18, name: 'Natural Beige', color: Color(0xFFEEC5A7)),
  const SkintoneDetail(id: 19, name: 'Sand', color: Color(0xFFE9AE8D)),
  const SkintoneDetail(id: 20, name: 'Tan', color: Color(0xFFBD967D)),
];