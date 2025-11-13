import 'package:flutter/material.dart';

class AddShoppingListWidget extends StatefulWidget {
  final void Function(String) onAdd;

  const AddShoppingListWidget({super.key, required this.onAdd});

  @override
  State<AddShoppingListWidget> createState() => _AddShoppingListWidgetState();
}

class _AddShoppingListWidgetState extends State<AddShoppingListWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
      return Card(
      elevation: 0,
      color: Colors.white,
      child: Column(
        children: [
          const Text("Add shopping list", style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Name', hintText: 'Example name'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              final name = _controller.text.trim();
              if (name.isNotEmpty) {
                widget.onAdd(name);
                _controller.clear();
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
