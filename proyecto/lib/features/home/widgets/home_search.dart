import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/features/home/vet_profile.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/shared/widgets/app_text_field.dart';
import 'package:proyecto/routes/app_routes.dart';

class HomeSearch extends StatefulWidget {
  const HomeSearch({super.key});

  @override
  State<HomeSearch> createState() => _HomeSearchState();
}

class _HomeSearchState extends State<HomeSearch> {
  final _controller = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      final queryToLower = query.toLowerCase();
      final veterinariesSnapshot = await FirebaseFirestore.instance
        .collection("veterinarias")
        .get();

      final veterinariesResult = veterinariesSnapshot.docs
        .where((doc) {
          final data = doc.data();
          final nombre = (doc["nombre"]).toString().toLowerCase();
          final direccion = (doc["direccion"]).toString().toLowerCase();
          return nombre.contains(queryToLower) || direccion.contains(queryToLower);
        })
        .map((doc) => {
          "id": doc.id,
          "tipo": "veterinaria",
          "nombre": doc["nombre"],
          "subtitulo": doc["direccion"],
          "icon": Icons.pets,
        })
        .toList();

      final productosSnapshot = await FirebaseFirestore.instance
        .collection("productos")
        .get();

      final productosResults = productosSnapshot.docs
        .where((doc) {
          final nombre = doc["nombre"];
          final descripcion = doc["descripcion"];
          return nombre.contains(queryToLower) || descripcion.contains(queryToLower);
        })
        .map((doc) => {
          "id": doc.id,
          "tipo": "producto",
          "nombre": doc["nombre"],
          "subtitulo": doc["descripcion"],
          "precio": doc["precio"],
          "icon": Icons.shopping_bag,
        })
        .toList();

      setState(() {
        _searchResults = [...veterinariesResult, ...productosResults];
        _isSearching = false;
      });
    } catch (e) {
      setState(() => _isSearching = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error en la búsqueda: $e"))
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      children: [
        CustomCard(
          padding: const EdgeInsets.all(12),
          child: AppTextField(
            controller: _controller,
            label: "Buscar",
            hint: "Veterinarias, productos...",
            icon: Icons.search,
            onChanged: (value) => _search(value),
          ),
        ),
        if (_controller.text.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: cs.surface,
              border: Border.all(color: cs.outline, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _isSearching
              ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              )
            : _searchResults.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "No se encontraron resultados",
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  final tipo = result["tipo"];
                  final nombre = result["nombre"];
                  final subtitulo = result["subtitulo"];
                  final icon = result["icon"];

                  return ListTile(
                    leading: Icon(icon, color: cs.primary),
                    title: Text(
                      nombre,
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    subtitle: Text(
                      subtitulo,
                      style: tt.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: tipo == "producto"
                      ? Text(
                        "\$${result["precio"]}",
                        style: tt.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      )
                    : null,
                  onTap: () {
                    _controller.clear();
                    setState(() => _searchResults = []);

                    if (tipo == "veterinaria") {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.vetProfile,
                        arguments: VetProfileArgs(
                          vetId: result["id"]
                        ),
                      );
                    } else if (tipo == "producto") {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.store,
                      );
                    }
                  },
                  );
                }
              )
          )
      ],
    );
  }
}
