import 'package:mycommmerce/app/helpers/response_helper.dart';
import 'package:mycommmerce/app/models/customer.dart';
import 'package:vania/vania.dart';

class CustomerController extends Controller {
  // Index: Menampilkan semua customer
  Future<Response> index() async {
    try {
      var data = await Customer().query().get();
      return Response.json(ResponseHelper.success(data));
    } catch (e) {
      return Response.json(ResponseHelper.error(), 500);
    }
  }

  // Store: Menambahkan data customer
  Future<Response> store(Request request) async {
    try {
      var name = request.input('name');
      var address = request.input('address');
      var kota = request.input('kota');
      var zip = request.input('zip');
      var country = request.input('country');
      var telp = request.input('telp');

      // Validasi input
      if (name == null ||
          address == null ||
          kota == null ||
          zip == null ||
          country == null ||
          telp == null) {
        return Response.json(
            ResponseHelper.invalid('Harap isi semua data'), 400);
      }

      var custId = Customer().generateId();
      await Customer().query().insert({
        'cust_id': custId,
        'cust_name': name,
        'cust_address': address,
        'cust_city': kota,
        'cust_zip': zip,
        'cust_country': country,
        'cust_telp': telp,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });      
      var data = await Customer().query().where('cust_id', '=', custId).first();
      return Response.json(
          ResponseHelper.success(data, "Berhasil menambahkan customer"));
    } catch (e) {
      print(e);
      return Response.json(ResponseHelper.error());
    }
  }

  // Show: Menampilkan detail customer
  Future<Response> show(String id) async {
    try {
      var customer = await Customer().query().where('cust_id', '=', id).first();
      // Validasi apakah customer ditemukan
      if (customer == null) {
        return Response.json(ResponseHelper.notFound(), 404);
      }
      return Response.json(ResponseHelper.success(customer));
    } catch (e) {
      return Response.json(ResponseHelper.error(), 500);
    }
  }

  // Update: Mengupdate data customer
  Future<Response> update(Request request, String id) async {
    try {
      var name = request.input('name');
      var address = request.input('address');
      var kota = request.input('kota');
      var zip = request.input('zip');
      var country = request.input('country');
      var telp = request.input('telp');

      if (name == null ||
          address == null ||
          kota == null ||
          zip == null ||
          country == null ||
          telp == null) {
        return Response.json(
            ResponseHelper.invalid('Harap isi semua data'), 400);
      }

      var check = await Customer().query().where('cust_id', '=', id).first();
      // Validasi apakah customer ditemukan
      if (check == null) {
        return Response.json(ResponseHelper.notFound(), 404);
      }

      await Customer().query().where('cust_id', '=', id).update({
        'cust_name': name,
        'cust_address': address,
        'cust_city': kota,
        'cust_zip': zip,
        'cust_country': country,
        'cust_telp': telp,
        'updated_at': DateTime.now().toIso8601String(),
      });
      var data = await Customer().query().where('cust_id', '=', id).first();
      return Response.json(
          ResponseHelper.success(data, "Berhasil mengupdate data customer"));
    } catch (e) {
      return Response.json(ResponseHelper.error());
    }
  }

  // Destroy: Menghapus data customer
  Future<Response> destroy(String id) async {
    try {      
      var data = await Customer().query().where('cust_id', '=', id).first();
      // Validasi apakah customer ditemukan
      if (data == null) {
        return Response.json(ResponseHelper.notFound(), 404);
      }
      await Customer().query().where('cust_id', '=', id).delete();
      return Response.json(
          ResponseHelper.success(data, "Berhasil menghapus data customer"));
    } catch (e) {
      return Response.json(ResponseHelper.error());
    }
  }
}

final CustomerController customerController = CustomerController();
