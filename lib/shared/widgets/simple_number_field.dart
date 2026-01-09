import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class SimpleNumberField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final int minValue;
  final int maxValue;
  final int currentValue;
  final String unit;
  final ValueChanged<int> onChanged;

  const SimpleNumberField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.minValue,
    required this.maxValue,
    required this.currentValue,
    required this.unit,
    required this.onChanged,
  });

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        int selectedValue = currentValue > 0 ? currentValue : minValue;
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 300,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            onChanged(selectedValue);
                            Navigator.pop(context);
                          },
                          child: const Text('Done'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: selectedValue > minValue
                              ? () {
                                  setState(() {
                                    selectedValue--;
                                  });
                                }
                              : null,
                        ),
                        Container(
                          width: 120,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.skyBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$selectedValue $unit',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.skyBlue,
                            ),
                          ),
                        ),
                        IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: selectedValue < maxValue
                              ? () {
                                  setState(() {
                                    selectedValue++;
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Range: $minValue - $maxValue $unit',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showPicker(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.skyBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.skyBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentValue > 0 ? '$currentValue $unit' : hint,
                    style: TextStyle(
                      color: currentValue > 0
                          ? AppColors.skyBlue
                          : Colors.grey[500],
                      fontSize: 16,
                      fontWeight:
                          currentValue > 0 ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
