import 'package:mycommmerce/app/helpers/response_helper.dart';
import 'package:mycommmerce/app/models/product_note.dart';
import 'package:mycommmerce/app/models/product.dart';
import 'package:vania/vania.dart';

class ProductNoteController extends Controller {
  // Index: Menampilkan semua catatan produk
  Future<Response> index() async {
    try {
      var data = await ProductNote().query().get();
      return Response.json(ResponseHelper.success(data));
    } catch (e) {
      return Response.json(ResponseHelper.error(), 500);
    }
  }

  // Store: Menambahkan catatan untuk produk
  Future<Response> store(Request request) async {
    try {
      var prodId = request.input('prod_id');
      var noteText = request.input('note_text');

      // Validasi input
      if (prodId == null || noteText == null) {
        return Response.json(
            ResponseHelper.invalid('Harap isi semua data'), 400);
      }

      // Validasi prod_id (cek apakah produk dengan prod_id tersebut ada)
      var productExists =
          await Product().query().where('prod_id', '=', prodId).first();
      if (productExists == null) {
        return Response.json(
            ResponseHelper.invalid('Produk tidak ditemukan'), 400);
      }

      // Simpan catatan produk
      var noteId = ProductNote().generateId();
      await ProductNote().query().insert({
        'note_id': noteId,
        'prod_id': prodId,
        'note_date': DateTime.now().toIso8601String(),
        'note_text': noteText,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Ambil data catatan yang baru saja disimpan
      var data =
          await ProductNote().query().where('note_id', '=', noteId).first();
      return Response.json(
          ResponseHelper.success(data, "Berhasil menambahkan catatan produk"));
    } catch (e) {
      print(e);
      return Response.json(ResponseHelper.error());
    }
  }

  // Show: Menampilkan catatan produk berdasarkan ID
  Future<Response> show(String id) async {
    try {
      var note = await ProductNote().query().where('note_id', '=', id).first();
      if (note == null) {
        return Response.json(ResponseHelper.notFound(), 404);
      }
      return Response.json(ResponseHelper.success(note));
    } catch (e) {
      return Response.json(ResponseHelper.error(), 500);
    }
  }

  // Update: Memperbarui catatan produk
  Future<Response> update(Request request, String id) async {
    try {
      var prodId = request.input('prod_id');
      var noteText = request.input('note_text');

      // Validasi input
      if (prodId == null || noteText == null) {
        return Response.json(
            ResponseHelper.invalid('Harap isi semua data'), 400);
      }

      // Validasi prod_id (cek apakah produk dengan prod_id tersebut ada)
      var productExists =
          await Product().query().where('prod_id', '=', prodId).first();
      if (productExists == null) {
        return Response.json(
            ResponseHelper.invalid('Produk tidak ditemukan'), 400);
      }

      // Cek apakah catatan dengan note_id tersebut ada
      var check = await ProductNote().query().where('note_id', '=', id).first();
      if (check == null) {
        return Response.json(ResponseHelper.notFound(), 404);
      }

      // Update data catatan produk
      await ProductNote().query().where('note_id', '=', id).update({
        'prod_id': prodId,        
        'note_text': noteText,
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Ambil data catatan yang sudah diupdate
      var data = await ProductNote().query().where('note_id', '=', id).first();
      return Response.json(ResponseHelper.success(
          data, "Berhasil mengupdate data catatan produk"));
    } catch (e) {
      return Response.json(ResponseHelper.error());
    }
  }

  // Destroy: Menghapus catatan produk berdasarkan ID
  Future<Response> destroy(String id) async {
    try {
      var data = await ProductNote().query().where('note_id', '=', id).first();
      if (data == null) {
        return Response.json(ResponseHelper.notFound(), 404);
      }

      // Hapus data catatan produk
      await ProductNote().query().where('note_id', '=', id).delete();
      return Response.json(ResponseHelper.success(
          data, "Berhasil menghapus data catatan produk"));
    } catch (e) {
      return Response.json(ResponseHelper.error());
    }
  }
}

final ProductNoteController productNoteController = ProductNoteController();
