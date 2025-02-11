import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta_pipe/global_state.dart';
import 'package:meta_pipe/home_page.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GlobalState(),
      child: const MetaPipe(),
    ),
  );
}

class MetaPipe extends StatelessWidget {
  const MetaPipe({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orientation = MediaQuery.of(context).size.width > 905
          ? [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]
          : [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown];
      SystemChrome.setPreferredOrientations(orientation);
    });

    return MaterialApp(
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 600, name: 'xs'),
          const Breakpoint(start: 601, end: 905, name: 'sm'),
          const Breakpoint(start: 906, end: 1240, name: 'md'),
          const Breakpoint(start: 1241, end: 1440, name: 'lg'),
          const Breakpoint(start: 1440, end: double.infinity, name: '4K'),
        ],
      ),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) {
            return MaxWidthBox(
              maxWidth: 1920,
              background: Container(color: const Color(0xFFF5F5F5)),
              child: ResponsiveScaledBox(
                width: ResponsiveValue<double>(
                  context,
                  conditionalValues: const [
                    Condition.equals(name: 'xs', value: 325),
                    Condition.equals(name: 'sm', value: 600),
                    Condition.equals(name: 'md', value: 905),
                    Condition.equals(name: 'lg', value: 1240),
                    Condition.equals(name: '4K', value: 1440),
                  ],
                  defaultValue: 1440,
                ).value,
                child: BouncingScrollWrapper.builder(
                  context,
                  const HomePage(title: 'MetaPipe'),
                  dragWithMouse: true,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
