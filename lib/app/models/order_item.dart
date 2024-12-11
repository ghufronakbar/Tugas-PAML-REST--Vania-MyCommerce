import 'package:mycommmerce/app/helpers/generate_random.dart';
import 'package:vania/vania.dart';

class OrderItem extends Model {
  OrderItem() {
    super.table('orderitems');
  }
  String generateId() {
    return GenerateRandom.generateRandomNum(11);
  }
}
