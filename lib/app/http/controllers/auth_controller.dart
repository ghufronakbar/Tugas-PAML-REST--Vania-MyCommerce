import 'package:mycommmerce/app/helpers/response_helper.dart';
import 'package:mycommmerce/app/models/customer.dart';
import 'package:vania/vania.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class AuthController extends Controller {
  // Index: Menampilkan semua customer
  Future<Response> login(Request request) async {
    try {
      var email = request.input('email');
      var password = request.input('password');

      if (email == null || password == null) {
        return Response.json(
            ResponseHelper.invalid('Harap isi semua data'), 400);
      }

      var check = await Customer().query().where('email', '=', email).first();

      if (check == null) {
        return Response.json(
            ResponseHelper.invalid("Email tidak ditemukan"), 400);
      }

      if (!BCrypt.checkpw(password, check['password'])) {
        return Response.json(ResponseHelper.invalid("Password salah"), 400);
      }

      var token = JWT({
        'cust_id': check['cust_id'],
      });

      var tokenString = token.sign(SecretKey('my_secret_key'));

      await Customer()
          .query()
          .where('cust_id', '=', check['cust_id'])
          .update({'refresh_token': tokenString});

      return Response.json(ResponseHelper.success(tokenString));
    } catch (e) {
      print(e);
      return Response.json(ResponseHelper.error(), 500);
    }
  }
}

final AuthController authController = AuthController();
