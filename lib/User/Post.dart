import 'Company.dart';
import 'Employee.dart';

class Post {
  String body;
  TIP type;
  Employee writer;
  Company company;
  int id;
  DateTime date;
  List<Employee> upvotes;
  List<Employee> downvotes;

  Post(this.body, this.type, this.writer, this.company) {
    id = company.posts.length + 1;
    this.upvotes.add(writer);
  }

  Future<void> addReaction(Employee reactor, bool positive) async {
    if (positive) {
      if (downvotes.contains(reactor)) {
        downvotes.remove(reactor);
        //FIREBASE
      }
      upvotes.add(reactor);
      //TOOD salji na firebase
    } else {
      if (upvotes.contains(reactor)) {
        upvotes.remove(reactor);
        //FIREBASE
      }
      downvotes.add(reactor);
      //FIREBASE
    }
  }

  Future<void> newPost() async {
    //SALJI NA FIREBASE
  }

  Future<void> removePost() async {
    //MICI S FIREBASEA
  }
}

enum TIP { Comment, Suggestion, Critics }
