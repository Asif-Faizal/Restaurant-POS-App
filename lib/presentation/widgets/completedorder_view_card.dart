import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CompletedOrderViewCard extends StatefulWidget {
  const CompletedOrderViewCard({
    Key? key,
    required this.imageUrls,
  }) : super(key: key);

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
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => OrderDetails(
        //       table: widget.order.tableId.toString(),
        //       customerName: widget.order.customerName,
        //       customerNumber: widget.order.customerNumber,
        //     ),
        //   ),
        // );
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
                          'Table {widget.order.tableId}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'widget.order.customerName',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '₹ {widget.order.totalAmount}',
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
                          '  widget.order.orderTime',
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
                          onPressed: () async {},
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
