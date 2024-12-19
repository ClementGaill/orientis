// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:orienty/Widgets/Frontend/colors.dart';
import 'package:orienty/Widgets/Frontend/textField.dart';

class GroupChatsPage extends StatefulWidget {
  const GroupChatsPage({super.key});

  @override
  _GroupChatsPageState createState() => _GroupChatsPageState();
}

class _GroupChatsPageState extends State<GroupChatsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fonction pour créer un nouveau chat
  Future<void> _createChat() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController iconController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Créer un nouveau chat'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Nom du chat'),
              ),
              TextField(
                controller: iconController,
                decoration: const InputDecoration(hintText: 'Icône (1 caractère)'),
                maxLength: 1,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty && iconController.text.isNotEmpty) {
                  await _firestore.collection('Chats').doc(nameController.text).set({
                    'icon': iconController.text,
                    'name': nameController.text,
                  });
                  print('Requête envoyée : Création d\'un chat');
                  Navigator.pop(context);
                }
              },
              child: const Text('Créer'),
            ),
          ],
        );
      },
    );
  }

  // Affiche la liste des chats
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats de Groupe'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            onPressed: _createChat,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _firestore.collection('Chats').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          print('Requête envoyée : Lecture des chats');

          final chats = snapshot.data!.docs;
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(chat['icon']),
                ),
                title: Text(chat['name']),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(chatId: chat.id, chatName: chat['name'], chatIcon: chat['icon'],),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class ChatPage extends StatefulWidget {
  final String chatId;
  final String chatName;
  final String chatIcon;

  const ChatPage({super.key, required this.chatId, required this.chatIcon, required this.chatName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  final String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';
  final ScrollController _scrollController = ScrollController();

  List<DocumentSnapshot> oldMessages = [];
  bool isLoadingMore = false;
  bool hasMoreMessages = true;
  int messageLimit = 60;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _onMenuItemSelected(int value) {
    print("Option sélectionnée : $value");
  }

  Future<void> _loadMoreMessages() async {
    if (!hasMoreMessages || isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    final lastMessage = oldMessages.isNotEmpty ? oldMessages.last : null;

    final query = _firestore
        .collection('Chats')
        .doc(widget.chatId)
        .collection('Chat')
        .orderBy('timestamp', descending: true)
        .limit(messageLimit);

    final paginatedQuery = lastMessage != null
        ? query.startAfterDocument(lastMessage)
        : query;

    final querySnapshot = await paginatedQuery.get();

    setState(() {
      oldMessages.addAll(querySnapshot.docs);
      isLoadingMore = false;
      hasMoreMessages = querySnapshot.docs.length == messageLimit;
    });

    print("Requête envoyée : Chargement des anciens messages");
  }

  Future<void> _sendMessage(String message) async {
    if (message.isNotEmpty) {
      await _firestore
          .collection('Chats')
          .doc(widget.chatId)
          .collection('Chat')
          .add({
        'uid': currentUserUid,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Requête envoyée : Envoi d\'un message');
    }
  }

  void _handleScroll() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels == 0 &&
        hasMoreMessages) {
      _loadMoreMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 45,
        title: Row(
          children: [
            CircleAvatar(
              radius: 15,
              child: Text(widget.chatIcon, style: Theme.of(context).textTheme.labelSmall,),
            ),
            const SizedBox(width: 5.0,),
            Text(widget.chatName),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(LucideIcons.pin))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('Chats')
                  .doc(widget.chatId)
                  .collection('Chat')
                  .orderBy('timestamp', descending: true)
                  .limit(messageLimit)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final recentMessages = snapshot.data!.docs;

                print("Requête reçue : Nouveaux messages");

                final allMessages = [...recentMessages, ...oldMessages];

                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: allMessages.length + (hasMoreMessages ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == allMessages.length) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: isLoadingMore
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _loadMoreMessages,
                                  child: const Text("Charger plus"),
                                ),
                        ),
                      );
                    }

                    final message = allMessages[index];
                    final isCurrentUser =
                        message['uid'] == currentUserUid;

                    return Align(
                      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          !isCurrentUser ?
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 13.0),
                            child: Text(message['uid'], style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greyColor, fontSize: 8),),
                          ) : const SizedBox(),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? primaryColor
                                  : secondaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['message'],
                                  style: TextStyle(
                                    color: isCurrentUser
                                        ? backgroundColor
                                        : textColor,
                                  ),
                                ),
                                /* if (!isCurrentUser)
                                  Text(
                                    message['uid'],
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.black54,
                                    ),
                                  ), */
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: PopupMenuButton<int>(
                    iconColor: primaryColor,
                    shadowColor: backgroundColor,
                    surfaceTintColor: Colors.transparent,
                    onSelected: _onMenuItemSelected,
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem<int>(
                          value: 0,
                          child: Row(
                            children: [
                              Icon(LucideIcons.paperclip),
                              SizedBox(width: 10),
                              Text("Fiche onisep"),
                            ],
                          ),
                        ),
                        const PopupMenuItem<int>(
                          value: 1,
                          child: Row(
                            children: [
                              Icon(LucideIcons.school),
                              SizedBox(width: 10),
                              Text("Fiche Etablissement"),
                            ],
                          ),
                        ),
                      ];
                    },
                    child: const Icon(Icons.more_vert),
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                    controller: _messageController,
                    hintText: 'Entre ton message...',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                    icon: const Icon(LucideIcons.send),
                    onPressed: () {
                      _sendMessage(_messageController.text);
                      _messageController.clear();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
