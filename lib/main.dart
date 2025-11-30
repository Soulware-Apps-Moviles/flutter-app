import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcompro_customer/core/constants/api_constants.dart';
import 'package:tcompro_customer/core/data/cubits/shopping_bag_cubit.dart';
import 'package:tcompro_customer/core/enums/app_routes.dart';
import 'package:tcompro_customer/core/constants/supabase_constants.dart';
import 'package:tcompro_customer/core/data/cubits/profile_cubit.dart';
import 'package:tcompro_customer/core/data/request_interceptor.dart';
import 'package:tcompro_customer/core/data/storage/supabase_secure_storage.dart';
import 'package:tcompro_customer/core/data/cubits/token_cubit.dart';
import 'package:tcompro_customer/core/ui/theme.dart';
import 'package:tcompro_customer/features/auth/data/auth_repository_impl.dart';
import 'package:tcompro_customer/features/auth/domain/auth_repository.dart';
import 'package:tcompro_customer/features/auth/presentation/blocs/login_bloc.dart';
import 'package:tcompro_customer/features/auth/presentation/blocs/register_bloc.dart';
import 'package:tcompro_customer/features/auth/presentation/pages/login_page.dart';
import 'package:tcompro_customer/features/auth/presentation/pages/register_page.dart';
import 'package:tcompro_customer/features/shopping-bag/presentation/bloc/shopping_bag_bloc.dart';
import 'package:tcompro_customer/shared/data/local/shopping_bag_dao.dart';
import 'package:tcompro_customer/shared/data/remote/favorite_service.dart';
import 'package:tcompro_customer/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:tcompro_customer/shared/data/product_repository_impl.dart';
import 'package:tcompro_customer/shared/data/remote/product_service.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/home_bloc.dart';
import 'package:tcompro_customer/features/main/main_page.dart';
import 'package:tcompro_customer/features/shopping-lists/data/shopping_list_service.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_lists_bloc.dart';
import 'package:tcompro_customer/features/auth/data/auth_service.dart';
import 'package:tcompro_customer/shared/data/remote/profile_service.dart';
import 'package:tcompro_customer/shared/domain/product_repository.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConstants.supabaseUrl,
    anonKey: SupabaseConstants.supabasePublisheableKey,
    authOptions: FlutterAuthClientOptions(
      localStorage: SupabaseSecureStorage(),
    ),
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final MaterialTheme theme = MaterialTheme(TextTheme());
    
    final tokenCubit = TokenCubit();
    final supabaseClient = Supabase.instance.client;
    
    final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
    dio.interceptors.add(RequestInterceptor(tokenCubit));
    
    final authService = AuthService(supabaseClient);
    final profileService = ProfileService(dio: dio);
    final productService = ProductService(dio: dio);
    final favoriteService = FavoriteService(dio: dio);
    final shoppingListService = ShoppingListService(dio: dio);

    final ShoppingBagDao shoppingBagDao = ShoppingBagDao();
    
    final authRepository = AuthRepositoryImpl(
      authService: authService,
      tokenCubit: tokenCubit,
      profileService: profileService
    );

    final productRepository = ProductRepositoryImpl(
      productService: productService,
      favoriteService: favoriteService,
      shoppingBagDao: shoppingBagDao
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => authRepository),
        RepositoryProvider<ProfileService>(create: (_) => profileService),
        RepositoryProvider<ProductRepository>(create: (_) => productRepository),
        RepositoryProvider<Dio>(create: (_) => dio),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TokenCubit>(
            create: (_) => tokenCubit,
          ),
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(
              context.read<AuthRepository>(), 
              profileService,
            ),
          ),
          BlocProvider(create: (context) => ShoppingBagCubit(
            productRepository: productRepository
            ),
          ),
          BlocProvider(
            create: (context) => LoginBloc(authRepository: authRepository),
          ),
          BlocProvider(
            create: (context) => RegisterBloc(authRepository: authRepository),
          ),
          BlocProvider(
            create: (context) => HomeBloc(repository: productRepository)
          ),
          BlocProvider(
            create: (context) => FavoritesBloc(service: favoriteService)
          ),
          BlocProvider(
            create: (context) => ShoppingListsBloc(service: shoppingListService)
          ),
          BlocProvider(
            create: (context) => ShoppingBagBloc(
              productRepository: productRepository, 
              profileCubit: context.read<ProfileCubit>()
            )
          )
        ],
        child: MaterialApp(
          title: "T'Compro Clientes",
          debugShowCheckedModeBanner: false,
          theme: theme.light(),
          darkTheme: theme.dark(),
          routes: {
            AppRoutes.registerRoute: (context) => const RegisterPage(),
            AppRoutes.mainRoute: (context) => const MainApp()
          },
          home: BlocBuilder<TokenCubit, String?>(
            builder: (context, token) {
              if (token == null) {
                return const LoginPage();
              } else {
                return const MainPage();
              }
            },
          ),
        ),
      ),
    );
  }
}