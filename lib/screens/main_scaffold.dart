import 'package:flutter/material.dart';
import 'package:app_nutriverif/screens/home_page.dart';
import 'package:app_nutriverif/screens/barcode_scanner_page.dart';
import 'package:app_nutriverif/screens/products_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ProductSearchPage(),
    BarcodeScannerPage(),
  ];

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 4,
              color: const Color.fromRGBO(158, 158, 158, 0.25),
            ),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          selectedItemColor: const Color(0xFF00BD7E),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(
                  top: 8.0,
                ), // aide à centrer verticalement
                child: Icon(Icons.home_outlined, size: 30),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(Icons.manage_search_rounded, size: 30),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(Icons.qr_code_rounded, size: 30),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
