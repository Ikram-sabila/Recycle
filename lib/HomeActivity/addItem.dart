import 'package:flutter/material.dart';
import 'package:project/Firebase/firebase_config.dart';
import 'package:project/Services/item_services.dart';

class AddItem extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController recycleController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController groupController = TextEditingController();

  final ItemService _itemService = ItemService();

  void addItem(String nama, String grup, String image, String descripsi, String recycle) {
    _itemService.addItem(
        name: nama,
        description: descripsi,
        group: grup,
        image: image,
        recycle: recycle
    );
  }

  Widget input(String judul, String input, TextEditingController controller, int format) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(judul),
        const SizedBox(height: 5,),
        if(format == 1)
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: input,
            ),
          ),
        if(format == 2)
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: input,
            ),
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
        const SizedBox(height: 10,),
      ],
    );
  }

  Widget _buttonAdd () {
    return SizedBox(
      width: double.infinity,

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            )
        ),
        onPressed: (){
          String nama = nameController.text;
          String grup = groupController.text;
          String image = imageController.text;
          String deskripsi = descController.text;
          String recycle = recycleController.text;

          addItem(nama, grup, image, deskripsi, recycle);

          nameController.clear();
          groupController.clear();
          imageController.clear();
          descController.clear();
          recycleController.clear();
        },
        child: const Text(
          "Add",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Item"),
      ),
      body: Container(
        margin: EdgeInsets.all(23),
        child: Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: [
                input("Nama Item", "item", nameController, 1),
                input("Nama grup", "Group", groupController, 1),
                input("Gambar", "Link Gambar", imageController, 1),
                input("Descripsi", "isi deskripsi", descController, 2),
                input("Recycle", "Isi cara daur ulang", recycleController, 2),
                _buttonAdd()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
