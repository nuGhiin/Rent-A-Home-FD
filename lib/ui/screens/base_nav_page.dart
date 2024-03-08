import 'package:flutter/material.dart';
import 'package:rent_a_home/ui/screens/faq_page.dart';
import 'package:rent_a_home/ui/screens/home_page.dart';
import 'package:rent_a_home/ui/screens/post_ad.dart';
import 'package:rent_a_home/ui/screens/profile_page.dart';
import 'package:rent_a_home/ui/screens/short_list.dart';

class BaseNavPage extends StatefulWidget {
  const BaseNavPage({super.key});

  @override
  State<BaseNavPage> createState() => _BaseNavPageState();
}

class _BaseNavPageState extends State<BaseNavPage> {
  int _currentIndex = 0;
  List<Widget> pages = [
    const HomePage(),
    const FaqPage(),
    const ShortListPage(),
    const ProfilePage(),


  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading:  const Image(
          image: AssetImage("assets/img/logo.png"),
          color: Colors.white,
        ),
      ),


      // AppBar(
      //   backgroundColor: Colors.deepPurple,
      //   elevation: 0,
      //   title: Row(
      //     children: [
      //       const Image(
      //         image: AssetImage("assets/img/logo.png"),
      //         color: Colors.white,
      //         height: 50, // Adjust the height as needed
      //       ),
      //       const SizedBox(width: 5),
      //       Text(
      //         "Rent A Home",
      //         style: TextStyle(
      //           color: Colors.white,
      //           fontSize: 20, // Adjust the font size as needed
      //         ),
      //       ),
      //     ],
      //   ),
      // ),


      body: pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index){
          _currentIndex = index;
          setState(() {

          });
        },

        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        elevation: 4,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_filled,
              ),

              label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.question_mark,
              ),
              label: 'FAQ'),

          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite_border,
              ),
              label: 'ShortList'),

          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: 'Profile'),
        ],

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const PostAdPage(),));
        },
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.miniCenterDocked,
    );
  }
  onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
