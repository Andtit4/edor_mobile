import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../router/app_routes.dart';
import '../../domain/entities/user.dart';

class AnimatedBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final User? user;

  const AnimatedBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.user,
  });

  @override
  State<AnimatedBottomNav> createState() => _AnimatedBottomNavState();
}

class _AnimatedBottomNavState extends State<AnimatedBottomNav>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _getNavItems().length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );
    _animations = _controllers
        .map((controller) => Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut)))
        .toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<NavItem> _getNavItems() {
    if (widget.user?.role == UserRole.prestataire) {
      return [
        NavItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: 'Accueil',
          route: AppRoutes.home,
        ),
        NavItem(
          icon: Icons.request_quote_outlined,
          activeIcon: Icons.request_quote,
          label: 'Demandes',
          route: AppRoutes.serviceRequests,
        ),
        NavItem(
          icon: Icons.message_outlined,
          activeIcon: Icons.message,
          label: 'Messages',
          route: AppRoutes.messages,
        ),
        NavItem(
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          label: 'Profil',
          route: AppRoutes.profile,
        ),
      ];
    } else {
      return [
        NavItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: 'Accueil',
          route: AppRoutes.home,
        ),
        NavItem(
          icon: Icons.search_outlined,
          activeIcon: Icons.search,
          label: 'Rechercher',
          route: AppRoutes.serviceOffers,
        ),
        NavItem(
          icon: Icons.message_outlined,
          activeIcon: Icons.message,
          label: 'Messages',
          route: AppRoutes.messages,
        ),
        NavItem(
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          label: 'Profil',
          route: AppRoutes.profile,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final navItems = _getNavItems();
    
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final isActive = widget.currentIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                widget.onTap(index);
                _animateItem(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF8B5CF6).withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isActive ? navItems[index].activeIcon : navItems[index].icon,
                        color: isActive ? const Color(0xFF8B5CF6) : Colors.grey[600],
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive ? const Color(0xFF8B5CF6) : Colors.grey[600],
                      ),
                      child: Text(navItems[index].label),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void _animateItem(int index) {
    for (int i = 0; i < _controllers.length; i++) {
      if (i == index) {
        _controllers[i].forward();
      } else {
        _controllers[i].reverse();
      }
    }
  }
}

class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}