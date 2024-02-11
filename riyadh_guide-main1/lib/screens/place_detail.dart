import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riyadh_guide/screens/account.dart';
import 'package:riyadh_guide/screens/favourites.dart';
import 'package:riyadh_guide/screens/news.dart';
import 'package:riyadh_guide/screens/search.dart';
import 'package:riyadh_guide/screens/Comment.dart';
import 'package:riyadh_guide/screens/welcome_screen.dart';
import 'package:riyadh_guide/widgets/app_icon.dart';
import 'package:riyadh_guide/widgets/icon_and_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlaceDetails extends StatefulWidget {
  final String placeID;

  const PlaceDetails({Key? key, required this.placeID}) : super(key: key);

  @override
  _PlaceDetailsState createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  int currentTab = 0;

  late DocumentSnapshot? placeData;
  List<String> imageUrls = [];

  String categoryName = '';
  String categoryNameInarabic = '';

  @override
  void initState() {
    super.initState();
    _fetchPlaceData();
    CommentPage(
      placeID: ' ${widget.placeID}',
    );
    placeData = null;
  }

  Future<void> _fetchPlaceData() async {
    // Fetch place data from Firebase Firestore based on the placeID
    final placeDocument = await FirebaseFirestore.instance
        .collection('place')
        .doc(widget.placeID)
        .get();

    setState(() {
      placeData = placeDocument;
      imageUrls = List<String>.from(placeData?['images'] ?? []);
    });

    // Fetch the category name based on categoryID
    final categoryID = placeData?['categoryID'] ?? '';
    final categoryDocument = await FirebaseFirestore.instance
        .collection('category')
        .doc(categoryID)
        .get();

    // Set the categoryName
    setState(() {
      categoryName = categoryDocument['name'];
    });

    if (categoryName == "coffee") {
      categoryNameInarabic = 'مقهى';
    } else if (categoryName == "restaurant") {
      categoryNameInarabic = 'مطعم';
    } else if (categoryName == "shopping") {
      categoryNameInarabic = 'تسوق';
    } else if (categoryName == "beauty") {
      categoryNameInarabic = 'تجميل';
    } else if (categoryName == "entertainment") {
      categoryNameInarabic = 'ترفيه';
    } else {
      categoryNameInarabic = 'سياحة';
    }
  }

  Future<void> _launchUrl() async {
    final Uri _url = Uri.parse(placeData?['website']);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(placeData?['name'] ?? ''),
          backgroundColor: Color.fromARGB(255, 211, 198, 226)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentTab = 0;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WelcomeScreen(),
              ),
            );
          });
        },
        child: Image.asset(
          'lib/icons/Logo.png',
        ),
        backgroundColor: Color.fromARGB(157, 165, 138, 182),
        elevation: 20.0,
        //mini: true,
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 10,
        shape: CircularNotchedRectangle(),
        color: Color.fromARGB(157, 217, 197, 230),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10.0, left: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.account_box),
                    onPressed: () {
                      setState(() {
                        currentTab = 1;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => account(),
                          ),
                        );
                      });
                    },
                    color: currentTab == 1 ? Colors.white : Colors.black,
                  ),
                  Text(
                    "حسابي",
                    style: TextStyle(
                        color: currentTab == 1 ? Colors.white : Colors.black),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        currentTab = 2;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => search(),
                          ),
                        );
                      });
                    },
                    color: currentTab == 2 ? Colors.white : Colors.black,
                  ),
                  Text(
                    "البحث",
                    style: TextStyle(
                        color: currentTab == 2 ? Colors.white : Colors.black),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.newspaper),
                    onPressed: () {
                      setState(() {
                        currentTab = 3;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => news(),
                          ),
                        );
                      });
                    },
                    color: currentTab == 3 ? Colors.white : Colors.black,
                  ),
                  Text(
                    "أحداث اليوم",
                    style: TextStyle(
                        color: currentTab == 3 ? Colors.white : Colors.black),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite),
                    onPressed: () {
                      setState(() {
                        currentTab = 4;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => favourites(),
                          ),
                        );
                      });
                    },
                    color: currentTab == 4 ? Colors.white : Colors.black,
                  ),
                  Text(
                    "المفضلة",
                    style: TextStyle(
                        color: currentTab == 4 ? Colors.white : Colors.black),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                height: 350,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 250,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    enableInfiniteScroll: true,
                  ),
                  items: imageUrls
                      .map((url) => ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
            Positioned(
              top: 45,
              left: 20,
              child: AppIcon(icon: Icons.favorite),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 330, // Image dimension
              child: Container(
                padding: const EdgeInsets.only(left: 9, right: 9, top: 9),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        placeData?['name'] ?? '',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Text("4.5"),
                          SizedBox(width: 10),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Image.asset(
                            'lib/icons/c.jpeg',
                            width: 25,
                            height: 25,
                          ),
                          SizedBox(width: 4),
                          Text(categoryNameInarabic),
                          SizedBox(width: 20),
                          IconAndTextWidget(
                            icon: Icons.access_time_rounded,
                            text: placeData?['opening_hours'] ?? '',
                            iconColor: Colors.pinkAccent,
                          ),
                        ],
                      ),
                      Text(
                        "الوصف",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(placeData?['description'] ?? ''),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          const Text(
                            " للتواصل ولمزيد من المعلومات يرجى زيارة",
                            style: TextStyle(
                              color: Color.fromARGB(200, 83, 56, 97),
                              fontSize: 15,
                            ),
                          ),
                          GestureDetector(
                            onTap: _launchUrl,
                            child: const Text(
                              " موقعهم من هنا ",
                              style: TextStyle(
                                color: Color.fromARGB(255, 83, 56, 97),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      CommentPage(
                        placeID: ' ${widget.placeID}',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //CommentPage(),
          ],
        ),
      ),
    );
  }
}

//Final code
/*
class CommentPage extends StatefulWidget {
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController _commentController = TextEditingController();
  static const String _defaultProfileImage = 'lib/icons/bg.jpg';
  List<String> _comments = [];

  void _addComment() {
    String comment = _commentController.text;
    setState(() {
      _comments.add(comment);
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height, // Set a specific height
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color.fromARGB(
              255,
              222,
              217,
              217,
            ), // Set the background color to gray
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'اضافة تعليق',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextButton(
                  child: Text(
                    'ارسل',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
          Divider(),
          if (_comments.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  String comment = _comments[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(_defaultProfileImage),
                    ),
                    title: Text(
                      comment,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          if (_comments.isEmpty)
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height -
                    450, // Adjust the height as per your need
                child: Center(
                  child: Text(
                    'لا يوجد تعليقات ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
*/
//Before edit
/*
class CommentPage extends StatefulWidget {
  final String placeID;

  CommentPage({required this.placeID});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController _commentController = TextEditingController();
  static const String _defaultProfileImage = 'lib/icons/bg.jpg';
  List<String> _comments = [];

  @override
  void initState() {
    super.initState();
    // Fetch comments for the place and update the _comments list
    fetchComments();
  }

  void fetchComments() {
    String placeId = widget.placeID; // Replace with the actual place ID

    // Get a reference to the Firestore collection
    CollectionReference commentsCollection =
        FirebaseFirestore.instance.collection('comments');

    // Query the comments for the specific place ID
    commentsCollection
        .where('placeId', isEqualTo: placeId)
        .get()
        .then((QuerySnapshot snapshot) {
      List<String> comments = [];
      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        comments.add(data['comment'] as String);
      });
      setState(() {
        _comments = comments;
      });
    }).catchError((error) {
      print('Failed to fetch comments: $error');
    });
  }

  String getCurrentUserId() {
    String currentUserId = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      currentUserId = user.uid;
    }

    return currentUserId;
  }

  void _addComment() {
    String comment = _commentController.text;
    setState(() {
      _comments.add(comment);
      _commentController.clear();
    });

    // Store the comment in the database
    addComment(comment);
  }

  void addComment(String comment) {
    String userId = getCurrentUserId(); // Replace with the actual user ID
    String placeId = widget.placeID; // Replace with the actual place ID

    // Get a reference to the Firestore collection
    CollectionReference commentsCollection =
        FirebaseFirestore.instance.collection('comments');

    // Create a new document in the comments collection
    commentsCollection.add({
      'comment': comment,
      'userId': userId,
      'placeId': placeId,
    }).then((value) {
      showSnackBar('Comment added successfully!');
    }).catchError((error) {
      showSnackBar('Failed to add comment');
    });
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height, // Set a specific height
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color.fromARGB(
              255,
              222,
              217,
              217,
            ), // Set the background color to gray
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'اضافة تعليق',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextButton(
                  child: Text(
                    'ارسل',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
          Divider(),
          if (_comments.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  String comment = _comments[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(_defaultProfileImage),
                    ),
                    title: Text(
                      comment,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          if (_comments.isEmpty)
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height -
                    150, // Adjust the height as per your need
                child: Center(
                  child: Text(
                    'No comments',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
*/