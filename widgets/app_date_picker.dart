import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:solar_icon_pack/solar_linear_icons.dart';
import 'package:solomon/services/strings.dart';
import 'package:solomon/shared/widgets/app_button.dart';
import 'package:solomon/shared/widgets/app_divider.dart';

class AppDatePicker extends StatefulWidget {
  final DateTime? initialDate;

  const AppDatePicker({super.key, this.initialDate});

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController dayController;
  late FixedExtentScrollController yearController;

  final List<String> months = List.generate(12, (i) => DateFormat('MMMM').format(DateTime(0, i + 1)));
  final List<int> years = List.generate(100, (index) => 1950 + index);

  int selectedMonth = 1;
  int selectedDay = 1;
  int selectedYear = 1990;

  @override
  void initState() {
    super.initState();

    final initial = widget.initialDate ?? DateTime.now();
    selectedMonth = initial.month;
    selectedYear = initial.year;
    selectedDay = initial.day;

    monthController = FixedExtentScrollController(initialItem: selectedMonth - 1);
    yearController = FixedExtentScrollController(initialItem: years.indexOf(selectedYear));
    dayController = FixedExtentScrollController(initialItem: selectedDay - 1);
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  void _updateDayIfInvalid() {
    final maxDays = _daysInMonth(selectedYear, selectedMonth);
    if (selectedDay > maxDays) {
      setState(() {
        selectedDay = maxDays;
        dayController.jumpToItem(maxDays - 1);
      });
    }
  }

  Widget _picker<T>(List<T> items, FixedExtentScrollController controller, Function(int) onSelected, bool Function(int) isSelected) {
    return Expanded(
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        physics: const FixedExtentScrollPhysics(),
        itemExtent: 48,
        onSelectedItemChanged: onSelected,
        overAndUnderCenterOpacity: 0.4,
        perspective: 0.0001,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: items.length,
          builder: (context, index) {
            final value = items[index].toString();
            final selected = isSelected(index);
            return Center(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: selected ? 18 : 15,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  color: selected ? context.colorScheme.onSurface : context.colorScheme.outline,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int daysCount = _daysInMonth(selectedYear, selectedMonth);
    final List<int> days = List.generate(daysCount, (i) => i + 1);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        height: 350,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(Strings.instance.selectDate, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.titleLarge.semiBold),
                  ),
                  IconButton(onPressed: () => context.pop(), icon: const Icon(SolarLinearIcons.close)),
                ],
              ),
              AppDivider(height: 20, color: context.themeData.dividerColor),
              SizedBox(
                height: 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _picker(months, monthController, (index) {
                      HapticFeedback.selectionClick();
                      selectedMonth = index + 1;
                      _updateDayIfInvalid();
                      setState(() {});
                    }, (index) => selectedMonth == index + 1),
                    _picker(days, dayController, (index) {
                      HapticFeedback.selectionClick();
                      selectedDay = index + 1;
                      setState(() {});
                    }, (index) => selectedDay == index + 1),
                    _picker(years, yearController, (index) {
                      HapticFeedback.selectionClick();
                      selectedYear = years[index];
                      _updateDayIfInvalid();
                      setState(() {});
                    }, (index) => selectedYear == years[index]),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                spacing: 8.0,
                children: [
                  Expanded(
                    child: AppButton.outline(title: Strings.instance.cancel, expands: true, onPressed: () => context.pop()),
                  ),
                  Expanded(
                    child: AppButton(
                      title: Strings.instance.save,
                      expands: true,
                      onPressed: () {
                        final selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
                        context.pop(selectedDate);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<DateTime?> openAppDatePicker(BuildContext context) async {
  return await showDialog(context: context, builder: (_) => const AppDatePicker());
}
