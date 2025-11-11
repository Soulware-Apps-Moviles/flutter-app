import 'package:flutter/material.dart';
import 'package:tcompro_customer/features/home/presentation/pages/home_page.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/pages/shopping_lists_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ShoppingListsPage(),
    const Center(child: Text('Profile page placeholder')),
    const Center(child: Text('Shopping bag placeholder')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFF5F5F5),
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        selectedItemColor: const Color(0xFFDD6529),
        unselectedItemColor: const Color(0xFF1F1F1F),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Shopping lists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'You',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Bag',
          ),
        ],
      ),
    );
  }
}
