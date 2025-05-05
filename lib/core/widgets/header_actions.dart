import 'package:flutrace_web/core/widgets/update_user_popup.dart';
import 'package:flutrace_web/features/auth/presentation/cubits/user_cubit.dart';
import 'package:flutrace_web/features/theme/presentation/cubit/lang_cubit.dart';
import 'package:flutrace_web/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HeaderActions extends StatefulWidget {
  const HeaderActions({super.key});

  @override
  State<HeaderActions> createState() => _HeaderActionsState();
}

class _HeaderActionsState extends State<HeaderActions> {
  OverlayEntry? _overlayEntry;
  bool _isPopupOpen = false;

  void _togglePopup() {
    if (_isPopupOpen) {
      _removePopup();
    } else {
      _showPopup();
    }
  }

  void _showPopup() {
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => const Positioned(
        top: kToolbarHeight + 40,
        right: -20,
        child: Material(
          color: Colors.transparent,
          child: UserProfilePopup(),
        ),
      ),
    );
    overlay.insert(_overlayEntry!);
    setState(() => _isPopupOpen = true);
  }

  void _removePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isPopupOpen = false);
  }

  @override
  void dispose() {
    _removePopup();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final userState = context.watch<UserCubit>().state;
    final languageState = context.watch<LanguageCubit>().state;

    return Row(
      children: [
        IconButton(
          color: Theme.of(context).colorScheme.secondary,
          icon: languageState.languageCode == 'uk'
              ? Image.asset(
            'assets/icons/flag-ua.png',
            height: 24,
          )
              : Image.asset(
            'assets/icons/flag-eng.png',
            height: 24,
          ),
          onPressed: () {
            context.read<LanguageCubit>().toggleLanguage(context);
          },
        ),
        const SizedBox(width: 16),
        IconButton(
          color: Theme.of(context).colorScheme.secondary,
          icon: themeState == AppTheme.light
              ? SvgPicture.asset(
            'assets/icons/moon.svg',
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.secondary,
              BlendMode.srcIn,
            ),
          )
              : SvgPicture.asset(
            'assets/icons/sun.svg',
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.secondary,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {
            context.read<ThemeCubit>().toggleTheme();
          },
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: SvgPicture.asset(
            'assets/icons/log-out.svg',
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.secondary,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {
            context.read<UserCubit>().signOut();
            context.go('/');
          },
        ),
        const SizedBox(width: 30),
        GestureDetector(
          onTap: _togglePopup,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: userState is UserLoaded
                ? Text(
              userState.user.email.substring(0, 1).toUpperCase(),
              style: const TextStyle(color: Colors.white),
            )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
