//TODO 1
class Vehicle {
  String brand;
  int year;
  Vehicle(this.brand, this.year);
  void startEngine() {
    print("Khởi tạo phương tiện...");
  }
}
//TODO 2
class Car extends Vehicle {
  bool isElectric;
  //TODO3
  Car(String brand, int year, this.isElectric) : super(brand, year);
  Car.tesla(int year) : isElectric = true, super("Tesla", year);
  //TODO 4
  @override
  void startEngine() {
    if (isElectric) {
      print("in ra tiếng động cơ xe điện $brand năm $year");
    } else {
      print("in ra tiếng động cơ xe xăng $brand năm $year");
    }
  }
}
void main() {
  //TODO 5
  Car car1 = Car("Toyota", 2026, false);
  car1.startEngine();
  //TODO 6
  Car car2 = Car.tesla(2024);
  car2.startEngine();
}
