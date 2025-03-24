part of routing.base;

typedef NavPageBuilder = Page Function(BuildContext context, [dynamic data]);

///
abstract class NavRoute {
  const NavRoute(this.id, {required this.builder, this.data});

  final String id;
  final NavPageBuilder builder;
  final dynamic data;

  Page build(BuildContext context) => builder(context, data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavRoute &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          builder == other.builder;

  @override
  int get hashCode => id.hashCode ^ builder.hashCode;

  @override
  String toString() {
    return 'NavRoute{id: $id, builder: $builder, data: $data}';
  }
}
