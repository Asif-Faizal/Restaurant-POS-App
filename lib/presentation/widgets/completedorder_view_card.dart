import 'dart:convert';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../data/models/order_model.dart';
import '../../data/models/order_item_model.dart';
import '../pages/order_details.dart';

class CompletedOrderViewCard extends StatefulWidget {
  const CompletedOrderViewCard({
    Key? key,
    required this.order,
    required this.imageUrls,
  }) : super(key: key);

  final Order order;
  final List<String> imageUrls;

  @override
  _CompletedOrderViewCardState createState() => _CompletedOrderViewCardState();
}

class _CompletedOrderViewCardState extends State<CompletedOrderViewCard> {
  Uint8List? pdfBytes; // Variable to store PDF bytes
  bool loading = false; // State to control loading state

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetails(
              table: widget.order.tableId.toString(),
              customerName: widget.order.customerName,
              customerNumber: widget.order.customerNumber,
            ),
          ),
        );
      },
      child: Card(
        color: const Color.fromARGB(255, 255, 242, 202),
        child: Column(
          children: [
            SizedBox(
              height: 110,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: CarouselSlider(
                        items: widget.imageUrls.map((url) {
                          return Center(
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              height: 80,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image);
                              },
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          autoPlayInterval: const Duration(milliseconds: 1000),
                          autoPlay: true,
                          aspectRatio: 1.0,
                          onPageChanged: (index, reason) {},
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Table ${widget.order.tableId}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.order.customerName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '₹ ${widget.order.totalAmount}',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat.Hm().format(widget.order.orderTime),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        OutlinedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black),
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 254, 231, 163)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            printDeviceInfo();
                            try {
                              setState(() {
                                loading = true; // Set loading state
                              });

                              final orderItems =
                                  await fetchOrderItems(widget.order.tableId);
                              final pdf = await createPdf(
                                  widget.order, orderItems); // Generate PDF

                              setState(() {
                                pdfBytes = pdf; // Set PDF bytes
                                loading = false; // Set loading state
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('PDF previewed successfully')),
                              );
                              if (pdfBytes != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PdfViewerScreen(pdfBytes!),
                                  ),
                                );
                              }
                            } catch (e) {
                              setState(() {
                                loading = false; // Set loading state
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Failed to preview PDF: $e')),
                              );
                              print(e);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Preview'),
                                Icon(Icons.preview),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            if (loading) CircularProgressIndicator(),
            if (pdfBytes != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfViewerScreen(pdfBytes!),
                      ),
                    );
                  },
                  child: Text('Open PDF'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PdfViewerScreen extends StatelessWidget {
  final Uint8List pdfBytes;

  const PdfViewerScreen(this.pdfBytes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SfPdfViewer.memory(
            pdfBytes,
            initialZoomLevel: 1.0,
            pageSpacing: 8,
            controller: PdfViewerController(),
          );
        },
      ),
    );
  }
}

Future<Uint8List> createPdf(Order order, List<OrderItem> orderItems) async {
  final pdf = pw.Document();
  final fontData = await rootBundle.load('assets/NotoSans-Regular.ttf');
  final ttf = pw.Font.ttf(fontData);

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Order Details',
                style: pw.TextStyle(font: ttf, fontSize: 24)),
            pw.SizedBox(height: 16),
            pw.Text('Table: ${order.tableId}',
                style: pw.TextStyle(font: ttf, fontSize: 18)),
            pw.Text('Customer Name: ${order.customerName}',
                style: pw.TextStyle(font: ttf, fontSize: 18)),
            pw.Text('Customer Number: ${order.customerNumber}',
                style: pw.TextStyle(font: ttf, fontSize: 18)),
            pw.SizedBox(height: 16),
            pw.Text('Items:', style: pw.TextStyle(font: ttf, fontSize: 20)),
            pw.SizedBox(height: 8),
            ...orderItems.map((item) => pw.Text(
                  '${item.foodName} (${item.quantity} x ₹${item.foodPrice}) - Extras: ${item.extrasName} (₹${item.extrasPrice}) - Subtotal: ₹${item.subTotal}',
                  style: pw.TextStyle(font: ttf, fontSize: 16),
                )),
            pw.SizedBox(height: 16),
            pw.Text('Total Amount: ₹${order.totalAmount}',
                style: pw.TextStyle(font: ttf, fontSize: 18)),
          ],
        );
      },
    ),
  );

  return pdf.save();
}

Future<void> printDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  print('Running on ${androidInfo.model}');
}

Future<List<OrderItem>> fetchOrderItems(int tableId) async {
  final response =
      await http.get(Uri.parse('http://10.0.2.2:3000/cart/$tableId'));

  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    List<OrderItem> orderItems =
        body.map((dynamic item) => OrderItem.fromJson(item)).toList();
    return orderItems;
  } else {
    throw Exception('Failed to load order items');
  }
}
