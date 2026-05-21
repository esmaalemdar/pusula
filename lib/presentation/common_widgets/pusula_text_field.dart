import 'package:flutter/material.dart';
import 'package:pusula/core/theme/app_colors.dart';

class PusulaTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final String? Function(String?)? validator;
  final VoidCallback? onEditingComplete;
  final TextCapitalization textCapitalization;

  const PusulaTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    required this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.validator,
    this.onEditingComplete,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<PusulaTextField> createState() => _PusulaTextFieldState();
}

class _PusulaTextFieldState extends State<PusulaTextField> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() =>
      setState(() => _isFocused = widget.focusNode.hasFocus);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.14),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ]
            : [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        onEditingComplete: widget.onEditingComplete,
        validator: widget.validator,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 15,
          color:
              Theme.of(context).textTheme.bodyMedium?.color ??
              AppColors.text900,
          fontWeight: FontWeight.w400,
        ),
        cursorColor: AppColors.accent,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          filled: true,
          fillColor: _isFocused
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).cardColor,
          floatingLabelStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.accent,
          ),
          labelStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            color: _isFocused
                ? AppColors.accent
                : (Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color?.withOpacity(0.4) ??
                      AppColors.text400),
          ),
          hintStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            color:
                Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withOpacity(0.4) ??
                AppColors.text400,
          ),
          prefixIcon: Icon(
            widget.prefixIcon,
            size: 19,
            color: _isFocused
                ? AppColors.accent
                : (Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color?.withOpacity(0.4) ??
                      AppColors.text400),
          ),
          suffixIcon: widget.suffixIcon != null
              ? GestureDetector(
                  onTap: widget.onSuffixTap,
                  child: Icon(
                    widget.suffixIcon,
                    size: 19,
                    color: _isFocused
                        ? AppColors.accent
                        : (Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color?.withOpacity(0.4) ??
                              AppColors.text400),
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.borderFocus,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.error, width: 1.2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.error, width: 1.5),
          ),
          errorStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 11.5,
            color: AppColors.error,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
          errorMaxLines: 2,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}



