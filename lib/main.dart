import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tcompro_customer/core/theme.dart';
import 'package:tcompro_customer/features/favorites/data/favorite_service.dart';
import 'package:tcompro_customer/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:tcompro_customer/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:tcompro_customer/features/home/data/product_service.dart';
import 'package:tcompro_customer/features/home/domain/category.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/products_bloc.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/products_event.dart';
import 'package:tcompro_customer/features/main/main_page.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final MaterialTheme theme = MaterialTheme(TextTheme());
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => 
          ProductsBloc(service: ProductService())
            ..add(LoadProductsEvent(category: CategoryType.ALL)),
            
        ),
        BlocProvider(
          create: (context) => 
          FavoritesBloc(service: FavoriteService(), customerId: 10001)
            ..add(LoadFavoritesEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.light(),
        darkTheme: theme.dark(),
        home: Scaffold(
          body: MainPage()
        )
      ),
    );
  }
}
