
import 'package:flutter/material.dart';
import 'package:lista/app/view/components/h1.dart';
import 'package:lista/app/view/task_list/task_list_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  @override
  Widget build(BuildContext context) {
  return Scaffold(
   body: Column(
    children: [
      Column(
      children: [
          const SizedBox(height: 150),
          Image.asset(
          'assets/images/21.png',
          width: 250,
          height: 250,
    ),
          const SizedBox(height: 50),
          const H1('WELCOME', color: Colors.black87),
          const SizedBox(height: 20),
        GestureDetector(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
    return const TaskListPage();

            }));
            },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: H1(
              'Your Productivity Hub: Organize, Prioritize, and Conquer Your Tasks Today!',
          ),
        ),
    ),
    ]),
    ]),
    );
  }
}


//<a href="https://www.flaticon.com/free-icons/things-to-do" title="things to do icons">Things to do icons created by Freepik - Flaticon</a>





