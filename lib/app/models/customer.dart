import 'package:mycommmerce/app/helpers/generate_random.dart';
import 'package:vania/vania.dart';

class Customer extends Model {
  Customer() {
    super.table('customers');
  }
  String generateId() {
    return GenerateRandom.generateRandomString(5);
  }
}
