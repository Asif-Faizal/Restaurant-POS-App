import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/providers/category_api_provider.dart';
import 'data/providers/extras_api_provider.dart';
import 'data/providers/food_api_provider.dart';
import 'data/providers/menu_api_providers.dart';
import 'data/repositories/cart_repository.dart';
import 'data/repositories/category_repository.dart';
import 'data/repositories/extras_repository.dart';
import 'data/repositories/food_repository.dart';
import 'data/repositories/menu_repository.dart';
import 'domain/usecases/fetch_categories.dart';
import 'domain/usecases/fetch_foods_from_category.dart';
import 'domain/usecases/fetch_menu_items.dart';
import 'domain/usecases/delete_menu_item.dart';
import 'presentation/blocs/category/category_bloc.dart';
import 'presentation/blocs/category/category_event.dart';
import 'presentation/blocs/auth_bloc.dart';
import 'presentation/blocs/extras/extra_bloc.dart';
import 'presentation/blocs/fetch-menu/menu_bloc.dart';
import 'presentation/blocs/food/food_bloc.dart';
import 'presentation/blocs/add-to-menu/cart_bloc.dart';
import 'presentation/pages/passcode_screen.dart';
import 'data/repositories/auth_repository.dart';
import 'domain/usecases/authenticate_user.dart';

void main() {
  final authRepository = AuthRepository();
  final authenticateUser = AuthenticateUser(authRepository);

  final categoryApiProvider = CategoryApiProvider();
  final categoryRepository =
      CategoryRepository(apiProvider: categoryApiProvider);
  final fetchCategories = FetchCategories(repository: categoryRepository);

  final foodApiProvider = FoodApiProvider();
  final foodRepository = FoodRepository(apiProvider: foodApiProvider);
  final fetchFoodsByCategory = FetchFoodsByCategory(foodRepository);

  final extraApiProvider = ExtraApiProvider();
  final extraRepository = ExtraRepository(apiProvider: extraApiProvider);

  final menuApiProvider = MenuApiProvider(baseUrl: 'http://10.0.2.2:3000');
  final menuRepository = MenuRepository(apiProvider: menuApiProvider);
  final fetchMenuItems = FetchMenuItems(repository: menuRepository);
  final deleteMenuItem = DeleteMenuItem(repository: menuRepository);

  runApp(MyApp(
    authenticateUser: authenticateUser,
    fetchCategories: fetchCategories,
    fetchFoodsByCategory: fetchFoodsByCategory,
    extraRepository: extraRepository,
    fetchMenuItems: fetchMenuItems,
    deleteMenuItem: deleteMenuItem,
  ));
}

class MyApp extends StatelessWidget {
  final AuthenticateUser authenticateUser;
  final FetchCategories fetchCategories;
  final FetchFoodsByCategory fetchFoodsByCategory;
  final ExtraRepository extraRepository;
  final FetchMenuItems fetchMenuItems;
  final DeleteMenuItem deleteMenuItem;

  const MyApp({
    super.key,
    required this.authenticateUser,
    required this.fetchCategories,
    required this.fetchFoodsByCategory,
    required this.extraRepository,
    required this.fetchMenuItems,
    required this.deleteMenuItem,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(authenticateUser),
        ),
        BlocProvider(
          create: (_) => CategoryBloc(fetchCategories: fetchCategories)
            ..add(FetchCategoriesEvent()),
        ),
        BlocProvider(
          create: (_) => FoodBloc(fetchFoodsByCategory: fetchFoodsByCategory),
        ),
        BlocProvider(
          create: (_) => ExtraBloc(extraRepository: extraRepository),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(
              cartRepository: CartRepository(baseUrl: 'http://10.0.2.2:3000')),
        ),
        BlocProvider<MenuBloc>(
          create: (context) => MenuBloc(
              fetchMenuItems: fetchMenuItems, deleteMenuItem: deleteMenuItem),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ballast Hotel',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const PasscodeScreen(),
      ),
    );
  }
}
