// Class for route arguments when having required arguments for creating pages
// This class allows us to convert arguments in route_generator.dart to a
// more usable type.

class HomeArguments {
  final Function updatePage;

  const HomeArguments({
    required this.updatePage,
  });
}
