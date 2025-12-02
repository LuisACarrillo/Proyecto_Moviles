import 'package:flutter/material.dart';
import 'package:proyecto/features/store/services/payment_link_service.dart';
import 'package:proyecto/routes/app_routes.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/shared/widgets/primary_button.dart';
import 'package:proyecto/features/store/state/cart_controller.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/features/store/disccount.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartController>(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    bool descuento = DiscountState.descuentoActivo;
    double valor = 0;
    // Lógica del descuento
    if (descuento) {
      valor = cart.totalPrice * 0.10; // 10%
    }

    double totalConDescuento = cart.totalPrice - valor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Carrito",
          style: tt.titleLarge?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: cart.items.isEmpty
            ? Center(
                child: Text(
                  "Tu carrito está vacío 🐾",
                  style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: cart.items.entries.map((entry) {
                        final product = entry.key;
                        final qty = entry.value;
                        return CustomCard(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                color: cs.primary,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: tt.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "MXN ${product.price.toStringAsFixed(2)}",
                                      style: tt.bodySmall?.copyWith(
                                        color: cs.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                    onPressed: () => cart.remove(product),
                                  ),
                                  Text("$qty"),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () => cart.add(product),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // MOSTRAR TOTAL
                  Text(
                    'Total: MXN ${cart.totalPrice.toStringAsFixed(2)}',
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // BOTÓN PAGO
                  PrimaryButton(
                    text: "Proceder al pago",
                    onPressed: () {
                      if (descuento) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Se aplicó un 10% de descuento 🐾'),
                          ),
                        );
                      }

                      Navigator.pushNamed(context, AppRoutes.stripeCheckout);
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
