import 'package:mycommmerce/app/helpers/generate_random.dart';
import 'package:vania/vania.dart';

class Order extends Model {
  Order() {
    super.table('orders');
  }
  String generateId() {
    return GenerateRandom.generateRandomNum(11);
  }
}
