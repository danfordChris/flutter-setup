import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:pinput/pinput.dart';
import 'package:solar_icon_pack/solar_linear_icons.dart';
import 'package:solomon/services/strings.dart';
import 'package:solomon/shared/widgets/decorated_input_border.dart';
import 'package:solomon/shared/widgets/helper_widgets.dart';

enum InputFieldVariant { standard, glass, phone, pin, dropdown }

class InputField<T> extends StatefulWidget {
  const InputField({
    super.key,
    this.controller,
    this.isEnabled = true,
    this.obscureText,
    this.labelText,
    this.labelStyle,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.prefix,
    this.prefixText,
    this.suffixIcon,
    this.suffix,
    this.borderColor,
    this.validator,
    this.keyboardType,
    this.textCapitalization,
    this.onTap,
    this.isReadOnly = false,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.onChanged,
    this.onSubmitted,
    this.onCompleted,
    this.autofocus = false,
    this.focusNode,
    this.variant = InputFieldVariant.standard,
    this.borderRadius,
    this.dense,
    this.fillColor,
    this.inputFormatters,
    this.maxLength,
  }) : pinLength = null,
       initialPhone = null,
       pinBoxWidth = null,
       pinBoxHeight = null,
       initialValue = null,
       itemLabel = null,
       items = null;

  const InputField.dropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.labelText,
    this.labelStyle,

    this.isEnabled = true,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.borderColor,
    this.validator,
    this.onTap,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.borderRadius,
    this.fillColor,
    this.initialValue,
    this.itemLabel,
  }) : controller = null,
       prefix = null,
       prefixText = null,
       initialPhone = null,
       suffix = null,
       keyboardType = null,
       textCapitalization = null,
       isReadOnly = false,
       onSubmitted = null,
       onCompleted = null,
       autofocus = false,
       focusNode = null,
       variant = InputFieldVariant.dropdown,
       pinLength = null,
       pinBoxWidth = null,
       pinBoxHeight = null,
       dense = null,
       maxLength = null,
       inputFormatters = null,
       obscureText = null;

  const InputField.glass({
    super.key,
    this.controller,
    this.obscureText,
    this.labelText,
    this.labelStyle,

    this.isEnabled = true,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.prefix,
    this.prefixText,
    this.suffixIcon,
    this.suffix,
    this.borderColor,
    this.validator,
    this.keyboardType,
    this.textCapitalization,
    this.onTap,
    this.isReadOnly = false,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.onChanged,
    this.onSubmitted,
    this.onCompleted,
    this.autofocus = false,
    this.focusNode,
    this.variant = InputFieldVariant.glass,
    this.borderRadius,
    this.dense,
    this.fillColor,
    this.inputFormatters,
    this.maxLength,
  }) : pinLength = null,
       pinBoxWidth = null,
       pinBoxHeight = null,
       initialValue = null,
       itemLabel = null,
       initialPhone = null,
       items = null;

  const InputField.phone({
    super.key,
    this.controller,
    this.labelText,
    this.labelStyle,

    this.isEnabled = true,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.prefix,
    this.prefixText,
    this.suffixIcon,
    this.suffix,
    this.borderColor,
    this.validator,
    this.onTap,
    this.isReadOnly = false,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.onChanged,
    this.autofocus = false,
    this.onCompleted,
    this.onSubmitted,
    this.focusNode,
    this.borderRadius,
    this.inputFormatters,
    this.initialPhone,
  }) : variant = InputFieldVariant.phone,
       pinLength = null,
       pinBoxWidth = null,
       pinBoxHeight = null,
       obscureText = false,
       dense = null,
       fillColor = null,
       maxLength = null,
       items = null,
       itemLabel = null,
       initialValue = null,
       keyboardType = TextInputType.phone,
       textCapitalization = TextCapitalization.none;

  const InputField.pin({
    super.key,
    this.controller,
    this.borderColor,
    this.validator,
    this.isReadOnly = false,
    this.isEnabled = true,
    this.border,
    this.onChanged,
    this.labelStyle,

    this.onSubmitted,
    this.onCompleted,
    this.autofocus = false,
    this.obscureText = true,
    this.onTap,
    this.focusNode,
    this.helperText,
    this.pinLength = 4,
    this.pinBoxWidth = 58,
    this.pinBoxHeight = 58,
    this.borderRadius,
    this.inputFormatters,
  }) : variant = InputFieldVariant.pin,
       suffix = null,
       prefix = null,
       hintText = null,
       labelText = null,
       prefixIcon = null,
       prefixText = null,
       suffixIcon = null,
       focusedBorder = null,
       enabledBorder = null,
       maxLength = null,
       dense = null,
       fillColor = null,
       items = null,
       itemLabel = null,
       initialValue = null,
       initialPhone = null,
       keyboardType = TextInputType.number,
       textCapitalization = TextCapitalization.none;

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final bool? obscureText;
  final bool isEnabled;
  final String? labelText;
  final TextStyle? labelStyle;
  final String? hintText;
  final String? helperText;
  final Widget? prefixIcon;
  final Widget? prefix;
  final String? prefixText;
  final Widget? suffixIcon;
  final Widget? suffix;
  final bool isReadOnly;
  final Color? borderColor;
  final String? Function(String? value)? validator;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputFieldVariant? variant;
  final Function(T?)? onChanged;
  final Function(String)? onCompleted;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final bool autofocus;
  final FocusNode? focusNode;
  final int? pinLength;
  final double? pinBoxWidth;
  final double? pinBoxHeight;
  final BorderRadius? borderRadius;
  final bool? dense;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final List<T>? items;
  final PhoneNumber? initialPhone;
  final T? initialValue;
  final String Function(T)? itemLabel;

  @override
  State<InputField<T>> createState() => _InputFieldState<T>();
}

class _InputFieldState<T> extends State<InputField<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4.0,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) Text(widget.labelText!, style: widget.labelStyle ?? context.bodySmall),
        _buildField(context, widget.variant!),
        if (widget.helperText != null) Text(widget.helperText!, style: context.labelSmall.light),
      ],
    );
  }

  Widget _buildField(BuildContext context, InputFieldVariant variant) {
    return switch (variant) {
      InputFieldVariant.pin => _buildPINField(context),
      InputFieldVariant.phone => _buildPhoneField(context),
      InputFieldVariant.dropdown => _buildDropdownField(context),
      _ => _buildInputField(context),
    };
  }

  Widget _buildInputField(BuildContext context) {
    return AbsorbPointer(
      absorbing: !widget.isEnabled,
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText ?? false,
        autofocus: widget.autofocus,
        textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
        readOnly: widget.isReadOnly,
        style: _textStyle,
        cursorColor: _cursorColor,
        decoration: _decoration,
        validator: widget.validator,
        maxLength: widget.maxLength,
        inputFormatters: widget.inputFormatters,
        onChanged: (value) {
          widget.onChanged?.call(value as T?);
        },
        onEditingComplete: () {
          if (widget.onCompleted != null) {
            widget.onCompleted!(widget.controller?.text ?? '');
          }
        },
        onFieldSubmitted: (value) {
          if (widget.onSubmitted != null) {
            widget.onSubmitted!(value);
          }
          FocusScope.of(context).unfocus();
        },
        onTap: widget.onTap,
      ),
    );
  }

  T? _selectedDropdownValue;

  @override
  void initState() {
    super.initState();
    _selectedDropdownValue = widget.initialValue;
  }

  Widget _buildDropdownField(BuildContext context) {
    final bool useSearch = (widget.items?.length ?? 0) > 10;

    if (!useSearch) {
      return AbsorbPointer(
        absorbing: !widget.isEnabled,
        child: DropdownButtonFormField<T>(
          isExpanded: true,
          items: _items,
          onTap: widget.onTap,
          initialValue: widget.initialValue,
          decoration: _decoration,
          hint: Text(widget.hintText ?? Strings.instance.commonSelect, style: _hintStyle),
          onChanged: (value) => widget.onChanged?.call(value),
          validator: widget.validator == null ? null : (T? value) => widget.validator!(value?.toString()),
          borderRadius: widget.borderRadius ?? BorderRadius.circular(16.0),
          icon: widget.suffixIcon ?? Icon(SolarLinearIcons.altArrowDown, color: context.colorScheme.primary),
        ),
      );
    }

    // Searchable dropdown for > 10 items
    return AbsorbPointer(
      absorbing: !widget.isEnabled,
      child: FormField<T>(
        initialValue: widget.initialValue,
        validator: widget.validator == null ? null : (T? value) => widget.validator!(value?.toString()),
        builder: (FormFieldState<T> field) {
          final String displayText = _selectedDropdownValue != null
              ? (widget.itemLabel != null ? widget.itemLabel!(_selectedDropdownValue as T) : _selectedDropdownValue.toString())
              : (widget.hintText ?? 'Select');

          final bool isHint = _selectedDropdownValue == null;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  widget.onTap?.call();
                  final T? result = await _showSearchableBottomSheet(context);
                  if (result != null) {
                    setState(() => _selectedDropdownValue = result);
                    field.didChange(result);
                    widget.onChanged?.call(result);
                  }
                },
                child: InputDecorator(
                  decoration: _decoration.copyWith(
                    errorText: field.errorText,
                    suffixIcon: widget.suffixIcon ?? Icon(SolarLinearIcons.altArrowDown, color: context.colorScheme.primary),
                  ),
                  child: Text(
                    displayText,
                    style: isHint ? _hintStyle : _textStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<T?> _showSearchableBottomSheet(BuildContext context) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _SearchableDropdownSheet<T>(
        items: widget.items ?? [],
        itemLabel: widget.itemLabel,
        textStyle: _textStyle,
        hintStyle: _hintStyle,
        selectedValue: _selectedDropdownValue,
        fillColor: _fillColor,
        border: _border,
        enabledBorder: _enabledBorder,
        borderRadius: widget.borderRadius,
      ),
    );
  }

  // Widget _buildDropdownField(BuildContext context) {
  //   return AbsorbPointer(
  //     absorbing: !widget.isEnabled,
  //     child: DropdownButtonFormField<T>(
  //       isExpanded: true,
  //       items: _items,
  //       onTap: widget.onTap,
  //       initialValue: widget.initialValue,
  //       decoration: _decoration,
  //       hint: Text(widget.hintText ?? 'Select', style: _hintStyle),
  //       onChanged: (value) => widget.onChanged?.call(value),
  //       validator: widget.validator == null ? null : (T? value) => widget.validator!(value?.toString()),
  //       // validator: widget.validator,
  //       borderRadius: widget.borderRadius ?? BorderRadius.circular(16.0),
  //       icon: widget.suffixIcon ?? Icon(SolarLinearIcons.altArrowDown, color: context.colorScheme.primary),
  //     ),
  //   );
  // }

  Widget _buildPhoneField(BuildContext context) {
    return AbsorbPointer(
      absorbing: !widget.isEnabled,
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber number) {
          widget.onChanged?.call(number.phoneNumber as T?);
        },
        onSubmit: () => FocusScope.of(context).unfocus(),
        onFieldSubmitted: (value) {
          if (widget.onSubmitted != null) {
            widget.onSubmitted!(value);
          }
          FocusScope.of(context).unfocus();
        },
        textFieldController: widget.controller,
        validator: widget.validator,
        hintText: widget.hintText,
        maxLength: 11,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        inputDecoration: _decoration,
        inputBorder: _border,
        autoFocus: widget.autofocus,
        initialValue: widget.initialPhone ?? PhoneNumber(isoCode: 'TZ'),
        searchBoxDecoration: InputDecoration(
          hintText: Strings.instance.searchCountry,
          hintStyle: context.bodyMedium,
          filled: true,
          fillColor: context.colorScheme.surfaceContainerHigh,
          border: _border,
          focusedBorder: _border,
          enabledBorder: _enabledBorder,
        ),
        selectorConfig: const SelectorConfig(
          showFlags: true,
          useBottomSheetSafeArea: true,
          setSelectorButtonAsPrefixIcon: true,
          selectorType: PhoneInputSelectorType.DIALOG,
          leadingPadding: 12.0,
        ),
      ),
    );
  }

  Widget _buildPINField(BuildContext context) {
    final PinTheme theme = PinTheme(
      width: widget.pinBoxWidth,
      height: widget.pinBoxHeight,
      textStyle: context.titleLarge.semiBold,
      decoration: BoxDecoration(
        color: _fillColor,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        border: Border.all(color: context.colorScheme.surface, width: 2),
        boxShadow: [HelperWidgets.shadow(context)],
      ),
    );

    return AbsorbPointer(
      absorbing: !widget.isEnabled,
      child: Pinput(
        length: widget.pinLength ?? 4,
        controller: widget.controller,
        focusNode: widget.focusNode,
        defaultPinTheme: theme,
        showErrorWhenFocused: true,
        onCompleted: (pin) {
          if (widget.onCompleted != null) {
            widget.onCompleted!(pin);
          }
        },
        onSubmitted: (pin) {
          if (widget.onSubmitted != null) {
            widget.onSubmitted!(pin);
          }
        },
        onChanged: (pin) {
          if (widget.onChanged != null) {
            widget.onChanged!(pin as T?);
          }
        },
        validator: widget.validator,
        obscureText: widget.obscureText ?? false,
        autofocus: widget.autofocus,
        readOnly: widget.isReadOnly,
        inputFormatters: widget.inputFormatters ?? [],
        errorTextStyle: context.bodySmall.copyWith(color: context.colorScheme.error),
        focusedPinTheme: theme.copyWith(
          width: widget.pinBoxWidth,
          height: widget.pinBoxHeight,
          decoration: theme.decoration!.copyWith(border: Border.all(color: context.colorScheme.primary, width: 2.0)),
        ),
        errorPinTheme: theme.copyWith(
          decoration: BoxDecoration(
            color: context.colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.colorScheme.error, width: 2.0),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<T>>? get _items {
    if (widget.items == null) return null;
    return widget.items!
        .map<DropdownMenuItem<T>>(
          (value) => DropdownMenuItem<T>(
            value: value,
            child: Text(widget.itemLabel != null ? widget.itemLabel!(value) : value.toString(), style: _textStyle),
          ),
        )
        .toList();
  }

  InputDecoration get _decoration {
    return InputDecoration(
      isDense: widget.dense,
      hintText: widget.hintText,
      hintStyle: _hintStyle,
      prefixIcon: widget.prefixIcon,
      prefix: widget.prefix,
      prefixText: widget.prefixText,
      prefixStyle: context.bodyMedium,
      suffixIcon: widget.suffixIcon,
      suffix: widget.suffix,
      filled: true,
      fillColor: _fillColor,
      border: widget.border ?? _border,
      focusedBorder: widget.focusedBorder ?? _border,
      enabledBorder: widget.enabledBorder ?? _enabledBorder,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    );
  }

  InputBorder get _enabledBorder {
    if (widget.variant == InputFieldVariant.glass) return _glassBorder;
    return DecoratedInputBorder(
      child: OutlineInputBorder(
        borderSide: BorderSide(color: widget.borderColor ?? context.colorScheme.surface, width: 2.0),
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12.0),
      ),
      shadow: HelperWidgets.shadow(context),
    );
  }

  InputBorder get _glassBorder {
    return GradientOutlineInputBorder(
      width: 2,
      borderRadius: widget.borderRadius ?? BorderRadius.circular(12.0),
      gradient: LinearGradient(
        colors: [context.colorScheme.surface.withValues(alpha: 0.5), context.colorScheme.outline.withValues(alpha: 0.3)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  InputBorder get _border {
    return DecoratedInputBorder(
      child: OutlineInputBorder(
        borderSide: BorderSide(color: _focusedBorderColor, width: 2.0),
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12.0),
      ),
      shadow: HelperWidgets.shadow(context),
    );
  }

  Color get _fillColor {
    if (widget.fillColor != null) return widget.fillColor!;
    if (widget.variant == InputFieldVariant.glass) {
      return Colors.white.withValues(alpha: 0.2);
    }
    return context.colorScheme.surfaceContainer;
  }

  Color get _focusedBorderColor {
    if (widget.variant == InputFieldVariant.glass) return Colors.white;
    return context.colorScheme.primary;
  }

  TextStyle get _hintStyle {
    Color textColor = widget.variant == InputFieldVariant.glass ? Colors.white70 : context.colorScheme.outline;
    return context.bodyMedium.copyWith(color: textColor);
  }

  TextStyle get _textStyle {
    Color textColor = widget.variant == InputFieldVariant.glass ? Colors.white : context.colorScheme.onSurface;
    return context.bodyMedium.copyWith(color: textColor);
  }

  Color? get _cursorColor {
    return widget.variant == InputFieldVariant.glass ? Colors.white : context.colorScheme.onSurface;
  }
}

class _SearchableDropdownSheet<T> extends StatefulWidget {
  const _SearchableDropdownSheet({
    required this.items,
    required this.itemLabel,
    required this.textStyle,
    required this.hintStyle,
    required this.selectedValue,
    required this.fillColor,
    required this.border,
    required this.enabledBorder,
    this.borderRadius,
  });

  final List<T> items;
  final String Function(T)? itemLabel;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final T? selectedValue;
  final Color fillColor;
  final InputBorder border;
  final InputBorder enabledBorder;
  final BorderRadius? borderRadius;

  @override
  State<_SearchableDropdownSheet<T>> createState() => _SearchableDropdownSheetState<T>();
}

class _SearchableDropdownSheetState<T> extends State<_SearchableDropdownSheet<T>> {
  late List<T> _filtered;
  final TextEditingController _searchController = TextEditingController();

  String _label(T item) => widget.itemLabel != null ? widget.itemLabel!(item) : item.toString();

  @override
  void initState() {
    super.initState();
    _filtered = List<T>.from(widget.items);
  }

  void _onSearch(String query) {
    setState(() {
      _filtered = widget.items.where((item) => _label(item).toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, scrollController) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: context.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              InputField(
                controller: _searchController,
                autofocus: true,
                hintText: Strings.instance.search,
                prefixIcon: const Icon(SolarLinearIcons.magnifer),
                onChanged: (value) => _onSearch(value?.toString() ?? ''),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _filtered.isEmpty
                    ? Center(
                        child: Text(Strings.instance.noResultsFound, style: widget.hintStyle),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: _filtered.length,
                        itemBuilder: (_, index) {
                          final item = _filtered[index];
                          final bool isSelected = item == widget.selectedValue;
                          return ListTile(
                            title: Text(_label(item), style: widget.textStyle),
                            trailing: isSelected ? Icon(Icons.check_circle, color: context.colorScheme.primary) : null,
                            selected: isSelected,
                            selectedTileColor: context.colorScheme.primaryContainer.withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
                            ),
                            onTap: () => Navigator.of(context).pop(item),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//VALIDATION RULES
// RequiredRule - Validates that a value is not null or empty
// EmailRule - Validates that a string is a valid email address
// PasswordRule - Validates that a string meets password requirements
// PasswordMatchRule - Validates that a string matches another string
// LengthRule - Validates that a string's length is within specified bounds
// MinLengthRule - Validates that a string's length is at least a specified minimum
// MaxLengthRule - Validates that a string's length is at most a specified maximum
// ValueRule - Validates that a numeric value is within specified bounds
// MinValueRule - Validates that a numeric value is at least a specified minimum
// MaxValueRule - Validates that a numeric value is at most a specified maximum
// PhoneRule - Validates that a string is a valid phone number
// CountryPhoneRule - Validates that a string is a valid phone number for a specific country
// UrlRule - Validates that a string is a valid URL
// IPAddressRule - Validates that a string is a valid IPv4 or IPv6 address
// CreditCardRule - Validates that a string is a valid credit card number
// DateRule - Validates that a date string is within specified bounds
// DateRangeRule - Validates that an end date is after a start date (string inputs)
