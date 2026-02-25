/// ---------- Permission Service ساده ----------
class PermissionService {
  final Set<String> _permissions;

  PermissionService([Set<String>? initial]) : _permissions = initial ?? {};

  bool has(String permission) => _permissions.contains(permission);

  void grant(String permission) => _permissions.add(permission);

  void revoke(String permission) => _permissions.remove(permission);
}