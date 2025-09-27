import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../component/config/app_style.dart';

class ExpenseCategoryCard extends StatelessWidget {
  final double sizedCard;
  final double sizedIcon;
  final Color backgroundColorIcon;
  final String iconCard;
  final String title;
  final String totalAmount;

  const ExpenseCategoryCard(
      {super.key,
      this.sizedCard = 120,
      this.sizedIcon = 36,
      required this.backgroundColorIcon,
      required this.iconCard,
      required this.title,
      required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sizedCard,
      height: sizedCard,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppStyle.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: sizedIcon,
            height: sizedIcon,
            decoration: BoxDecoration(
              color: backgroundColorIcon,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                iconCard,
                width: 24,
                height: 24,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(title,
              style: AppStyle.light(size: 12, textColor: AppStyle.grey3)),
          SizedBox(height: 8),
          Text(totalAmount,
              style: AppStyle.bold(size: 12, textColor: AppStyle.grey1)),
        ],
      ),
    );
  }
}
