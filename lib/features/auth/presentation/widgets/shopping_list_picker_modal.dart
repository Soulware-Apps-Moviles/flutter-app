import 'package:flutter/material.dart';
import 'package:tcompro_customer/shared/domain/shopping_list.dart'; 

class ShoppingListPickerModal extends StatefulWidget {
  final List<ShoppingList> shoppingLists;
  final Function(ShoppingList) onSelect;
  final ScrollController? scrollController;

  const ShoppingListPickerModal({
    super.key,
    required this.shoppingLists,
    required this.onSelect,
    this.scrollController,
  });

  @override
  State<ShoppingListPickerModal> createState() => _ShoppingListPickerModalState();
}

class _ShoppingListPickerModalState extends State<ShoppingListPickerModal> {
  List<ShoppingList> _filteredLists = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredLists = widget.shoppingLists;
  }

  void _filterLists(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredLists = widget.shoppingLists;
      } else {
        _filteredLists = widget.shoppingLists.where((list) {
          return list.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título del Modal
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Text(
            "Select a Shopping List",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Buscador
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search your lists...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            onChanged: _filterLists,
          ),
          const SizedBox(height: 10),

          // Lista de resultados
          Expanded(
            child: _filteredLists.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: widget.scrollController,
                    itemCount: _filteredLists.length,
                    itemBuilder: (context, index) {
                      final list = _filteredLists[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.list_alt_rounded,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        title: Text(
                          list.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        // Opcional: Mostrar cantidad de items sutilmente
                        subtitle: Text(
                          "${list.items.length} items",
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        onTap: () {
                          widget.onSelect(list);
                          Navigator.pop(context); // Cierra el modal
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.playlist_remove, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            "No lists found",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}