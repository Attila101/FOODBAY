import '../models/categories_model.dart';
import '../services/assets_manager.dart';

class AppConstants {
  static const String imageUrl =
      'https://i.ibb.co/8r1Ny2n/20-Nike-Air-Force-1-07.png';

  static List<String> bannersImages = [
    AssetsManager.banner1,
    AssetsManager.banner2
  ];

  static List<CategoriesModel> categoriesList = [
    CategoriesModel(
      id: "UB",
      image: AssetsManager.ub,
      name: "UB",
    ),
    CategoriesModel(
      id: "Mayuri",
      image: AssetsManager.mayuri,
      name: "Mayuri",
    ),
    CategoriesModel(
      id: "Boys Mess",
      image: AssetsManager.boys,
      name: "Boys Mess",
    ),
    CategoriesModel(
      id: "Girls Mess",
      image: AssetsManager.girls,
      name: "Girls Mess",
    ),
  ];
}
