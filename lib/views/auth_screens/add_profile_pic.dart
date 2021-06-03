import 'package:flutterchat/utils/save_to_firebase_storage.dart';
import 'package:flutterchat/views/homepage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddProfilePicScreen extends StatefulWidget{
  final String? name;

  AddProfilePicScreen({@required this.name});

  _AddProfilePicScreenState createState() => _AddProfilePicScreenState();
}

class _AddProfilePicScreenState extends State<AddProfilePicScreen> {
  late String _uid;
  PickedFile? pickedImage;
  final picker = ImagePicker();

  Future captureImageFromCamera() async {
    Navigator.of(context).pop();
    final PickedFile? imageFile = await picker.getImage(source: ImageSource.camera);
    if (imageFile != null) {
    setState(() {
      pickedImage = imageFile;
    });
  }
    }

  Future pickImageFromGallery() async {
    Navigator.of(context).pop();
    final PickedFile? imageFile = await picker.getImage(source: ImageSource.gallery);
    if (imageFile != null) {
    setState(() {
      pickedImage = imageFile;
    });
    }
  }

  getUserCachedId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _uid =  _prefs.getString('userId')!;      
    });
  }

  @override
  void initState() { 
   getUserCachedId();
    super.initState();
    
  }
  contentScreen(){
    Size mq = MediaQuery.of(context).size;
    return Column(
      children: [
      Padding(
        padding: EdgeInsets.only(left: 0.40 * mq.width, right: 0.40 * mq.width, bottom: 20),
        child: Container(
          width: 0.2 * mq.width, height: 80,
          decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
            border: Border.all(
              width: 2,
              color: Colors.black
            )
          ),
    ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 0.35 * mq.width, right: 0.35 * mq.width, bottom: 20),
          child: Text("Add a Profile Photo", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        Padding(
          padding: EdgeInsets.only(left: 0.1 * mq.width, right: 0.1 * mq.width, bottom: 5),
            child: Text("Add a profile photo so your friends know it's", style: TextStyle(color: Colors.grey),),
          ),
          Padding(
          padding: EdgeInsets.only(left: 0.4 * mq.width, right: 0.4 * mq.width, bottom: 20),
            child: Text("you.", style: TextStyle(color: Colors.grey),),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0.10 * mq.width, right: 0.10 * mq.width, bottom: 20),
            child: Container(
              width: 0.6 * mq.width,
              child: TextButton(
         onPressed: (){
           showModalBottomSheet(
             context: context,
             backgroundColor: const Color.fromRGBO(255, 255, 255 , 1),
             shape: RoundedRectangleBorder( 
              borderRadius: const BorderRadius.all(
              Radius.circular(20),),),
             builder: (context) => buildBottomModalSheet(mq.height * 0.25));
         },
         style: TextButton.styleFrom(
           backgroundColor: Colors.blue,
           shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),),
         ),
         child: Text("Next", style: TextStyle(color: Colors.white),)
         ),
            ),
            ),
          TextButton(
            onPressed: (){
              uploadImageUrl(_uid, '');
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => HomePage(uid: _uid,)));
            },
             style: TextButton.styleFrom(
           backgroundColor: Colors.white,), 
            child: Text("Skip", style: TextStyle(color: Colors.blue),)
            ),
       ] 
       );
  }

  updateUrl() async {
    String url = await uploadImageToFirebaseStorage(id: _uid, img: pickedImage!, folder: 'ProfilePictures');
    uploadImageUrl(_uid, url);
  }

  updateUrlAndNavigate() {
    updateUrl();
    return HomePage(uid: _uid,);
  }

  buildBottomModalSheet(double height) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: height,
      child: Column(
      children: <Widget>[
         GestureDetector(
           onTap: pickImageFromGallery,
           child: ListTile(
            leading: Text('Take Photo'),
            trailing: const Icon(
                  Icons.camera_alt,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
          ),
          Divider(),
          GestureDetector(
            onTap: captureImageFromCamera,
            child: ListTile( 
            leading: Text("Photo Library"),
            trailing: const Icon(
                  Icons.filter_none_outlined,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
          ),
          Divider(),
           GestureDetector(
             child: ListTile(
            leading: Text('Browse'),
            trailing: const Icon(
                Icons.linear_scale_sharp, color: Colors.blue, size: 30,),
            ),),
        ],
          ),);
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return pickedImage == null ? Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 1,
        centerTitle: true,
        title: Text('FlutterChat', 
              style:
              TextStyle(
                fontSize: 35, fontStyle: FontStyle.italic, color: Colors.black
              )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),
            Text('Welcome ${widget.name}', style: TextStyle(fontSize: 20,)),
            SizedBox(height: 0.25 * mq.height,),
            Container(child: contentScreen(),),
            SizedBox(height: 0.25 * mq.height,),
          ],
      ),),
    ) : updateUrlAndNavigate();
  }

  
}