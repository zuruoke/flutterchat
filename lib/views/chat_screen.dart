import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterchat/view_model/messages.dart';

class ChatScreen extends StatefulWidget {

  final String uid;
  final String currentUserUid;
  final String username;
  final String currentUsername;

  ChatScreen({
    required this.uid,
    required this.currentUserUid,
    required this.username,
    required this.currentUsername
  });



  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool canSend = false;
  bool isLoading = false;
  final TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  final CollectionReference chatRef = FirebaseFirestore.instance.collection('chats');

  

  @override
  void initState() {
    _scrollController.addListener(() { 
    });
    super.initState();
  }

  sendMessage() async {
    DocumentReference docRef1  = chatRef
               .doc(widget.currentUserUid)
               .collection('userChats')
               .doc(widget.uid)
               .collection('messages')
               .doc();
    DocumentReference docRef2  = chatRef
               .doc(widget.uid)
               .collection('userChats')
               .doc(widget.currentUserUid)
               .collection('messages')
               .doc();
    
     setState(() {
      isLoading = true;
    });
    
    await docRef1.set({
      'senderId': widget.currentUserUid,
      'recipientId': widget.uid,
      'senderUsername': widget.currentUsername,
      'recipientUsername': widget.currentUsername,
      'messageId':  docRef1.id,
      'timestamp': DateTime.now(),
      'text': _controller.text
    });

    await docRef2.set({
      'senderId': widget.currentUserUid,
      'recipientId': widget.uid,
      'senderUsername': widget.currentUsername,
      'recipientUsername': widget.currentUsername,
      'messageId':  docRef2.id,
      'timestamp': DateTime.now(),
      'text': _controller.text
    });

    setState(() {
      _controller.clear();
      isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black,)
          ),
        title: Text('Chat with ${widget.username}', style: const TextStyle(fontSize: 20, color: Colors.black)),
        
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder(
                stream: chatRef
                  .doc(widget.currentUserUid)
                  .collection('userChats')
                  .doc(widget.uid)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    List<SingleMessage> allMessages = [];
                    allMessages = snapshot.data!.docs.map((
                      QueryDocumentSnapshot doc) => SingleMessage.fromDocument(doc)).toList();
                  return allMessages.length == 0 ? 
                  Center(
                    child: TextButton.icon(
                      onPressed: () {}, 
                      icon: Icon(Icons.chat_bubble_rounded, size: 40, color: Colors.white,), 
                      label: Text(
                        'Start Conversation with ${widget.username}', 
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        )))
                  )
                  : Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemBuilder: (context, index) => allMessages[index],
                      itemCount: allMessages.length,
                      ),
                  );
                  }
                else {
                  return CircularProgressIndicator();
                }
                },
              ),
              buildSendMessage(),
            ],
          ),
          isLoading
              ? const Center(child: Text(""))
              : Container(),
        ],
      ),
    );
  }

  buildSendMessage(){
    final mq = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: mq.width * 0.75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[100],
            ),
            child: Container(
              width: mq.width * 0.62,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                   minWidth: mq.width,
                    maxWidth: mq.width,
                    minHeight: 25.0,
                    maxHeight: 135.0
                ),
                child: Scrollbar(
                  child: TextField(
                    onChanged: (String _value) {
                      if (_value.length > 0) {
                        setState(() {
                          canSend = true;
                        });
                      }
                      else {
                       setState(() {
                          canSend = false;
                        }); 
                      }
                    },
                    cursorColor: Colors.black,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    decoration: const InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                    ),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.only(
                        top: 2.0, left: 13.0, right: 13.0, bottom: 2.0),
                        hintText: "Say something...",
                        hintStyle: TextStyle(color: Colors.black)
                      ),
                    controller: _controller,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: mq.width * 0.2,
            height: mq.height * 0.06,
            child: canSend ? ElevatedButton(
              child: const Text('Send', style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500
              ),),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
                primary: Colors.blue,
              ),
              onPressed: sendMessage,
            ) : Icon(
              Icons.emoji_emotions_rounded, size: 35, color: Colors.black,)
          )
        ],
      ),
    );

  }
  
}