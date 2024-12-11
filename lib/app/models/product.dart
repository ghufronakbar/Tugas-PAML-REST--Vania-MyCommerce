import 'package:mycommmerce/app/helpers/generate_random.dart';
import 'package:vania/vania.dart';

class Product extends Model {
  Product() {
    super.table('products');
  }
  String generateId() {
    return GenerateRandom.generateRandomString(5);
  }
}
