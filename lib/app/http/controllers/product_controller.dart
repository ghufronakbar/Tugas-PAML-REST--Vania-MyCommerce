import 'package:mycommmerce/app/helpers/response_helper.dart';
import 'package:mycommmerce/app/models/product.dart';
import 'package:mycommmerce/app/models/vendor.dart';
import 'package:vania/vania.dart';

class ProductController extends Controller {
  // Index: Menampilkan semua produk
  Future<Response> index() async {
    try {
      var data = await Product().query().get();
      return Response.json(ResponseHelper.success(data));
    } catch (e) {
      return Response.json(ResponseHelper.error(), 500);
    }
  }

  // Store: Menambahkan produk baru
  Future<Response> store(Request request) async {
    try {
      var vendId = request.input('vend_id');
      var name = request.input('name');
      var price = request.input('price');
      var desc = request.input('desc');

      // Validasi input
      if (vendId == null || name == null || price == null || desc == null) {
        return Response.json(
            ResponseHelper.invalid('Harap isi semua data'), 400);
      }

      // Validasi vend_id (cek apakah vendor dengan vend_id tersebut ada)
      var vendorExists =
          await Vendor().query().where('vend_id', '=', vendId).first();
      if (vendorExists == null) {
        return Response.json(
            ResponseHelper.invalid('Vendor tidak ditemukan'), 400);
      }

      // Simpan produk
      var prodId = Product().generateId();
      await Product().query().insert({
        'prod_id': prodId,
        'vend_id': vendId,
        'prod_name': name,
        'prod_price': price,
        'prod_desc': desc,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Ambil data produk yang baru saja disimpan
      var data = await Product().query().where('prod_id', '=', prodId).first();
      return Response.json(
          ResponseHelper.success(data, "Berhasil menambahkan produk"));
    } catch (e) {
      print(e);
      return Response.json(ResponseHelper.error());
    }
  }

  // Show: Menampilkan produk berdasarkan ID
  Future<Response> show(String id) async {
    try {
      var product = await Product().query().where('prod_id', '=', id).first();
      if (product == null) {
        return Response.json(ResponseHelper.notFound(), 404);
      }
      return Response.json(ResponseHelper.success(product));
    } catch (e) {
      return Response.json(ResponseHelper.error(), 500);
    }
  }

  // Update: Memperbarui data produk
  Future<Response> update(Request request, String id) async {
    try {
      var vendId = request.input('vend_id');
      var name = request.input('name');
      var price = request.input('price');
      var desc = request.input('desc');

      // Validasi input
      if (vendId == null || name == null || price == null || desc == null) {
        return Response.json(
            ResponseHelper.invalid('Harap isi semua data'), 400);
      }

      // Validasi vend_id (cek apakah vendor dengan vend_id tersebut ada)
      var vendorExists =
          await Vendor().query().where('vend_id', '=', vendId).first();
      if (vendorExists == null) {
        return Response.json(
            ResponseHelper.invalid('Vendor tidak ditemukan'), 400);
      }

      // Cek apakah produk dengan prod_id tersebut ada
      var check = await Product().query().where('prod_id', '=', id).first();
      if (check == null) {
        return Response.json(ResponseHelper.notFound(), 404);
      }

      // Update data produk
      await Product().query().where('prod_id', '=', id).update({
        'vend_id': vendId,
        'prod_name': name,
        'prod_price': price,
        'prod_desc': desc,
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Ambil data produk yang sudah diupdate
      var data = await Product().query().where('prod_id', '=', id).first();
      return Response.json(
          ResponseHelper.success(data, "Berhasil mengupdate data produk"));
    } catch (e) {
      return Response.json(ResponseHelper.error());
    }
  }

  // Destroy: Menghapus produk berdasarkan ID
  Future<Response> destroy(String id) async {
    try {
      var data = await Product().query().where('prod_id', '=', id).first();
      if (data == null) {
        return Response.json(ResponseHelper.notFound(), 404);
      }

      // Hapus data produk
      await Product().query().where('prod_id', '=', id).delete();
      return Response.json(
          ResponseHelper.success(data, "Berhasil menghapus data produk"));
    } catch (e) {
      return Response.json(ResponseHelper.error());
    }
  }
}

final ProductController productController = ProductController();
