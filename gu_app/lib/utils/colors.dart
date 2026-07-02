/// 占位色工具
class AppColors {
  static const List<int> _placeholderColors = [
    0xFFFF6B6B, 0xFF4ECDC4, 0xFFFFE66D, 0xFF95E1D3,
    0xFFF38181, 0xFFAA96DA, 0xFFFCE38A, 0xFF00B4D8,
    0xFFE17055, 0xFF6C5CE7, 0xFFA29BFE, 0xFFFD79A8,
    0xFF00CEC9, 0xFFD63031, 0xFF0984E3, 0xFFE17055,
  ];

  static int getPlaceholderColor(int index) =>
      _placeholderColors[index % _placeholderColors.length];
}