import 'package:flutter/material.dart';
import 'package:lista/app/view/home/inherited_widgets.dart';
import 'package:lista/app/view/splash/splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary  = Color(0xFF008080);
    const textColor  = Color(0xFF4A4A4A);
    const background  = Color(0xFFFAFDBE);
    return SpecialColor(
      color: Colors.redAccent,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primary),
          scaffoldBackgroundColor: background,
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: textColor,
            displayColor: textColor,
          ),
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.transparent
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(
                  double.infinity,
                  54,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              textStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              )
            ),
          ),
        ),
        home: SplashPage(),
      ),
    );
  }
}
