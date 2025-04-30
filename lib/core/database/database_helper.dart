import 'dart:math';

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
      CREATE TABLE IF NOT EXISTS sucursal (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        ubicacion TEXT,
        is_active INTEGER DEFAULT 1
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS producto (
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
      CREATE TABLE IF NOT EXISTS usuario (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        telefono TEXT,
        email TEXT,
        contrasena TEXT NOT NULL,
        rol TEXT NOT NULL,
        is_active INTEGER DEFAULT 1
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS venta (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_sucursal INTEGER,
        id_cliente INTEGER,
        id_vendedor INTEGER,
        metodo_pago TEXT,
        total REAL NOT NULL,
        created_at TEXT NOT NULL,
        is_payed INTEGER DEFAULT 0,
        FOREIGN KEY (id_sucursal) REFERENCES sucursal (id),
        FOREIGN KEY (id_cliente) REFERENCES cliente (id),
        FOREIGN KEY (id_vendedor) REFERENCES usuario (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS detalle_venta (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_venta INTEGER,
        id_producto INTEGER,
        cantidad INTEGER NOT NULL,
        precio_unitario REAL NOT NULL,
        FOREIGN KEY (id_venta) REFERENCES venta (id),
        FOREIGN KEY (id_producto) REFERENCES producto (id)
      );
    ''');

    generarDatosPrueba();
  }

  // =============== DATOS DE PRUEBA ==============

  Future<void> generarDatosPrueba() async {
    final db = DatabaseHelper();
    final random = Random();
    print('Inicializando datos de prueba...');

    List<Map<String, dynamic>> sucursales = [
      {'nombre': 'Sucursal Latte', 'ubicacion': 'Latte City', 'is_active': 1},
      {'nombre': 'Sucursal Moka', 'ubicacion': 'Moka City', 'is_active': 1},
      {'nombre': 'Sucursal Tiago', 'ubicacion': 'Tiago City', 'is_active': 1},
      {'nombre': 'Sucursal Duque', 'ubicacion': 'Duque City', 'is_active': 1},
      {'nombre': 'Sucursal Capu', 'ubicacion': 'Capu City', 'is_active': 1},
      {'nombre': 'Sucursal Artico', 'ubicacion': 'Artico City', 'is_active': 1},
    ];

    final productosPorSucursal = {
      'Sucursal Latte': [
        'Café Americano',
        'Latte Vainilla',
        'Capuchino Clásico',
        'Té Chai',
        'Scone de Arándano',
        'Muffin de Chocolate',
        'Croissant de Mantequilla',
      ],
      'Sucursal Moka': [
        'Mocha Frappuccino',
        'Espresso Doble',
        'Café Helado',
        'Galleta de Avena',
        'Brownie de Nuez',
        'Pan de Plátano',
      ],
      'Sucursal Tiago': [
        'Latte de Almendra',
        'Cold Brew',
        'Chocolate Caliente',
        'Sándwich de Jamón y Queso',
        'Cheesecake de Fresa',
        'Té Verde Matcha',
      ],
      'Sucursal Duque': [
        'Café Espresso Macchiato',
        'Latte de Caramelo',
        'Panini de Pollo',
        'Muffin de Vainilla',
        'Donut Glaseada',
        'Smoothie de Mango',
      ],
      'Sucursal Capu': [
        'Café Turco',
        'Capuchino de Canela',
        'Refresco de Cola',
        'Galletas de Chocolate',
        'Empanada de Manzana',
        'Té Negro',
      ],
      'Sucursal Artico': [
        'Latte de Coco',
        'Mocha Blanco',
        'Refresco de Limón',
        'Croissant de Almendra',
        'Galleta de Mantequilla',
        'Brownie de Chocolate Blanco',
      ],
    };

    final clientes = [
      {
        'nombre': 'Juan',
        'telefono': '555-123-4567',
        'email': 'juan.perez@example.com',
        'contrasena': '1234',
        'rol': 'cliente',
        'is_active': 1,
      },
      {
        'nombre': 'Ana',
        'telefono': '555-234-5678',
        'email': 'ana.gomez@example.com',
        'contrasena': '1234',
        'rol': 'cliente',
        'is_active': 1,
      },
      {
        'nombre': 'Carlos',
        'telefono': '555-345-6789',
        'email': 'carlos.ramirez@example.com',
        'contrasena': '1234',
        'rol': 'cliente',
        'is_active': 1,
      },
      {
        'nombre': 'Maria',
        'telefono': '555-456-7890',
        'email': 'maria.fernandez@example.com',
        'contrasena': '1234',
        'rol': 'cliente',
        'is_active': 1,
      },
      {
        'nombre': 'Luis',
        'telefono': '555-567-8901',
        'email': 'luis.torres@example.com',
        'contrasena': '1234',
        'rol': 'cliente',
        'is_active': 1,
      },
      {
        'nombre': 'Paola',
        'telefono': '555-678-9012',
        'email': 'paola.ruiz@example.com',
        'contrasena': '1234',
        'rol': 'cliente',
        'is_active': 1,
      },
      {
        'nombre': 'Jose',
        'telefono': '555-789-0123',
        'email': 'jose.martinez@example.com',
        'contrasena': '1234',
        'rol': 'cliente',
        'is_active': 1,
      },
      {
        'nombre': 'Sofia',
        'telefono': '555-890-1234',
        'email': 'sofia.castro@example.com',
        'contrasena': '1234',
        'rol': 'cliente',
        'is_active': 1,
      },
    ];

    final metodosPago = [
      'Efectivo',
      'Tarjeta de crédito',
      'Tarjeta de débito',
      'Transferencia bancaria',
      'PayPal',
    ];

    List<int> allSucursalId = [];

    for (var sucursal in sucursales) {
      Sucursal newSucursal = Sucursal.fromJson(sucursal);
      final sucursalId = await db.insertarSucursal(newSucursal);
      allSucursalId.add(sucursalId);
      final nombreSucursal = newSucursal.nombre;

      final productos = productosPorSucursal[nombreSucursal] ?? [];

      for (var nombreProducto in productos) {
        Map<String, dynamic> producto = {
          'nombre': nombreProducto,
          'descripcion':
              'Delicioso $nombreProducto hecho con ingredientes de calidad.',
          'precio':
              double.parse((15 + Random().nextDouble() * (150 - 15)).toStringAsFixed(2)),
          'stock': 10 + Random().nextInt(300 - 10 + 1),
          'id_sucursal': sucursalId,
          'is_active': 1,
        };

        Producto newProducto = Producto.fromJson(producto);

        await db.insertarProducto(newProducto);
      }
    }
    final admin = Usuario(nombre: 'admin', contrasena: '1234', rol: 'admin');
    await db.insertarUsuario(admin);

    final vendedor = Usuario(
      nombre: 'vendedor',
      contrasena: '1234',
      rol: 'vendedor',
    );
    await db.insertarUsuario(vendedor);

    for (var cliente in clientes) {
      Usuario newCliente = Usuario.fromJson(cliente);
      final clienteId = await db.insertarUsuario(newCliente);
      int compras = random.nextInt(3) + 1;

      for (var i = 0; i < compras; i++) {
        final sucursal = allSucursalId[random.nextInt(allSucursalId.length)];

        final productosSucursal = await db.obtenerProductosPorSucursal(
          sucursal,
        );

        if (productosSucursal.isEmpty) continue;

        String metodoPago = metodosPago[random.nextInt(metodosPago.length)];
        final endDate = DateTime.now();
        final initDate = endDate.subtract(const Duration(days: 10));
        final diff = endDate.difference(initDate).inDays;

        final createdAt = initDate.add(Duration(days: random.nextInt(diff + 1)));

        Map<String, dynamic> venta = {
          'id_sucursal': sucursal,
          'id_cliente': clienteId,
          'id_vendedor': random.nextInt(2) + 1,
          'metodo_pago': metodoPago,
          'total': 0.0,
          'created_at': createdAt.toIso8601String(),
          'is_payed': 1,
        };

        int ventaId = await db.insertarVenta(Venta.fromJson(venta));

        double totalVenta = 0.0;

        int productosComprados = random.nextInt(5) + 1;

        final productosSeleccionados = [...productosSucursal]..shuffle();

        for (
          var j = 0;
          j < productosComprados && j < productosSeleccionados.length;
          j++
        ) {
          var producto = productosSeleccionados[j];
          int cantidad = random.nextInt(3) + 1;

          Map<String, dynamic> detalle = {
            'id_venta': ventaId,
            'id_producto': producto.id,
            'cantidad': cantidad,
            'precio_unitario': producto.precio,
          };

          await db.insertarDetalleVenta(DetalleVenta.fromJson(detalle));

          totalVenta += cantidad * producto.precio;
        }

        await db.actualizarVenta(
          Venta(
            id: ventaId,
            idSucursal: sucursal,
            idCliente: clienteId,
            idVendedor: venta['id_vendedor'],
            metodoPago: venta['metodo_pago'],
            total: totalVenta,
            createdAt: createdAt,
            isPayed: true,
          ),
        );
      }
    }
    print('Datos de prueba inicializados.');
  }

  // ================== SUCURSAL ==================

  Future<int> insertarSucursal(Sucursal sucursal) async {
    final db = await database;
    return await db.insert('sucursal', sucursal.toJson());
  }

  Future<List<Sucursal>> obtenerSucursales({
    String? search,
    bool? isActive,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sucursal');
    if (isActive != null) {
      maps.retainWhere((map) => map['is_active'] == (isActive ? 1 : 0));
    }
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
    return await db.update(
      'sucursal',
      {'is_active': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> reactivarSucursal(int id) async {
    final db = await database;
    return await db.update(
      'sucursal',
      {'is_active': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
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
    int idSucursal, {
    String? search,
    bool? isActive,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'producto',
      where: 'id_sucursal = ? AND stock > 0',
      whereArgs: [idSucursal],
    );
    if (isActive != null) {
      maps.retainWhere((map) => map['is_active'] == (isActive ? 1 : 0));
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

  Future<void> actualizarVenta(Venta venta) async {
    final db = await database;
    await db.update(
      'venta',
      venta.toJson(),
      where: 'id = ?',
      whereArgs: [venta.id],
    );
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
      where: 'nombre = ? AND contrasena = ? AND is_active = 1',
      whereArgs: [nombre, contrasena],
    );

    if (result.isNotEmpty) {
      return Usuario.fromJson(result.first);
    } else {
      return null;
    }
  }

  Future<List<Usuario>> obtenerUsuarios({
    String? search,
    String rol = 'admin',
    bool? isActive,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuario',
      where: 'rol = ?',
      whereArgs: [rol],
    );
    if (isActive != null) {
      maps.retainWhere((map) => map['is_active'] == (isActive ? 1 : 0));
    }
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

  Future<int> eliminarUsuario(int id) async {
    final db = await database;
    return await db.update(
      'usuario',
      {'is_active': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> reactivarUsuario(int id) async {
    final db = await database;
    return await db.update(
      'usuario',
      {'is_active': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ================== REPORTES ==================

  Future<List<Map<String, dynamic>>> obtenerTotalesVentasPorCliente(
    String inicio,
    String fin,
  ) async {
    final db = await database;
    return await db.rawQuery(
      '''
      SELECT COALESCE(c.nombre, 'Sin Cliente') as cliente, c.email, SUM(v.total) as gasto
      FROM venta v
      LEFT JOIN usuario c ON v.id_cliente = c.id
      WHERE date(v.created_at) BETWEEN ? AND ?
      GROUP BY cliente
      ORDER BY gasto DESC
    ''',
      [inicio, fin],
    );
  }

  Future<List<Map<String, dynamic>>> obtenerTotalesVentasPorSucursal(
    int sucursal,
    String inicio,
    String fin,
  ) async {
    final db = await database;
    return await db.rawQuery(
      '''
      SELECT v.created_at, v.total, 
             COALESCE(c.nombre, 'Sin Cliente') as cliente, 
             v.metodo_pago
      FROM venta v
      LEFT JOIN usuario c ON v.id_cliente = c.id
      WHERE v.id_sucursal = ? AND date(v.created_at) BETWEEN ? AND ?
      ORDER BY v.created_at ASC
    ''',
      [sucursal, inicio, fin],
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
