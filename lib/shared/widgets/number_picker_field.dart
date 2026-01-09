import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/colors.dart';

class NumberPickerField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final int minValue;
  final int maxValue;
  final int currentValue;
  final String unit;
  final ValueChanged<int> onChanged;
  final bool isDecimal;

  const NumberPickerField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.minValue,
    required this.maxValue,
    required this.currentValue,
    required this.unit,
    required this.onChanged,
    this.isDecimal = false,
  });

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _NumberPickerModal(
        label: label,
        minValue: minValue,
        maxValue: maxValue,
        currentValue: currentValue,
        unit: unit,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.white.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentValue > 0 ? '$currentValue $unit' : hint,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.white.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberPickerModal extends StatefulWidget {
  final String label;
  final int minValue;
  final int maxValue;
  final int currentValue;
  final String unit;
  final ValueChanged<int> onChanged;

  const _NumberPickerModal({
    required this.label,
    required this.minValue,
    required this.maxValue,
    required this.currentValue,
    required this.unit,
    required this.onChanged,
  });

  @override
  State<_NumberPickerModal> createState() => _NumberPickerModalState();
}

class _NumberPickerModalState extends State<_NumberPickerModal> {
  late int _selectedValue;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.currentValue > 0
        ? widget.currentValue
        : (widget.minValue + (widget.maxValue - widget.minValue) ~/ 2);

    final initialIndex = _selectedValue - widget.minValue;
    _scrollController = FixedExtentScrollController(initialItem: initialIndex);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.onChanged(_selectedValue);
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Picker
          Expanded(
            child: Stack(
              children: [
                ListWheelScrollView.useDelegate(
                  controller: _scrollController,
                  itemExtent: 50,
                  perspective: 0.005,
                  diameterRatio: 1.5,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedValue = widget.minValue + index;
                    });
                    HapticFeedback.selectionClick();
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      if (index < 0 ||
                          index > (widget.maxValue - widget.minValue)) {
                        return null;
                      }

                      final value = widget.minValue + index;
                      final isSelected = value == _selectedValue;

                      return Center(
                        child: Text(
                          '$value ${widget.unit}',
                          style: TextStyle(
                            fontSize: isSelected ? 28 : 20,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? AppColors.skyBlue
                                : Colors.grey[400],
                          ),
                        ),
                      );
                    },
                    childCount: (widget.maxValue - widget.minValue) + 1,
                  ),
                ),

                // Selection indicator
                Center(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          color: AppColors.skyBlue.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
