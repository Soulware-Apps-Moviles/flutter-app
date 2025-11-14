import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcompro_customer/core/constants/api_constants.dart';
import 'package:tcompro_customer/core/ui/theme.dart';
import 'package:tcompro_customer/features/favorites/data/favorite_service.dart';
import 'package:tcompro_customer/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:tcompro_customer/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:tcompro_customer/features/home/data/product_service.dart';
import 'package:tcompro_customer/features/home/domain/category.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/products_bloc.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/products_event.dart';
import 'package:tcompro_customer/features/main/main_page.dart';
import 'package:tcompro_customer/features/shopping-lists/data/shopping_list_service.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_lists_bloc.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_lists_event.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: ApiConstants.supabaseUrl,
    anonKey: ApiConstants.supabasePublisheableKey,
  );

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
          FavoritesBloc(service: FavoriteService(), customerId: int.tryParse(dotenv.env['CUSTOMER_ID'] ?? '0') ?? 0) //TO TEST
            ..add(LoadFavoritesEvent()),
        ),
        BlocProvider(
          create: (context) => 
          ShoppingListsBloc(service: ShoppingListService(), customerId: int.tryParse(dotenv.env['CUSTOMER_ID'] ?? '0') ?? 0) //TO TEST
            ..add(LoadShoppingListsEvent()),
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
