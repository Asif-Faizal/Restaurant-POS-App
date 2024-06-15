import 'package:ballast_machn_test/presentation/pages/fooddetails_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/providers/menu_api_providers.dart';
import '../../data/repositories/menu_repository.dart';
import '../blocs/food/food_bloc.dart';
import '../blocs/food/food_event.dart';
import '../blocs/food/food_state.dart';
import '../widgets/food_tile.dart';
import '../widgets/menu_button.dart';

class FooditemScreen extends StatelessWidget {
  final String table;
  final String category;
  final int categoryId;
  final int itemCount;

  const FooditemScreen({
    super.key,
    required this.table,
    required this.itemCount,
    required this.category,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    final foodBloc = BlocProvider.of<FoodBloc>(context);
    foodBloc.add(FetchFoodsEvent(categoryId));
    final MenuRepository menuRepository = MenuRepository(
      apiProvider: MenuApiProvider(
        baseUrl: 'http://10.0.2.2:3000',
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 228, 147),
        title: Text(
          'Table $table - $category',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          ShoppingCartButton(
            table: table,
            menuRepository: menuRepository,
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: BlocBuilder<FoodBloc, FoodState>(
        builder: (context, state) {
          if (state is FoodLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FoodLoaded) {
            final foods = state.foods;
            return ListView.builder(
              padding: const EdgeInsets.all(15),
              physics: const BouncingScrollPhysics(),
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                return LayoutBuilder(builder: (context, constraints) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(table: table, food: food)));
                      },
                      child: FoodTile(food: food));
                });
              },
            );
          } else if (state is FoodError) {
            return const Center(child: Text('Failed to load foods'));
          } else {
            return const Center(child: Text('No foods available'));
          }
        },
      ),
    );
  }
}
