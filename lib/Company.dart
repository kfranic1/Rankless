import 'Employee.dart';
import 'Post.dart';

class Company {
  String name;
  String industry;
  //SLIKA
  String description;
  List<Employee> employees;
  //List<Survey> surveys;
  List<Post> posts;

  Company(this.name, this.industry, this.employees);

  Future<void> createData() async {}
  Future<void> getData() async {}
  Future<void> changeData() async {}
}
