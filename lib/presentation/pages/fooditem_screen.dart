import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/food_repository.dart';
import '../../domain/usecases/fetch_food.dart';
import '../blocs/food/food_bloc.dart';
import '../blocs/food/food_event.dart';
import '../blocs/food/food_state.dart';
import 'fooddetails_screen.dart';

class FoodItemScreen extends StatelessWidget {
  final String category;
  final int table;
  final String customerName;
  final String customerNum;

  const FoodItemScreen(
      {Key? key,
      required this.category,
      required this.table,
      required this.customerName,
      required this.customerNum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/bb.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            foregroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            backgroundColor: Colors.transparent,
            title: Text(
              '$category',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: BlocProvider(
              create: (context) => FoodBloc(FetchFoodUseCase(FoodRepository()))
                ..add(FetchFood(category)),
              child: BlocBuilder<FoodBloc, FoodState>(
                builder: (context, state) {
                  if (state is FoodLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is FoodLoaded) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: state.foods.length,
                      itemBuilder: (context, index) {
                        final food = state.foods[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FoodDetailsPage(
                                  food: food,
                                  customerName: customerName,
                                  customerNum: customerNum,
                                  table: table,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(5)),
                                    child: Image.network(
                                      food.image,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 5),
                                  child: Text(
                                    food.pdtName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 5),
                                  child: Text(
                                    '\$${food.saleAmt}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is FoodError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Center(child: Text('Select a category'));
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
