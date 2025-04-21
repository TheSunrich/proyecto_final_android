import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:proyecto_final/data/models/sucursal.dart';
import 'package:proyecto_final/data/models/producto.dart';
import 'package:proyecto_final/data/models/usuario.dart';
import 'package:proyecto_final/data/models/detalle_venta.dart';
import 'package:proyecto_final/data/models/venta.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('inventario.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sucursal (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        ubicacion TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE producto (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT,
        precio REAL NOT NULL,
        stock INTEGER NOT NULL,
        id_sucursal INTEGER,
        is_active INTEGER DEFAULT 1,
        FOREIGN KEY (id_sucursal) REFERENCES sucursal (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE usuario (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        telefono TEXT,
        email TEXT,
        contrasena TEXT NOT NULL,
        rol TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE venta (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_sucursal INTEGER,
        id_cliente INTEGER,
        metodo_pago TEXT,
        total REAL NOT NULL,
        created_at TEXT NOT NULL,
        is_payed INTEGER DEFAULT 0,
        FOREIGN KEY (id_sucursal) REFERENCES sucursal (id),
        FOREIGN KEY (id_cliente) REFERENCES cliente (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE detalle_venta (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_venta INTEGER,
        id_producto INTEGER,
        cantidad INTEGER NOT NULL,
        precio_unitario REAL NOT NULL,
        FOREIGN KEY (id_venta) REFERENCES venta (id),
        FOREIGN KEY (id_producto) REFERENCES producto (id)
      );
    ''');
  }

  // ================== SUCURSAL ==================

  Future<int> insertarSucursal(Sucursal sucursal) async {
    final db = await database;
    return await db.insert('sucursal', sucursal.toJson());
  }

  Future<List<Sucursal>> obtenerSucursales([String? search]) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sucursal');
    if (search != null && search.isNotEmpty) {
      return List.generate(maps.length, (i) => Sucursal.fromJson(maps[i]))
          .where(
            (sucursal) =>
                sucursal.nombre.toLowerCase().contains(search.toLowerCase()),
          )
          .toList();
    }
    return List.generate(maps.length, (i) => Sucursal.fromJson(maps[i]));
  }

  Future<int> actualizarSucursal(Sucursal sucursal) async {
    final db = await database;
    return await db.update(
      'sucursal',
      sucursal.toJson(),
      where: 'id = ?',
      whereArgs: [sucursal.id],
    );
  }

  Future<int> eliminarSucursal(int id) async {
    final db = await database;
    return await db.delete('sucursal', where: 'id = ?', whereArgs: [id]);
  }

  // ================== PRODUCTO ==================

  Future<int> insertarProducto(Producto producto) async {
    final db = await database;
    return await db.insert('producto', producto.toJson());
  }

  Future<Producto?> obtenerProductoPorId(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'producto',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Producto.fromJson(maps.first);
    }
    return null;
  }

  Future<List<Producto>> obtenerProductosPorSucursal(
    int idSucursal, [
    String? search,
    bool isActive = false,
  ]) async {
    final db = await database;
    final List<Map<String, dynamic>> maps;
    if (isActive) {
      maps = await db.query(
        'producto',
        where: 'id_sucursal = ? AND stock > 0',
        whereArgs: [idSucursal],
      );
    } else {
      maps = await db.query(
        'producto',
        where: 'id_sucursal = ? AND is_active = 1 AND stock > 0',
        whereArgs: [idSucursal],
      );
    }

    if (search != null && search.isNotEmpty) {
      return List.generate(maps.length, (i) => Producto.fromJson(maps[i]))
          .where(
            (producto) =>
                producto.nombre.toLowerCase().contains(search.toLowerCase()),
          )
          .toList();
    }
    return List.generate(maps.length, (i) => Producto.fromJson(maps[i]));
  }

  Future<int> actualizarProducto(Producto producto) async {
    final db = await database;
    return await db.update(
      'producto',
      producto.toJson(),
      where: 'id = ?',
      whereArgs: [producto.id],
    );
  }

  Future<int> eliminarProducto(int id) async {
    final db = await database;
    return await db.update(
      'producto',
      {'is_active': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> reactivarProducto(int id) async {
    final db = await database;
    return await db.update(
      'producto',
      {'is_active': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ================== VENTA y DETALLE VENTA ==================

  Future<int> insertarVenta(Venta venta) async {
    final db = await database;
    return await db.insert('venta', venta.toJson());
  }

  Future<void> insertarDetalleVenta(DetalleVenta detalle) async {
    final db = await database;
    await db.insert('detalle_venta', detalle.toJson());
  }

  Future<void> reducirStock(int idProducto, int cantidadVendida) async {
    final db = await database;
    await db.rawUpdate(
      '''
        UPDATE producto SET stock = stock - ? WHERE id = ?
      ''',
      [cantidadVendida, idProducto],
    );
  }

  Future<void> pagarVenta(int idVenta, String metodoPago) async {
    final db = await database;
    await db.rawUpdate(
      '''
        UPDATE venta 
        SET is_payed = 1, 
            metodo_pago = ? 
        WHERE id = ?
      ''',
      [metodoPago, idVenta],
    );
  }

  Future<List<DetalleVenta>> obtenerDetallesVenta(int idVenta) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'detalle_venta',
      where: 'id_venta = ?',
      whereArgs: [idVenta],
    );
    return List.generate(maps.length, (i) => DetalleVenta.fromJson(maps[i]));
  }

  Future<List<Map<String, dynamic>>> obtenerVentasConDetalles() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT v.id, v.fecha, v.metodo_pago, v.total,
             s.nombre AS sucursal, c.nombre AS cliente
      FROM venta v
      LEFT JOIN sucursal s ON v.id_sucursal = s.id
      LEFT JOIN cliente c ON v.id_cliente = c.id
      ORDER BY v.fecha DESC
    ''');
  }

  Future<List<Venta>> obtenerVentasPorCliente(int idCliente) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'venta',
      where: 'id_cliente = ?',
      orderBy: 'created_at DESC',
      whereArgs: [idCliente],
    );
    return List.generate(maps.length, (i) => Venta.fromJson(maps[i]));
  }

  Future<List<Map<String, dynamic>>> obtenerInventarioPorSucursal(
    int idSucursal,
  ) async {
    final db = await database;
    return await db.rawQuery(
      '''
        SELECT p.nombre, p.stock, p.precio
        FROM producto p
        WHERE p.id_sucursal = ?
      ''',
      [idSucursal],
    );
  }

  // ================== USUARIO ==================

  Future<int> insertarUsuario(Usuario usuario) async {
    final db = await database;
    return await db.insert('usuario', usuario.toJson());
  }

  Future<int> actualizarUsuario(Usuario usuario) async {
    final db = await database;
    return await db.update(
      'usuario',
      usuario.toJson(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  Future<Usuario?> validarLogin(String nombre, String contrasena) async {
    final db = await database;
    final result = await db.query(
      'usuario',
      where: 'nombre = ? AND contrasena = ?',
      whereArgs: [nombre, contrasena],
    );

    if (result.isNotEmpty) {
      return Usuario.fromJson(result.first);
    } else {
      return null;
    }
  }

  Future<List<Usuario>> obtenerUsuarios([
    String? search,
    String rol = 'admin',
  ]) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuario',
      where: 'rol = ?',
      whereArgs: [rol],
    );
    if (search != null && search.isNotEmpty) {
      return List.generate(maps.length, (i) => Usuario.fromJson(maps[i]))
          .where(
            (usuario) =>
                usuario.nombre.toLowerCase().contains(search.toLowerCase()),
          )
          .toList();
    }
    return List.generate(maps.length, (i) => Usuario.fromJson(maps[i]));
  }

  Future<Usuario?> obtenerUsuarioPorId(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuario',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Usuario.fromJson(maps.first);
    }
    return null;
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
