abstract class Employee {
  String name;
  Employee(this.name);
  void work();
}
//TODO 1
mixin CheckInAbility on Employee{
  void checkIn(){
    print("$name đã check");
  }
}
//TODO 2
class Developer extends Employee with CheckInAbility{
  Developer(String name) : super(name);
  @override
  void work(){
    print("$name đang viết code");
  }
}

void main(){
  List<Developer> teamA = [Developer("An"), Developer("Bình")];
  List<Developer> teamB = [Developer("Cường")];
  //TODO 3
  List<Developer> allStaff = [...teamA, ...teamB];
  //TODO 4
  for(var staff in allStaff){
    staff.checkIn();
  }
}
