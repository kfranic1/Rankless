import 'Employee.dart';
import 'Post.dart';

class Company {
  String uid;
  String name;
  String industry;
  //SLIKA
  String description;
  List<Employee> employees;
  //List<Survey> surveys;
  List<Post> posts;

  Company(this.uid, {this.name, this.industry, this.employees});

  Future<void> createData() async {}
  Future<void> getData() async {}
  Future<void> changeData() async {}
}
