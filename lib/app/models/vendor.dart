import 'package:mycommmerce/app/helpers/generate_random.dart';
import 'package:vania/vania.dart';

class Vendor extends Model {
  Vendor() {
    super.table('vendors');
  }
  String generateId() {
    return GenerateRandom.generateRandomString(5);
  }
}
