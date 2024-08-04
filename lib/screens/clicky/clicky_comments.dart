import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/comment.dart';
import 'package:pherico/resources/clicky_resource.dart';
import 'package:pherico/utils/snackbar.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:pherico/widgets/global/read_more.dart';
import 'package:pherico/widgets/global/image_popup.dart';
import 'package:timeago/timeago.dart' as timeago;

class ClickyComments extends StatefulWidget {
  final String postId;
  const ClickyComments({super.key, required this.postId});

  @override
  State<ClickyComments> createState() => _ClickyCommentsState();
}

class _ClickyCommentsState extends State<ClickyComments> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _stream;
  FocusNode inputNode = FocusNode();
  final TextEditingController _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Offset _tapPosition = Offset.zero;

  bool _isEdit = false;
  bool _isSending = false;
  String commentId = '';

  @override
  void initState() {
    super.initState();
    _stream = firebaseFirestore
        .collection(clickiesCollection)
        .doc(widget.postId)
        .collection(commentCollection)
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  void _getTapPosition(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
    });
  }

  void _showContextMenu(BuildContext context, String id, String comment) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    final result = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),
        items: [
          const PopupMenuItem(
            value: 'delete',
            child: Text('Delete'),
          ),
          const PopupMenuItem(
            value: 'edit',
            child: Text('Edit'),
          ),
        ]);

    switch (result) {
      case 'delete':
        await ClickyResource.deleteComment(widget.postId, id);
        break;
      case 'edit':
        setState(() {
          _isEdit = true;
          commentId = id;
          FocusScope.of(context).requestFocus(inputNode);
          _commentController.text = comment;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const MyProgressIndicator();
                    }
                    if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No comments'),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Comment comment =
                              Comment.fromSnap(snapshot.data!.docs[index]);
                          return GestureDetector(
                            onTapDown: (details) {
                              _getTapPosition(details);
                            },
                            onLongPress: (() {
                              firebaseAuth.currentUser!.uid == comment.userId
                                  ? _showContextMenu(
                                      context, comment.id, comment.comment)
                                  : '';
                            }),
                            child: ListTile(
                              leading: GestureDetector(
                                onTap: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (_) =>
                                          ImagePopup(image: comment.profile));
                                },
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: comment.profile,
                                    fit: BoxFit.cover,
                                    height: 50,
                                    width: 50,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error, size: 40),
                                  ),
                                ),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    comment.username,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  ReadMore(text: comment.comment),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    timeago.format(comment.createdAt.toDate()),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    '${comment.likes.length} likes',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  ClickyResource.likeComment(
                                      widget.postId, comment.id);
                                },
                                icon: comment.likes
                                        .contains(firebaseAuth.currentUser!.uid)
                                    ? Icon(
                                        Icons.favorite,
                                        color: gradient1,
                                      )
                                    : const Icon(Icons.favorite_border),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: SizedBox(
                    height: 44,
                    child: TextFormField(
                      key: _formKey,
                      controller: _commentController,
                      cursorColor: gradient1,
                      maxLines: 12,
                      focusNode: inputNode,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: 'Say Something...',
                        labelStyle:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(28),
                          ),
                          borderSide: BorderSide(width: 1, color: iconColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28.0),
                          borderSide: BorderSide(color: iconColor, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28.0),
                          borderSide: BorderSide(color: iconColor, width: 1),
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(16.0, 20.0, 8.0, 4.0),
                      ),
                    ),
                  ),
                  trailing: _isSending
                      ? const SizedBox(
                          width: 40,
                          height: 40,
                          child: MyProgressIndicator(),
                        )
                      : IconButton(
                          padding: EdgeInsets.zero,
                          icon: SvgPicture.asset(
                            'assets/images/navigation-icon/send.svg',
                            height: 40,
                          ),
                          onPressed: (() {
                            if (_commentController.text.trim().isNotEmpty) {
                              addComment();
                            }
                          }),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addComment() async {
    setState(() {
      _isSending = true;
    });
    if (_isEdit) {
      ClickyResource.updateComment(
          _commentController.text.trim(), widget.postId, commentId);
      setState(() {
        _isEdit = false;
        commentId = '';
        _commentController.text = '';
      });
    } else {
      int res = await ClickyResource.postComment(
          _commentController.text.trim(), widget.postId);

      if (res == 0) {
        setState(() {
          _commentController.text = '';
        });
      }
    }
    setState(() {
      _isSending = false;
    });
  }
}
