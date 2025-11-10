
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/quote_item.dart';
import 'package:pdf/pdf.dart';


class QuotePreviewScreen extends StatefulWidget {
  final String clientName;
  final String clientAddress;
  final String clientRef;
  final List<QuoteItem> items;
  final double subtotal;
  final bool taxInclusive;

  const QuotePreviewScreen({
    super.key,
    required this.clientName,
    required this.clientAddress,
    required this.clientRef,
    required this.items,
    required this.subtotal,
    this.taxInclusive = false,
  });

  @override
  State<QuotePreviewScreen> createState() => _QuotePreviewScreenState();
}

class _QuotePreviewScreenState extends State<QuotePreviewScreen> {
  final formatCurrency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
  String status = 'Draft';
  bool generating = false;

  Future<File> _generatePDF({bool saveOnly = false}) async {
    setState(() => generating = true);

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Product Quote',
                style: pw.TextStyle(
                    fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo)),
            pw.SizedBox(height: 10),
            pw.Text('Client: ${widget.clientName}'),
            pw.Text('Address: ${widget.clientAddress}'),
            pw.Text('Reference: ${widget.clientRef}'),
            pw.Text('Status: $status'),
            pw.Text('Mode: ${widget.taxInclusive ? "Tax Inclusive" : "Tax Exclusive"}'),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['Item', 'Qty', 'Rate', 'Tax %', 'Total'],
              data: widget.items.map((i) {
                return [
                  i.name,
                  i.quantity.toString(),
                  i.rate.toStringAsFixed(2),
                  i.tax.toStringAsFixed(2),
                  i.getTotal(taxInclusive: widget.taxInclusive).toStringAsFixed(2),
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo),
              cellAlignment: pw.Alignment.centerRight,
              cellStyle: const pw.TextStyle(fontSize: 10),
            ),
            pw.SizedBox(height: 10),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text('Grand Total: ₹${widget.subtotal.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.indigo)),
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.Text('Thank you for your business!',
                style: const pw.TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );

    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/Quote_${widget.clientName}.pdf");
    await file.writeAsBytes(bytes);

    setState(() => generating = false);
    if (!saveOnly) {
      await Printing.layoutPdf(onLayout: (format) async => bytes);
    }
    return file;
  }

  Future<void> _sharePDF() async {
    try {
      final file = await _generatePDF(saveOnly: true);
      await Share.shareXFiles([XFile(file.path)],
          text:
          "📄 Quote for ${widget.clientName}\nStatus: $status\nTotal: ${formatCurrency.format(widget.subtotal)}");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing PDF: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📄 Quote Preview'),
        actions: [
          IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: 'Export PDF',
              onPressed: _generatePDF),
          IconButton(
              icon: const Icon(Icons.share),
              tooltip: 'Share Quote',
              onPressed: _sharePDF),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(widget.clientName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.clientAddress),
                    Text('Reference: ${widget.clientRef}'),
                    Text('Mode: ${widget.taxInclusive ? "Tax Inclusive" : "Tax Exclusive"}'),
                  ]),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Quote Status'),
            value: status,
            items: ['Draft', 'Sent', 'Accepted']
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (val) => setState(() => status = val!),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (_, i) => Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text(widget.items[i].name),
                  subtitle: Text(
                      'Qty: ${widget.items[i].quantity} | Rate: ₹${widget.items[i].rate} | Tax: ${widget.items[i].tax}%'),
                  trailing: Text(formatCurrency.format(
                      widget.items[i].getTotal(taxInclusive: widget.taxInclusive))),
                ),
              ),
            ),
          ),
          const Divider(),
          Align(
            alignment: Alignment.centerRight,
            child: Text('Grand Total: ${formatCurrency.format(widget.subtotal)}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
          ),
          const SizedBox(height: 10),
          if (generating)
            const Center(child: CircularProgressIndicator())
          else
            Center(
              child: FilledButton.icon(
                onPressed: _sharePDF,
                icon: const Icon(Icons.share),
                label: const Text('Share Quote PDF'),
              ),
            ),
        ]),
      ),
    );
  }
}
