import 'package:easy_localization/easy_localization.dart';
import 'package:flutrace_web/core/styles/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilterElement extends StatefulWidget {
  final String placeholder;
  final List<String> items;
  final ValueChanged<String?>? onChanged;

  const FilterElement({
    super.key,
    required this.placeholder,
    required this.items,
    this.onChanged,
  });

  @override
  State<FilterElement> createState() => _FilterElementState();
}

class _FilterElementState extends State<FilterElement> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  String? selected;

  void _toggleDropdown() {
    if (_isOpen) {
      _removeDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isOpen = false);
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 4,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: widget.items.map((item) {
                return InkWell(
                  onTap: () {
                    setState(() => selected = item);
                    widget.onChanged?.call(item);
                    _removeDropdown();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    child: Text(
                      item,
                      style: AppTextStyles.caption(context),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _removeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selected ?? widget.placeholder.tr(),
                style: AppTextStyles.caption(context),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 2),
              SvgPicture.asset(
                'assets/icons/chevron-right.svg',
                height: 16,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.secondary,
                  BlendMode.srcIn,
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
