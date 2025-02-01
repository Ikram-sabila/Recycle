import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class DetailItem extends StatelessWidget {
  final String name;
  DetailItem({super.key, required this.name});
  final ref = FirebaseDatabase.instance.ref('Items');

  Future<Map<dynamic, dynamic>> fetchData(String name) async {
    try {
      final snapshot = await ref.get();

      if (snapshot.exists) {
        final items = snapshot.value as Map<dynamic, dynamic>;
        for (var key in items.keys) {
          if (items[key]['name'].toString() == name) {
            return items[key];
          }
        }
      }
    } catch (error) {
      print("Terjadi kesalahan: $error");
    }
    return {};
  }

  Widget makeCard(String judul, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 90,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFDAC0A3),
          ),
          child: const Image(
            image: NetworkImage("https://cdn-icons-png.flaticon.com/512/4238/4238344.png"),
            width: 40,
            height: 60,
          ),
        ),
        const SizedBox(width: 5),
        Container(
          width: 0.8,
          height: 90,
          color: Colors.black,
        ),
        const SizedBox(width: 5),
        // const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFDAC0A3)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 5),
                ReadMoreText(
                  text,
                  style: const TextStyle(
                      fontFamily: 'Robot'
                  ),
                  trimMode: TrimMode.Line,
                  trimLines: 2,
                  colorClickableText: Colors.pink,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: 'Show less',
                  moreStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Item"),
      ),
      body: FutureBuilder<Map<dynamic, dynamic>>(
        future: fetchData(this.name),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Item tidak ditemukan"));
          } else {
            final items = snapshot.data!;
            final imageUrl = items['Image'] != null ? items['Image'].toString() : "default_image_url";
            final itemName = items['name'] != null ? items['name'].toString() : "No Name";
            final itemCategory = items['Group'] != null ? items['Group'].toString() : "No Category";
            final description = items['Description'] != null ? items['Description'].toString() : "No Description";

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Image(
                        image: NetworkImage(imageUrl),
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  itemName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto',
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white
                                  ),
                                  child: Text(
                                    itemCategory,
                                    style: const TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                // Card(
                                //   color: Colors.white,
                                //   child: Padding(
                                //     padding: EdgeInsets.all(5),
                                //     child: Text(
                                //       itemCategory,
                                //       style: const TextStyle(
                                //         fontSize: 8,
                                //       ),
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          )
                      )
                    ]
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      description,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontFamily: 'Roboto'
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: makeCard(
                      "Recycle",
                      items['Recycle'] != null ? items['Recycle'].toString() : "No Recycling Info",
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}


// FirebaseAnimatedList(
      //   query: ref,
      //   itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
      //     return SingleChildScrollView(
      //       child: Container(
      //         padding: const EdgeInsets.symmetric(horizontal: 28.0),
      //         child: Column(
      //           children: <Widget>[
      //             const Image(
      //               image: NetworkImage(
      //                 "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBITZ3Uhe1BNDVtKJcjWm5-TD_5SNQlmSegA&s",
      //               ),
      //               width: double.infinity,
      //               height: 200,
      //               fit: BoxFit.cover,
      //             ),
      //             const SizedBox(height: 15,),
      //             const Text(
      //               "Food Waste",
      //               style: TextStyle(
      //                 fontSize: 18,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //             const Text(
      //               "Food waste adalah pembuangan makanan layak konsumsi di sepanjang rantai pasokan, mulai dari produksi hingga konsumsi. Ini menyebabkan pemborosan sumber daya, emisi gas rumah kaca, dan hilangnya peluang memberi makan yang membutuhkan. Penanganannya memerlukan kesadaran dan tindakan bersama, seperti konsumsi bijak dan distribusi efisien.",
      //               textAlign: TextAlign.justify,
      //             ),
      //             const SizedBox(height: 15,),
      //             makeCard(
      //                 "Recycle",
      //                 "Recycling food waste dilakukan dengan mengubahnya menjadi kompos, bioenergi, atau pakan ternak. Proses ini melibatkan pengumpulan sisa makanan, pemilahan untuk memastikan tidak ada kontaminasi, lalu diolah menggunakan metode seperti pengomposan, fermentasi, atau biodigester untuk menghasilkan produk yang bermanfaat."
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),
