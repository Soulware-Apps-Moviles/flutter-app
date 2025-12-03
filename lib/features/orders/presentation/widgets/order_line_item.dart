import 'package:flutter/material.dart';
import 'package:tcompro_customer/features/orders/domain/order_line.dart';

class OrderLineItem extends StatelessWidget {
  final OrderLine line;

  const OrderLineItem({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(line.imageUrl),
                fit: BoxFit.cover,
                onError: (_, _) {},
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.name,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text("S/ ${line.price.toStringAsFixed(2)}", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("x${line.quantity}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text("S/ ${(line.price * line.quantity).toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFDD6529), fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}