import 'package:mycommmerce/app/helpers/generate_random.dart';
import 'package:vania/vania.dart';

class ProductNote extends Model {
  ProductNote() {
    super.table('productnotes');
  }
  String generateId() {
    return GenerateRandom.generateRandomString(5);
  }
}
