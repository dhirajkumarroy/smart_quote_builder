
import 'package:flutter/material.dart';
import '../models/quote_item.dart';
import 'package:intl/intl.dart';

class QuoteItemRow extends StatefulWidget {
  final QuoteItem item;
  final Function(QuoteItem) onChanged;
  final VoidCallback onRemove;
  final bool taxInclusive;

  const QuoteItemRow({
    super.key,
    required this.item,
    required this.onChanged,
    required this.onRemove,
    this.taxInclusive = false,
  });

  @override
  State<QuoteItemRow> createState() => _QuoteItemRowState();
}

class _QuoteItemRowState extends State<QuoteItemRow> {
  final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.indigo.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.shopping_bag_outlined),
                  labelText: 'Product / Service'),
              onChanged: (val) => widget.onChanged(widget.item..name = val),
            ),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                  child: TextField(
                      decoration: const InputDecoration(labelText: 'Qty'),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => widget.onChanged(
                          widget.item..quantity = int.tryParse(val) ?? 1))),
              const SizedBox(width: 8),
              Expanded(
                  child: TextField(
                      decoration: const InputDecoration(labelText: 'Rate'),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => widget.onChanged(
                          widget.item..rate = double.tryParse(val) ?? 0))),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                  child: TextField(
                      decoration:
                      const InputDecoration(labelText: 'Discount (₹)'),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => widget.onChanged(
                          widget.item..discount = double.tryParse(val) ?? 0))),
              const SizedBox(width: 8),
              Expanded(
                  child: TextField(
                      decoration: const InputDecoration(labelText: 'Tax (%)'),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => widget.onChanged(
                          widget.item..tax = double.tryParse(val) ?? 0))),
            ]),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: ${currencyFormat.format(widget.item.getTotal(taxInclusive: widget.taxInclusive))}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.indigo)),
                IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
