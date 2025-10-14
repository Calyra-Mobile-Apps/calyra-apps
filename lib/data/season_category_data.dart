import 'package:calyra/models/product.dart';
import 'package:calyra/models/season_category.dart';

const List<SeasonCategory> seasonCategories = [
  SeasonCategory(
    name: 'Summer',
    description:
        'As a Summer, you look best in soft, cool, and slightly muted colors that enhance your natural, gentle, and refined appearance.',
    iconPath: 'assets/images/icon-summer.png',
    paletteImagePath: 'assets/images/gradasi-summer.png',
    products: <Product>[
      Product(
        name: 'Cool Glow Highlighter',
        imageUrl: 'https://placehold.co/600x800/C8E6F5/000?text=Summer+Product+1',
      ),
      Product(
        name: 'Dusty Rose Lip Tint',
        imageUrl: 'https://placehold.co/600x800/E8CAD6/000?text=Summer+Product+2',
      ),
      Product(
        name: 'Lavender Breeze Eyeshadow',
        imageUrl: 'https://placehold.co/600x800/E0DAF3/000?text=Summer+Product+3',
      ),
      Product(
        name: 'Icy Blue Nail Lacquer',
        imageUrl: 'https://placehold.co/600x800/BCD8F4/000?text=Summer+Product+4',
      ),
    ],
  ),
  SeasonCategory(
    name: 'Autumn',
    description:
        'As an Autumn, your natural warmth is complemented by soft, warm, and earthy colors that enhance your cozy and grounded appearance.',
    iconPath: 'assets/images/icon-autumn.png',
    paletteImagePath: 'assets/images/gradasi-autumn.png',
    products: <Product>[
      Product(
        name: 'Golden Ember Bronzer',
        imageUrl: 'https://placehold.co/600x800/D9B38C/000?text=Autumn+Product+1',
      ),
      Product(
        name: 'Spice Maple Lip Cream',
        imageUrl: 'https://placehold.co/600x800/C78054/000?text=Autumn+Product+2',
      ),
      Product(
        name: 'Olive Grove Palette',
        imageUrl: 'https://placehold.co/600x800/B6A67C/000?text=Autumn+Product+3',
      ),
      Product(
        name: 'Rust Velvet Blush',
        imageUrl: 'https://placehold.co/600x800/CB6F4A/000?text=Autumn+Product+4',
      ),
    ],
  ),
  SeasonCategory(
    name: 'Spring',
    description:
        'As a Spring, your natural radiance is complemented by bright, warm, and clear colors that enhance your fresh and lively appearance.',
    iconPath: 'assets/images/icon-spring.png',
    paletteImagePath: 'assets/images/gradasi-spring.png',
    products: <Product>[
      Product(
        name: 'Peach Blossom Blush',
        imageUrl: 'https://placehold.co/600x800/F8C5B1/000?text=Spring+Product+1',
      ),
      Product(
        name: 'Coral Bloom Lip Stain',
        imageUrl: 'https://placehold.co/600x800/F3A797/000?text=Spring+Product+2',
      ),
      Product(
        name: 'Mint Meadow Eyeshadow',
        imageUrl: 'https://placehold.co/600x800/C6E5C7/000?text=Spring+Product+3',
      ),
      Product(
        name: 'Sunlit Honey Highlighter',
        imageUrl: 'https://placehold.co/600x800/F6D28E/000?text=Spring+Product+4',
      ),
    ],
  ),
  SeasonCategory(
    name: 'Winter',
    description:
        'As a Winter, your natural contrast is complemented by cool, deep, and vivid colors that enhance your striking and dramatic appearance.',
    iconPath: 'assets/images/icon-winter.png',
    paletteImagePath: 'assets/images/gradasi-winter.png',
    products: <Product>[
      Product(
        name: 'Royal Amethyst Eyeshadow',
        imageUrl: 'https://placehold.co/600x800/C5C4F4/000?text=Winter+Product+1',
      ),
      Product(
        name: 'Classic Ruby Lipstick',
        imageUrl: 'https://placehold.co/600x800/D2526C/000?text=Winter+Product+2',
      ),
      Product(
        name: 'Midnight Onyx Eyeliner',
        imageUrl: 'https://placehold.co/600x800/6C6F87/000?text=Winter+Product+3',
      ),
      Product(
        name: 'Snow Glow Setting Powder',
        imageUrl: 'https://placehold.co/600x800/E9EBF7/000?text=Winter+Product+4',
      ),
    ],
  ),
];
