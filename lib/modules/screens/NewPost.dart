// ignore_for_file: prefer_const_constructors

import 'package:fire_base_app/Cubit/cubit/cubits.dart';
import 'package:fire_base_app/Cubit/cubit/states.dart';
import 'package:fire_base_app/shared/components/comonents.dart';
import 'package:fire_base_app/shared/styles/icon-broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPostScreen extends StatelessWidget {
  var textController = TextEditingController();
  var now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) => {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  IconBroken.Arrow___Left_2,
                  color: Colors.black,
                ),
              ),
              title: Text('Create Post'),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    if (SocialCubit.get(context).PostImage == null) {
                      SocialCubit.get(context).createPost(
                          text: textController.text, dateTime: now.toString());

                      SocialCubit.get(context).getPosts();
                    } else {
                      SocialCubit.get(context).uploadPostImage(
                          text: textController.text, dateTime: now.toString());
                      SocialCubit.get(context).getPosts();
                    }
                  },
                  child: Text(
                    'Post',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ]),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children:
                      // ignore: prefer_const_literals_to_create_immutables
                      [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(
                          'https://img.freepik.com/free-photo/portrait-fair-haired-beautiful-female-woman-with-broad-smile-thumbs-up_176420-14970.jpg?w=740'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Ramadan Mostafa',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                        hintText: 'what is on your mind...',
                        border: InputBorder.none),
                  ),
                ),
                if (SocialCubit.get(context).PostImage != null)
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 160,
                        width: double.infinity,
                        child: Image(
                          image: FileImage(SocialCubit.get(context).PostImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          alignment: AlignmentDirectional.topEnd,
                          child: CircleAvatar(
                            radius: 15,
                            child: IconButton(
                              // alignment: AlignmentDirectional.center,
                              onPressed: () {
                                SocialCubit.get(context).removePostImage();
                              },
                              icon: Icon(
                                Icons.close,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          SocialCubit.get(context).getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Icon(IconBroken.Image),
                            SizedBox(
                              width: 5,
                            ),
                            Text('add photo'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child:
                          TextButton(onPressed: () {}, child: Text('# tags')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
