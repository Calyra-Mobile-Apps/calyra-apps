// lib/data/brand_data.dart

import 'package:calyra/models/brand_info.dart';

final List<BrandInfo> featuredBrands = [
  const BrandInfo( // <-- TAMBAHKAN CONST DI SINI
    id: 'BRD001',
    name: 'Wardah',
    imageUrl: 'assets/images/home-wardah.jpg',
    logoPath: 'assets/images/Logo_wardah.png',
    homeLogoPath: 'assets/images/wardah-white.png',
    products: [], // Dikosongkan karena data diambil dari Firestore
  ),
  const BrandInfo( // <-- TAMBAHKAN CONST DI SINI
    id: 'BRD002',
    name: 'Emina',
    imageUrl: 'assets/images/home-emina.jpg',
    logoPath: 'assets/images/Logo_emina.png',
    homeLogoPath: 'assets/images/emina-white.png',
    products: [],
  ),
  const BrandInfo( // <-- TAMBAHKAN CONST DI SINI
    id: 'BRD007',
    name: 'Make Over',
    imageUrl: 'assets/images/home-makeover.jpg',
    logoPath: 'assets/images/Logo_makeover.png',
    homeLogoPath: 'assets/images/makeover-white.png',
    products: [],
  ),
  const BrandInfo( // <-- TAMBAHKAN CONST DI SINI
    id: 'BRD006',
    name: 'Somethinc',
    imageUrl: 'assets/images/home-somethinc.jpg',
    logoPath: 'assets/images/Logo_somethinc.png',
    homeLogoPath: 'assets/images/somethinc-white.png',
    products: [],
  ),
  const BrandInfo( // <-- TAMBAHKAN CONST DI SINI
    id: 'BRD005',
    name: 'OMG Beauty',
    imageUrl: 'assets/images/home-omg.jpeg',
    logoPath: 'assets/images/Logo_OMG.png',
    homeLogoPath: 'assets/images/omg-white.png',
    products: [],
  ),
    const BrandInfo( // <-- TAMBAHKAN CONST DI SINI
    id: 'BRD003',
    name: 'Luxcrime',
    imageUrl: 'assets/images/home-luxcrime.png',
    logoPath: 'assets/images/Logo_luxcrime.png',
    homeLogoPath: 'assets/images/luxcrime-white.png',
    products: [],
  ),
];