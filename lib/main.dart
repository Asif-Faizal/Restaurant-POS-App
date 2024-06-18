import 'package:ballast_machn_test/presentation/blocs/tax_type_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/providers/category_api_provider.dart';
import 'data/repositories/category_repository.dart';
import 'domain/usecases/fetch_categories.dart';
import 'presentation/blocs/category/category_bloc.dart';
import 'presentation/blocs/category/category_event.dart';
import 'presentation/blocs/auth_bloc.dart';
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

  runApp(MyApp(
    authenticateUser: authenticateUser,
    fetchCategories: fetchCategories,
  ));
}

class MyApp extends StatelessWidget {
  final AuthenticateUser authenticateUser;
  final FetchCategories fetchCategories;

  const MyApp({
    super.key,
    required this.authenticateUser,
    required this.fetchCategories,
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
        BlocProvider(create: (_) => TaxTypeBloc())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ballast Hotel',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const PasscodeScreen(),
      ),
    );
  }
}
