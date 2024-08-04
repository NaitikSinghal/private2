import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final XFile? file;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Column(
      children: [
        const Expanded(child: Text('center')),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              FormHelper.submitButton(
                'Add Photo',
                () {
                  showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      backgroundColor: HexColor('#ffffff'),
                      builder: (BuildContext context) {
                        return bottomSheet(context);
                      });
                },
                width: deviceSize.width,
                btnColor: HexColor('#f58b26'),
                borderColor: HexColor('#f58b26'),
                txtColor: Colors.white,
                borderRadius: 25,
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(text: "Made By Gopi Chand"),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Future pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    file = await picker.pickImage(source: ImageSource.gallery);
  }

  Future takeImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    file = await picker.pickImage(source: ImageSource.camera);
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                pickImageFromGallery();
              },
              icon: const Icon(Icons.image),
              label: const Text('Browse Gallery'),
              style: ElevatedButton.styleFrom(
                backgroundColor: HexColor('#f58b26'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 15.0,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: const Text(
              'OR',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                takeImageFromCamera();
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Open Camera'),
              style: ElevatedButton.styleFrom(
                backgroundColor: HexColor('#f58b26'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
