import 'package:mycommmerce/app/helpers/response_helper.dart';
import 'package:mycommmerce/app/models/vendor.dart';
import 'package:vania/vania.dart';

class VendorController extends Controller {
  // Index: Menampilkan semua vendor
  Future<Response> index() async {
    try {
      var data = await Vendor().query().get();
      return Response.json(ResponseHelper.success(data));
    } catch (e) {
      return Response.json(ResponseHelper.error(), 500);
    }
  }

  // Store: Menambahkan vendor baru
  Future<Response> store(Request request) async {
    try {
      var name = request.input('name');
      var address = request.input('address');
      var kota = request.input('kota');
      var state = request.input('state');
      var zip = request.input('zip');
      var country = request.input('country');

      // Validasi input
      if (name == null ||
          address == null ||
          kota == null ||
          state == null ||
          zip == null ||
          country == null) {
        return Response.json(ResponseHelper.invalid('Harap isi semua data'), 400);
      }

      // Generate ID dan simpan vendor
      var vendId = Vendor().generateId();
      await Vendor().query().insert({
        'vend_id': vendId,
        'vend_name': name,
        'vend_address': address,
        'vend_kota': kota,
        'vend_state': state,
        'vend_zip': zip,
        'vend_country': country,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Ambil data yang baru saja disimpan
      var data = await Vendor().query().where('vend_id', '=', vendId).first();
      return Response.json(ResponseHelper.success(data, "Berhasil menambahkan vendor"));
    } catch (e) {
      print(e);
      return Response.json(ResponseHelper.error());
    }
  }

  // Show: Menampilkan vendor berdasarkan ID
  Future<Response> show(String id) async {
    try {
      var vendor = await Vendor().query().where('vend_id', '=', id).first();
      if (vendor == null) {
        return Response.json(ResponseHelper.notFound(), 404);
      }
      return Response.json(ResponseHelper.success(vendor));
    } catch (e) {
      return Response.json(ResponseHelper.error(), 500);
    }
  }

  // Update: Memperbarui data vendor
  Future<Response> update(Request request, String id) async {
    try {
      var name = request.input('name');
      var address = request.input('address');
      var kota = request.input('kota');
      var state = request.input('state');
      var zip = request.input('zip');
      var country = request.input('country');

      // Validasi input
      if (name == null ||
          address == null ||
          kota == null ||
          state == null ||
          zip == null ||
          country == null) {
        return Response.json(ResponseHelper.invalid('Harap isi semua data'), 400);
      }

      // Cek apakah vendor ada
      var check = await Vendor().query().where('vend_id', '=', id).first();
      if (check == null) {
        return Response.json(ResponseHelper.notFound(), 404);
      }

      // Update data vendor
      await Vendor().query().where('vend_id', '=', id).update({
        'vend_name': name,
        'vend_address': address,
        'vend_kota': kota,
        'vend_state': state,
        'vend_zip': zip,
        'vend_country': country,
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Ambil data yang sudah diupdate
      var data = await Vendor().query().where('vend_id', '=', id).first();
      return Response.json(ResponseHelper.success(data, "Berhasil mengupdate data vendor"));
    } catch (e) {
      return Response.json(ResponseHelper.error());
    }
  }

  // Destroy: Menghapus vendor berdasarkan ID
  Future<Response> destroy(String id) async {
    try {
      var data = await Vendor().query().where('vend_id', '=', id).first();
      if (data == null) {
        return Response.json(ResponseHelper.notFound(), 404);
      }
      
      // Hapus data vendor
      await Vendor().query().where('vend_id', '=', id).delete();
      return Response.json(ResponseHelper.success(data, "Berhasil menghapus data vendor"));
    } catch (e) {
      return Response.json(ResponseHelper.error());
    }
  }
}

final VendorController vendorController = VendorController();
