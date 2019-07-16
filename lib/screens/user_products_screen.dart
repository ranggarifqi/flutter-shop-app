import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static String routeName = '/user-product-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName);
            },
          )
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(8),
          child: Consumer<Products>(
            builder: (ctx, productsData, _) {
              return ListView.builder(
                itemCount: productsData.items.length,
                itemBuilder: (ctx, i) {
                  return Column(
                    children: <Widget>[
                      UserProductItem(
                        title: productsData.items[i].title,
                        imageUrl: productsData.items[i].imageUrl,
                      ),
                      Divider(),
                    ],
                  );
                },
              );
            },
          )),
    );
  }
}
