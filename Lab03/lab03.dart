import 'dart:async';
import 'dart:convert';

Future<void> main() async {
  print("========== EXERCISE 1 ==========");
  await ex1();

  print("\n========== EXERCISE 2 ==========");
  await ex2();

  print("\n========== EXERCISE 3 ==========");
  await ex3();

  print("\n========== EXERCISE 4 ==========");
  await ex4();

  print("\n========== EXERCISE 5 ==========");
  ex5();
}

//Ex1--------------------------

class Product {
  int id;
  String name;
  double price;

  Product(this.id, this.name, this.price);

  @override
  String toString() {
    return "Product(id: $id, name: $name, price: $price)";
  }
}

class ProductRepository {
  final List<Product> _products = [
    Product(1, "Laptop", 1200.0),
    Product(2, "Mouse", 25.0),
  ];

  final StreamController<Product> _controller =
      StreamController<Product>.broadcast();

  Future<List<Product>> getAll() async {
    await Future.delayed(Duration(seconds: 1));

    return _products;
  }

  Stream<Product> liveAdded() {
    return _controller.stream;
  }

  void addProduct(Product product) {
    _products.add(product);

    _controller.add(product);
  }

  Future<void> close() async {
    await _controller.close();
  }
}

Future<void> ex1() async {
  ProductRepository repository = ProductRepository();

  StreamSubscription<Product> subscription =
      repository.liveAdded().listen((product) {
    print("New product: $product");
  });

  List<Product> products = await repository.getAll();

  print("All products:");

  for (Product product in products) {
    print(product);
  }

  repository.addProduct(
    Product(3, "Keyboard", 50.0),
  );

  await Future.delayed(Duration(milliseconds: 200));

  await subscription.cancel();
  await repository.close();
}

//Ex2--------------------------

class User {
  String name;
  String email;

  User(this.name, this.email);

  User.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        email = json["email"];

  @override
  String toString() {
    return "User(name: $name, email: $email)";
  }
}

class UserRepository {
  Future<List<User>> getUsers() async {
    String jsonData = '''
    [
      {
        "name": "Dat",
        "email": "dat@example.com"
      },
      {
        "name": "An",
        "email": "an@example.com"
      },
      {
        "name": "Binh",
        "email": "binh@example.com"
      }
    ]
    ''';

    await Future.delayed(Duration(seconds: 1));

    List<dynamic> decodedData = jsonDecode(jsonData);

    return decodedData
        .map((json) => User.fromJson(json))
        .toList();
  }
}

Future<void> ex2() async {
  UserRepository repository = UserRepository();

  List<User> users = await repository.getUsers();

  print("Users:");

  for (User user in users) {
    print(user);
  }
}

// Ex3--------------------------

Future<void> ex3() async {
  print("Start");

  scheduleMicrotask(() {
    print("Microtask 1");
  });

  Future(() {
    print("Future event");
  });

  scheduleMicrotask(() {
    print("Microtask 2");
  });

  print("End");

  await Future.delayed(Duration(milliseconds: 100));

  print(
    "Explanation: Microtasks run before Future event callbacks.",
  );
}

//Ex4--------------------------

Future<void> ex4() async {
  Stream<int> numberStream =
      Stream.fromIterable([1, 2, 3, 4, 5]);

  Stream<int> squaredStream =
      numberStream.map((number) => number * number);

  Stream<int> evenSquaredStream =
      squaredStream.where((number) => number % 2 == 0);

  print("Even squared values:");

  await for (int value in evenSquaredStream) {
    print(value);
  }
}

// Ex5--------------------------
class Settings {
  static final Settings _instance = Settings._internal();

  String language = "English";

  Settings._internal();

  factory Settings() {
    return _instance;
  }
}

void ex5() {
  Settings settings1 = Settings();
  Settings settings2 = Settings();

  print("Settings 1 language: ${settings1.language}");

  settings1.language = "Vietnamese";

  print("Settings 2 language: ${settings2.language}");

  print(
    "Same object: ${identical(settings1, settings2)}",
  );
}