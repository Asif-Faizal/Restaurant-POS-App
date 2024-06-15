import 'package:ballast_machn_test/presentation/pages/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/fetch-menu/menu_bloc.dart';
import '../blocs/fetch-menu/menu_event.dart';

class MenuCard extends StatefulWidget {
  final dynamic item;

  const MenuCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Card(
            color: Color.fromARGB(255, 255, 240, 196),
            elevation: 5,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        widget.item['food_name'],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            widget.item['food_image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Card(
                          color: const Color.fromARGB(255, 255, 247, 224),
                          child: SizedBox(
                            height: 100,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('${widget.item['food_price']} x'),
                                      Text('${widget.item['quantity']}'),
                                      const Spacer(),
                                      Text(
                                          '${widget.item['food_price'] * widget.item['quantity']}')
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${widget.item['extras_name']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              ' - ${widget.item['extras_price']} x')
                                        ],
                                      ),
                                      Text(' ${widget.item['quantity']}'),
                                      const Spacer(),
                                      Text(
                                          '${widget.item['extras_price'] * widget.item['quantity']}')
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Sub-total',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        '\₹${widget.item['sub_total']}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              iconSize: 16,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: const Text('Confirm deletion'),
                      content: Text(
                          'Are you sure you want to delete ${widget.item['quantity']} ${widget.item['food_name']} with ${widget.item['extras_name']}?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            BlocProvider.of<MenuBloc>(context).add(
                              DeleteMenuItemEvent(
                                widget.item['table_id'],
                                widget.item['food_id'],
                                widget.item['extras_name'],
                              ),
                            );
                            BlocProvider.of<MenuBloc>(context)
                                .add(RefreshMenuEvent(widget.item['table_id']));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  '${widget.item['quantity']} ${widget.item['food_name']} with ${widget.item['extras_name']} deleted from menu',
                                ),
                                showCloseIcon: true,
                              ),
                            );
                            print(widget.item['table_id']);
                            BlocProvider.of<MenuBloc>(context).add(
                                FetchMenuItemsEvent(widget.item['table_id']));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MenuPage(
                                        table: widget.item['table_id']
                                            .toString())));
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
