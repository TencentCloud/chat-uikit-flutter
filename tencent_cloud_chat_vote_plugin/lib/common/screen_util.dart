import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAdapt extends StatelessWidget {
  final Widget adaptChild;
  const ScreenAdapt({
    Key? key,
    required this.adaptChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: adaptChild,
      builder: (context, child) => child!,
    );
  }
}
