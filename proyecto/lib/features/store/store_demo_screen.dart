import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:proyecto/features/store/models/product.dart';
import 'package:proyecto/features/store/state/cart_controller.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/shared/widgets/primary_button.dart';

class StoreDemoScreen extends StatelessWidget {
  const StoreDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(
          'Catálogo',
          style: tt.titleLarge?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Consumer<CartController>(
            builder: (_, cart, __) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                  ),
                  if (cart.totalItems > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cart.totalItems}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          )
        ],
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("productos").snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snap.data!.docs;

          final products = docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            return Product(
              id: doc.id,
              name: data["Producto"] ?? "Sin nombre",
              price: (data["Precio"] ?? 0).toDouble(),
              image: "", 
            );
          }).toList();

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: .78,
            ),
            itemBuilder: (_, i) {
              final product = products[i];
              final cart = Provider.of<CartController>(context, listen: false);

              return CustomCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: .08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.pets, size: 48), 
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.name,
                      style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "MXN ${product.price.toStringAsFixed(2)}",
                      style: tt.bodySmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    PrimaryButton(
                      text: "Agregar",
                      onPressed: () {
                        cart.add(product);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${product.name} agregado al carrito")),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
