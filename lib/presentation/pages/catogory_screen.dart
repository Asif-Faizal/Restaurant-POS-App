import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ballast_machn_test/presentation/widgets/menu_button.dart';

import '../../data/providers/category_api_provider.dart';
import '../../data/providers/menu_api_providers.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/menu_repository.dart';
import '../../domain/usecases/fetch_categories.dart';
import '../blocs/category/category_bloc.dart';
import '../blocs/category/category_event.dart';
import '../blocs/category/category_state.dart';
import '../widgets/category_tile.dart';

class CategoryPage extends StatelessWidget {
  final String table;

  const CategoryPage({super.key, required this.table});

  @override
  Widget build(BuildContext context) {
    final MenuRepository menuRepository = MenuRepository(
      apiProvider: MenuApiProvider(
        baseUrl: 'http://10.0.2.2:3000',
      ),
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: const Text('Confirm exit'),
                  content: Text(
                      'Are you sure you want to exit the order from $table?'),
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
                      },
                      child: const Text('Exit'),
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 228, 147),
        title: Text(
          'Table $table',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          ShoppingCartButton(
            table: table,
            menuRepository: menuRepository,
          ),
          const SizedBox(
            width: 10,
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Foods...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Container(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        padding: const EdgeInsets.all(5),
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(Icons.forward, size: 20),
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => CategoryBloc(
            fetchCategories: FetchCategories(
                repository:
                    CategoryRepository(apiProvider: CategoryApiProvider())))
          ..add(FetchCategoriesEvent()),
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CategoryLoaded) {
              return GridView.builder(
                itemCount: state.categories.length,
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                itemBuilder: (context, index) {
                  final item = state.categories[index];
                  return CategoryTile(item: item, table: table);
                },
              );
            } else if (state is CategoryError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('No categories found'));
            }
          },
        ),
      ),
    );
  }
}
