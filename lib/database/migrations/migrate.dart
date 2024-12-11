import 'dart:io';
import 'package:vania/vania.dart';
import 'create_customers_table.dart';
import 'create_orders_table.dart';
import 'create_order_items_table.dart';
import 'create_products_table.dart';
import 'create_vendors_table.dart';
import 'create_product_notes_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
		 await CreateVendorsTable().up();
		 await CreateCustomersTable().up();
		 await CreateProductsTable().up();
		 await CreateOrdersTable().up();
		 await CreateOrderItemsTable().up();
		 await CreateProductNotesTable().up();
	}

  dropTables() async {
		 await CreateProductNotesTable().down();
		 await CreateVendorsTable().down();
		 await CreateProductsTable().down();
		 await CreateOrderItemsTable().down();
		 await CreateOrdersTable().down();
		 await CreateCustomersTable().down();
	 }
}
