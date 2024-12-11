import 'package:mycommmerce/app/helpers/response_helper.dart';
import 'package:mycommmerce/app/models/order.dart';
import 'package:mycommmerce/app/models/order_item.dart';
import 'package:mycommmerce/app/models/customer.dart';
import 'package:mycommmerce/app/models/product.dart';
import 'package:vania/vania.dart';

class OrderController extends Controller {
  // Index: Menampilkan semua orders dengan join ke orderitems dan customers
  Future<Response> index() async {
    try {
      var data = await Order()
          .query()
          .join('orderitems', 'orders.order_num', '=', 'orderitems.order_num')
          .join('customers', 'orders.cust_id', '=', 'customers.cust_id')
          .get();

      return Response.json(ResponseHelper.success(data));
    } catch (e) {
      print(e);
      return Response.json(ResponseHelper.error(), 500);
    }
  }

  // Show: Menampilkan order berdasarkan order_num dengan join ke orderitems dan customers
  Future<Response> show(String orderNum) async {
    try {
      var data = await Order()
          .query()
          .where('orders.order_num', '=', orderNum)
          .join('orderitems', 'orders.order_num', '=', 'orderitems.order_num')
          .join('customers', 'orders.cust_id', '=', 'customers.cust_id')
          .get();

      if (data.isEmpty) {
        return Response.json(ResponseHelper.notFound(), 404);
      }

      return Response.json(ResponseHelper.success(data));
    } catch (e) {
      return Response.json(ResponseHelper.error(), 500);
    }
  }

  // Store: Menambahkan order dan order items  
  Future<Response> store(Request request) async {
    try {
      var custId = request.input('cust_id');
      var orderItems = request.input('order_items');

      // Validasi input
      if (custId == null || orderItems == null || orderItems.isEmpty) {
        return Response.json(
            ResponseHelper.invalid('Harap isi semua data'), 400);
      }

      // Validasi cust_id
      var customerExists =
          await Customer().query().where('cust_id', '=', custId).first();
      if (customerExists == null) {
        return Response.json(
            ResponseHelper.notFound('Customer tidak ditemukan'), 404);
      }

      // Menyimpan order
      var orderNum = Order().generateId();
      await Order().query().insert({
        'order_num': orderNum,
        'order_date': DateTime.now().toIso8601String(),
        'cust_id': custId,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Menyimpan orderitems
      List<Map<String, dynamic>> insertedItems = [];
      for (var item in orderItems) {
        var prodId = item['prod_id'];
        var quantity = item['quantity'];
        var size = item['size'];

        // Validasi prod_id
        var productExists =
            await Product().query().where('prod_id', '=', prodId).first();
        if (productExists == null) {
          return Response.json(
              ResponseHelper.notFound('Produk tidak ditemukan'), 404);
        }

        // Menyimpan order item
        var orderItemId = OrderItem().generateId();
        await OrderItem().query().insert({
          'order_item': orderItemId,
          'order_num': orderNum,
          'prod_id': prodId,
          'quantity': quantity,
          'size': size,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });

        // Menambahkan data order item yang sudah disimpan ke dalam list untuk response
        var insertedItem = {
          'order_item': orderItemId,
          'order_num': orderNum,
          'prod_id': prodId,
          'quantity': quantity,
          'size': size,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
        insertedItems.add(insertedItem);
      }

      // Mengambil data order yang baru disimpan
      var orderData =
          await Order().query().where('order_num', '=', orderNum).first();

      if (orderData == null) {
        return Response.json(ResponseHelper.notFound(), 404);
      }

      // Membuat response sesuai format baru
      var responseData = {
        'order_num': orderNum,
        'order_date': orderData['order_date'],
        'cust_id': orderData['cust_id'],
        'created_at': orderData['created_at'],
        'updated_at': orderData['updated_at'],
        'orderitems': insertedItems,
      };

      return Response.json(
          ResponseHelper.success(responseData, 'Berhasil membuat order'));
    } catch (e) {
      print(e);
      return Response.json(ResponseHelper.error());
    }
  }

  // Destroy: Menghapus order berdasarkan order_num
  Future<Response> destroy(String orderNum) async {
    try {
      var order =
          await Order().query().where('order_num', '=', orderNum).first();
      if (order == null) {
        return Response.json(ResponseHelper.notFound(), 404);
      }

      // Hapus semua order items yang terkait dengan order_num ini
      await OrderItem().query().where('order_num', '=', orderNum).delete();

      // Hapus order
      await Order().query().where('order_num', '=', orderNum).delete();

      return Response.json(
          ResponseHelper.success(null, "Berhasil menghapus order"));
    } catch (e) {
      return Response.json(ResponseHelper.error());
    }
  }
}

final OrderController orderController = OrderController();
