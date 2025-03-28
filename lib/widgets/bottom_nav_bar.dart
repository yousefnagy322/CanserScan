import 'package:canser_scan/doctors_page.dart';
import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/home_page_v2.dart';
import 'package:canser_scan/info_pages/information_page.dart';
import 'package:canser_scan/navigation_provider.dart';
import 'package:canser_scan/test/take_test_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavBarItem {
  final String icon;
  final String label;
  final String? route;
  final bool isActive;

  const NavBarItem({
    required this.icon,
    required this.label,
    this.route,
    this.isActive = false,
  });
}

class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({super.key});

  static const List<NavBarItem> _navItems = [
    NavBarItem(
      icon: 'assets/photos/navbartest.png',
      label: 'Test',
      route: TakeTestPage.id,
    ),
    NavBarItem(
      icon: 'assets/photos/navbarinfo.png',
      label: 'Information',
      route: InformationPage.id,
    ),
    NavBarItem(
      icon: 'assets/photos/navbarhome.png',
      label: 'Home',
      route: HomePageV2.id,
      isActive: true,
    ),
    NavBarItem(icon: 'assets/photos/navbaraboutus.png', label: 'About Us'),
    NavBarItem(
      icon: 'assets/photos/navbardoctor.png',
      label: 'Doctors',
      route: DoctorsPage.id,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final navBarHeight = screenWidth * 0.15;
    final floatingIconSize = screenWidth * 0.12;
    final iconSize = screenWidth * 0.08;

    return Consumer<NavigationProvider>(
      builder: (context, navProvider, child) {
        final totalTabs = _navItems.length;
        final tabWidth = screenWidth / totalTabs;
        final activeTabPosition =
            tabWidth * navProvider.selectedIndex +
            (tabWidth - floatingIconSize) / 2;

        return Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: navBarHeight,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xffD9D9D9),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _navItems.length,
                  (index) => NavBarElement(
                    item: _navItems[index],
                    isSelected: navProvider.selectedIndex == index,
                    iconSize: iconSize,
                    onTap: () {
                      navProvider.setSelectedIndex(index);
                      final route = _navItems[index].route;
                      if (route != null) {
                        Navigator.pushNamed(context, route);
                      }
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              left: activeTabPosition,
              top: -(floatingIconSize / 2),
              child: Container(
                height: floatingIconSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff17D3E5),
                ),
                child: Padding(
                  padding: EdgeInsets.all(floatingIconSize * 0.15),
                  child: Image.asset(
                    _navItems[navProvider.selectedIndex].icon,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class NavBarElement extends StatelessWidget {
  const NavBarElement({
    super.key,
    required this.item,
    required this.isSelected,
    required this.iconSize,
    required this.onTap,
  });

  final NavBarItem item;
  final bool isSelected;
  final double iconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: InkWell(
        onTap: onTap,
        splashColor: kPrimaryColor.withOpacity(0.3),
        child: Semantics(
          label: item.label,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isSelected
                  ? SizedBox(height: iconSize, width: iconSize)
                  : AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Image.asset(
                      item.icon,
                      height: iconSize,
                      color: kPrimaryColor,
                    ),
                  ),
              FittedBox(
                child: Text(
                  item.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: iconSize * 0.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
