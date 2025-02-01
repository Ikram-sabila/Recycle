import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:project/HomeActivity/addItem.dart';
import 'detailItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/LoginActivity/auth.dart';
import 'package:project/ProfileActivity/profile.dart' as profile_page;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final User? user = Auth().currentUser;
  final ref = FirebaseDatabase.instance.ref('Items');

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  // Widget _signOutButton() {
  //   return ElevatedButton(
  //     onPressed: signOut,
  //     child: const Text("Sign Out"),
  //   );
  // }

  List<Widget> cards = [];


  void showItem(String name) async {
    try {
      final items = await fetchData(name);
      setState(() {
        cards.clear();
        for (var item in items){
          final imageUrl = item['Image'] != null ? item['Image'].toString() : "default_image_url";
          final itemName = item['name'] != null ? item['name'].toString() : "No Name";
          cards.add(createCard(NetworkImage(imageUrl), itemName));
        }
      });
    } catch (e) {
      print("Error data $e");
    }
  }

  Future<List<Map<dynamic, dynamic>>> fetchData(String group) async {
    try {
      final snapshot = await ref.get();
      if (snapshot.exists) {
        final items = snapshot.value as Map<dynamic, dynamic>;
        final result = <Map<dynamic, dynamic>>[];
        for (var key in items.keys) {
          final item = items[key] as Map<dynamic, dynamic>;
          if (item['Group']?.toString() == group) {
            result.add(item);
          }
        }
        return result;
      } else {
        print("No data found");
      }
    } catch (error) {
      print("Terjadi kesalahan: $error");
    }
    return [];
  }

  Future<String> userName(String uid) async {
    try {
      final ref2 = FirebaseDatabase.instance.ref('users/$uid');
      final snapshot = await ref2.get();
      if (snapshot.exists) {
        final userData = snapshot.value as Map<dynamic, dynamic>;
        return userData['name']  ?? 'Nama tidak tersedia';
      } else {
        print("Data user tidak ditemukan.");
      }
    } catch (error) {
      print("Terjadi kesalahan: $error");
    }
    return 'Nama tidak tersedia';
  }

  void detailItems(String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailItem(name: name),
      ),
    );
  }

  Widget buildCard(IconData icon, String text, Color color) {
    return Card(
      child: GestureDetector(
        onTap: () => showItem(text),
        child: Container(
          width: 163,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto'
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createCard(ImageProvider image, String text) {
    return Card(
      color: const Color(0xFFFEFAF6),
      child: GestureDetector(
        onTap: () => detailItems(text),
        child: Container(
          width: 75,
          height: 100,
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start, 
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)
                ),
                child: Image(
                  image: image,
                  width: double.infinity,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget newCard(IconData icon, String text, Color color) {
    return Card(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context){
                    return AddItem();
                  }
              )
          );
        },
        child: Container(
          width: 163,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                text,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Roboto'
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget makeCard(ImageProvider image, String text) {
  //   return Card(
  //     child: GestureDetector(
  //       onTap: () => detailItems(text),
  //       child: Container(
  //         width: 150,
  //         height: 70,
  //         padding: const EdgeInsets.all(10),
  //         child: Row(
  //           children: [
  //             Image(
  //               image: image,
  //               width: 50,
  //               height: 50,
  //             ),
  //             const SizedBox(width: 10),
  //             Text(
  //               text,
  //               style: const TextStyle(
  //                 fontFamily: 'Roboto'
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Hello $userName($user)"),
        title: FutureBuilder(
            future: userName(user!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading...");
              } else if (snapshot.hasError) {
                return const Text("Error");
              } else if (!snapshot.hasData || snapshot.data == 'Nama tidak tersedia') {
                return const Text("Hello, Guest");
              } else {
                return Container(
                  padding: EdgeInsets.all(13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, ${snapshot.data}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          fontSize: 15
                        ),
                      ),
                      const Text(
                        "Welcome to Recycle",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 13
                        ),
                      )
                    ]
                  ),
                );
              }
            }
        ),
        backgroundColor: const Color(0xFF42b29e),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(),
                    );
                  },
                  icon: const Icon(Icons.search),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => profile_page.Profile(),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://img.freepik.com/free-vector/smiling-young-man-illustration_1308-174401.jpg?semt=ais_hybrid"
                    ),
                    radius: 15,
                  ),
                ),
              ]
            ),
          )
        ],
      ),
      body: 
      Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40)
                )
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            height: 680,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    buildCard(Icons.recycling, 'Recycle', Color(0xFFF14369)),
                    buildCard(Icons.energy_savings_leaf, 'Reduce', Color(0xFF4F4ADB)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildCard(Icons.compost, 'Compost', Color(0xFF4de4e1)),
                    newCard(Icons.add, "Add", Colors.lightGreenAccent)
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Things',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto'
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              ...cards,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 1,
                  height: 20,
                ),
                const Text(
                  "Popular Items",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto'
                  ),
                ),
                const SizedBox(height: 5,),
                Expanded(
                  child: FirebaseAnimatedList(
                      query: ref,
                      itemBuilder: (context, snapshot, animation, index) {
                        String name = snapshot.child('name').value.toString();
                        return Card(
                          color: const Color(0xFFFEFAF6),
                          child: GestureDetector(
                            onTap: () => detailItems(name),
                            child: Container(
                              width: 150,
                              height: 60,
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius:  const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        topLeft: Radius.circular(10)
                                      ),
                                      child: Image.network(
                                        snapshot.child('Image').value.toString(),
                                        width: 70,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        snapshot.child('name').value.toString(),
                                        style: const TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                            ),
                          ),
                        );
                      }
                  ),
                  // child: Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: <Widget>[
                  //     const Text(
                  //       'Popular Items',
                  //       style: TextStyle(
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //     const SizedBox(height: 10),
                  //     Expanded(
                  //       child: ListView(
                  //         children: [
                  //           makeCard(
                  //             const NetworkImage(
                  //               "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBITZ3Uhe1BNDVtKJcjWm5-TD_5SNQlmSegA&s",
                  //             ),
                  //             "Food Waste",
                  //           ),
                  //           makeCard(
                  //             const NetworkImage(
                  //               "https://indianalymeconnect.org/wp-content/uploads/2018/05/prevention-create-tick-safe-environment-firewood-away-from-lawn-01-640x427.jpg",
                  //             ),
                  //             "Wood Pile",
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  Future<List<String>> getItems() async {
    final databaseRef = FirebaseDatabase.instance.ref('Items');
    final snapshot = await databaseRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return data.values.map((child) => (child as Map<dynamic, dynamic>)['name'].toString()).toList();
    } else {
      return [];
    }
  }

  void detailItems(BuildContext context, String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailItem(name: name),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No items found'));
        }

        final matchQuery = snapshot.data!
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return ListView.builder(
          itemCount: matchQuery.length,
          itemBuilder: (context, index) {
            var result = matchQuery[index];
            return ListTile(
              title: Text(result),
              onTap: () {
                close(context, result);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No suggestions found'));
        }

        final matchQuery = snapshot.data!
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return ListView.builder(
          itemCount: matchQuery.length,
          itemBuilder: (context, index) {
            var result = matchQuery[index];
            return ListTile(
              title: Text(result),
              onTap: () {
                query = result;
                showResults(context);
                detailItems(context, result);
              },
            );
          },
        );
      },
    );
  }
}
