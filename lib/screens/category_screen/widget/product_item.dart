import 'package:flutter/material.dart';

import '../../../database/model/product_dto.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({super.key, required this.product, required this.index});

  final ProductDTO product;
  final int index;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        decoration: BoxDecoration(
            color: widget.product.productData.isSynced ? Colors.green : Colors.white12, borderRadius: BorderRadius.circular(5)),
        child: Text('${widget.index + 1}', style: const TextStyle(color: Colors.white)),
      ),
      title: Text(widget.product.productData.name),
      subtitle: Text(widget.product.productData.vendorCode ?? widget.product.productData.code ?? ""),
      trailing: Text('${widget.product.productData.categoryId}'),
    );
  }
}
