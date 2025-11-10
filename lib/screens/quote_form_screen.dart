
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote_item.dart';
import '../screens/quote_preview_screen.dart';
import '../widgets/quote_item_row.dart';

class QuoteFormScreen extends StatefulWidget {
  const QuoteFormScreen({super.key});

  @override
  State<QuoteFormScreen> createState() => _QuoteFormScreenState();
}

class _QuoteFormScreenState extends State<QuoteFormScreen> {
  // --- Controllers ---
  final _clientNameController = TextEditingController();
  final _clientAddressController = TextEditingController();
  final _clientRefController = TextEditingController();

  // --- State Variables ---
  List<QuoteItem> items = [QuoteItem()];
  bool taxInclusive = false;
  final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  @override
  void initState() {
    super.initState();
    _loadSavedQuote();
  }

  // --- Calculation ---
  double get subtotal =>
      items.fold(0, (s, item) => s + item.getTotal(taxInclusive: taxInclusive));

  // --- Add/Remove Line Items ---
  void _addItem() => setState(() => items.add(QuoteItem()));
  void _removeItem(int i) => setState(() => items.removeAt(i));

  // --- Save Data Locally ---
  Future<void> _saveQuote() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'client': {
        'name': _clientNameController.text,
        'address': _clientAddressController.text,
        'reference': _clientRefController.text,
      },
      'taxInclusive': taxInclusive,
      'items': items
          .map((e) => {
        'name': e.name,
        'quantity': e.quantity,
        'rate': e.rate,
        'discount': e.discount,
        'tax': e.tax,
      })
          .toList(),
    };
    await prefs.setString('last_quote', jsonEncode(data));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Quote saved locally!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // --- Load Saved Data ---
  Future<void> _loadSavedQuote() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('last_quote');
    if (jsonStr != null) {
      final data = jsonDecode(jsonStr);
      setState(() {
        _clientNameController.text = data['client']['name'];
        _clientAddressController.text = data['client']['address'];
        _clientRefController.text = data['client']['reference'];
        taxInclusive = data['taxInclusive'] ?? false;
        items = (data['items'] as List)
            .map((e) => QuoteItem(
          name: e['name'],
          quantity: e['quantity'],
          rate: e['rate'],
          discount: e['discount'],
          tax: e['tax'],
        ))
            .toList();
      });
    }
  }

  // --- UI Build ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧾 Smart Quote Builder'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Quote',
            onPressed: _saveQuote,
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Preview Quote',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuotePreviewScreen(
                    clientName: _clientNameController.text,
                    clientAddress: _clientAddressController.text,
                    clientRef: _clientRefController.text,
                    items: items,
                    subtotal: subtotal,
                    taxInclusive: taxInclusive,
                  ),
                ),
              );
            },
          ),
        ],
      ),

      // --- Main Body ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClientInfoCard(),
            const SizedBox(height: 16),
            _buildSettingsRow(),
            const SizedBox(height: 16),
            const Text(
              '🧩 Line Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Dynamic list of items
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) => QuoteItemRow(
                key: ValueKey(index),
                item: items[index],
                onChanged: (updated) => setState(() => items[index] = updated),
                onRemove: () => _removeItem(index),
                taxInclusive: taxInclusive,
              ),
            ),

            const SizedBox(height: 12),
            Center(
              child: FilledButton.icon(
                onPressed: _addItem,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add Item'),
              ),
            ),

            const SizedBox(height: 24),
            _buildTotalsCard(),
          ],
        ),
      ),
    );
  }

  // --- Widgets ---
  Widget _buildClientInfoCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('👤 Client Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _clientNameController,
              decoration: const InputDecoration(
                labelText: 'Client Name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _clientAddressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _clientRefController,
              decoration: const InputDecoration(
                labelText: 'Reference',
                prefixIcon: Icon(Icons.description),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '💰 Tax Inclusive?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Switch(
          value: taxInclusive,
          onChanged: (v) => setState(() => taxInclusive = v),
          activeColor: Colors.indigo,
        ),
      ],
    );
  }

  Widget _buildTotalsCard() {
    return Card(
      color: Colors.indigo.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Subtotal: ${currencyFormat.format(subtotal)}'),
            const SizedBox(height: 5),
            Text(
              'Grand Total: ${currencyFormat.format(subtotal)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
