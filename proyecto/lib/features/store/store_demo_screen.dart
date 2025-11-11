import 'package:flutter/material.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/shared/widgets/primary_button.dart';

class StoreDemoScreen extends StatefulWidget {
  const StoreDemoScreen({super.key});

  @override
  State<StoreDemoScreen> createState() => _StoreDemoScreenState();
}

class _StoreDemoScreenState extends State<StoreDemoScreen> {
  String _category = 'Todos';
  String _sort = 'Relevancia';

  final _products = const [
    ('Croquetas Premium 5kg', 'MXN 549', Icons.pets),
    ('Collar Antipulgas', 'MXN 299', Icons.checkroom),
    ('Shampoo Hipoalergénico', 'MXN 189', Icons.soap),
    ('Snack Dental 15 pzs', 'MXN 159', Icons.local_florist),
    ('Cama Mediana', 'MXN 899', Icons.bed),
    ('Plato Doble Inox', 'MXN 249', Icons.restaurant),
  ];

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
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: _ThemedDropdown<String>(
                      value: _category,
                      label: 'Categoría',
                      prefixIcon: Icons.category_outlined,
                      items: const [
                        DropdownMenuItem(value: 'Todos', child: Text('Todos')),
                        DropdownMenuItem(
                          value: 'Alimentos',
                          child: Text('Alimentos'),
                        ),
                        DropdownMenuItem(
                          value: 'Higiene',
                          child: Text('Higiene'),
                        ),
                        DropdownMenuItem(
                          value: 'Accesorios',
                          child: Text('Accesorios'),
                        ),
                      ],
                      onChanged: (v) =>
                          setState(() => _category = v ?? 'Todos'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ThemedDropdown<String>(
                      value: _sort,
                      label: 'Ordenar por',
                      prefixIcon: Icons.sort,
                      items: const [
                        DropdownMenuItem(
                          value: 'Relevancia',
                          child: Text('Relevancia'),
                        ),
                        DropdownMenuItem(
                          value: 'Precio: menor a mayor',
                          child: Text('Precio: menor a mayor'),
                        ),
                        DropdownMenuItem(
                          value: 'Precio: mayor a menor',
                          child: Text('Precio: mayor a menor'),
                        ),
                      ],
                      onChanged: (v) =>
                          setState(() => _sort = v ?? 'Relevancia'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: .78,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final (name, price, icon) = _products[index];
                return _ProductCard(name: name, price: price, icon: icon);
              }, childCount: _products.length),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemedDropdown<T> extends StatelessWidget {
  const _ThemedDropdown({
    required this.value,
    required this.label,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
  });

  final T? value;
  final String label;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      isDense: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      iconSize: 20,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      items: items,
      onChanged: onChanged,
      dropdownColor: cs.surface,
      style: tt.bodyMedium?.copyWith(color: cs.onSurface),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.name,
    required this.price,
    required this.icon,
  });

  final String name;
  final String price;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

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
              child: Icon(icon, color: cs.primary, size: 48),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: tt.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: tt.bodySmall?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          PrimaryButton(
            text: 'Agregar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Aquí se agregará el producto al carrito'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
