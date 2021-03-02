import 'package:auto_route/auto_route_annotations.dart';
import 'package:project_template/home/view/home_page.dart';
import 'package:project_template/root/view/root_page.dart';

export 'my_router.gr.dart';

@MaterialAutoRouter(
  generateNavigationHelperExtension: true,
  routes: <AutoRoute>[
    // initial route is named "/"
    MaterialRoute(page: RootPage),
    MaterialRoute(page: HomePage),
  ],
)
class $MyRouter {}
