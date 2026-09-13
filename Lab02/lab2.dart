void main() async {
//Ex1-------------------
  print("Ex1:");
  String name = 'Dat';
  int age = 22;
  double height = 1.7;
  bool pass = true;

  print("Name: $name");
  print("age: $age");
  print("Height: $height");
  print("pass: $pass");
  print("${age + 1}");
//Ex2-------------------
  print("Ex2:");
  List<int> numbers = [10, 20, 30, 40];

  print("Original list: $numbers");

  print("First number: ${numbers[0]}");

  numbers.add(50);
  print("After add 50: $numbers");

  numbers.remove(20);
  print("After remove 20: $numbers");

  int a = 10;
  int b = 5;

  print("a + b = ${a + b}");
  print("a - b = ${a - b}");

  print("a == b: ${a == b}");

  print("a > 5 && b < 10: ${a > 5 && b < 10}");

  String result = a > b ? "a is greater" : "b is greater";
  print(result);

  Set<int> numberSet = {1, 2, 2, 3, 4};
  print("Set: $numberSet");

  numberSet.add(5);
  numberSet.remove(1);
  print("Updated set: $numberSet");

  Map<String, int> scores = {
    "Math": 90,
    "English": 80,
    "Dart": 95,
  };

  print("Dart score: ${scores["Dart"]}");
  scores["Flutter"] = 100;
  print("Updated map: $scores");
// Ex3--------------------
  print("Ex3:");
  int score = 85;

  if (score >= 90) {
    print("Grade A");
  } else if (score >= 80) {
    print("Grade B");
  } else if (score >= 70) {
    print("Grade C");
  } else {
    print("Grade F");
  }

  int day = 2;

  switch (day) {
    case 1:
      print("Monday");
      break;
    case 2:
      print("Tuesday");
      break;
    case 3:
      print("Wednesday");
      break;
    default:
      print("Other day");
  }

  List<String> fruits = ["Apple", "Banana", "Orange"];

  print("For loop:");
  for (int i = 0; i < fruits.length; i++) {
    print(fruits[i]);
  }

  print("For-in loop:");
  for (String fruit in fruits) {
    print(fruit);
  }

  print("forEach:");
  fruits.forEach((fruit) {
    print(fruit);
  });

  print("10 + 5 = ${add(10, 5)}");

  print("10 * 5 = ${multiply(10, 5)}");
//Ex4---------------------
  print("Ex4:");
  Car car1 = Car("Toyota");
  car1.showInfo();
  car1.drive();

  Car car2 = Car.defaultCar();
  car2.showInfo();
  car2.drive();

  ElectricCar electricCar = ElectricCar("Tesla");
  electricCar.showInfo();
  electricCar.drive();
  //Ex5-------------------------
  print("Ex5:");
  print("Start loading...");

  String data = await loadData();
  print(data);

  String? nullableName;

  print(nullableName ?? "Name is null");

  nullableName = "Dat";

  print("Name length: ${nullableName?.length}");

  String notNullName = nullableName!;
  print("Name: $notNullName");

  print("Stream values:");

  await for (int number in numberStream()) {
    print(number);
  }
}

Future<String> loadData() async {
  await Future.delayed(Duration(seconds: 2));

  return "Data loaded successfully";
}

// Stream sends numbers one by one
Stream<int> numberStream() async* {
  for (int i = 1; i <= 5; i++) {
    await Future.delayed(Duration(milliseconds: 500));
    yield i;
  }
}

class Car {
  String brand;

  Car(this.brand);

  Car.defaultCar() : brand = "Unknown";

  void showInfo() {
    print("Car brand: $brand");
  }

  void drive() {
    print("$brand car is driving");
  }

}

class ElectricCar extends Car {
  ElectricCar(String brand) : super(brand);

  @override
  void drive() {
    print("$brand electric car is driving silently");
  }

}

int add(int a, int b) {
  return a + b;
}

int multiply(int a, int b) => a * b;
