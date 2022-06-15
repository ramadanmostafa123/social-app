// ignore_for_file: avoid_print, prefer_const_constructors, non_constant_identifier_names, unused_element

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_base_app/Cubit/RegisterCubit/RegisterAndLoginCubit.dart';
import 'package:fire_base_app/Cubit/cubit/states.dart';
import 'package:fire_base_app/models/SocialUserModel.dart';
import 'package:fire_base_app/models/chatModel.dart';
import 'package:fire_base_app/models/postModel.dart';
import 'package:fire_base_app/modules/screens/NewPost.dart';
import 'package:fire_base_app/modules/screens/chats.dart';
import 'package:fire_base_app/modules/screens/feeds.dart';
import 'package:fire_base_app/modules/screens/settings.dart';
import 'package:fire_base_app/modules/screens/users.dart';
import 'package:fire_base_app/shared/components/conestaenc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  var userModel = SocialUserModel();

  void getUserData({
    String? name,
    String? phone,
    String? bio,
  }) {
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      print(value.data());
      print('داتااااااااااا');

      userModel = SocialUserModel.fromJson(value.data());

      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  /* List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_max_outlined),
      label: 'HOME PAGE',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.school_outlined),
      label: 'ABOUT COLLEGR',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.ad_units_outlined),
      label: 'CentersAndUnits',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.health_and_safety_outlined),
      label: 'HEALTH CARE',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.book_online_outlined),
      label: 'FaculiteisAndPrograms',
    ),
  ];*/
  List<Widget> screens = [
    NewsFeedScreen(),
    ChatsScreen(),
    AddPostScreen(),
    UsersScreen(),
    SettingsScreen()
  ];
  List<String> title = ['Home', 'Chats', 'Post', 'Users', 'Settings'];
  void changeBottomNav(int index) {
    if (index == 1) {
      getUsers();
    }
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialchangeBottomNavState());
    }
  }

  File? profileImage;

  var picker = ImagePicker();

  Future getProfileImage() async {
    final PickedFile = await picker.getImage(source: ImageSource.gallery);

    if (PickedFile != null) {
      profileImage = File(PickedFile.path);
      emit(SocialProfileImageSuccssesState());
    } else {
      print('No Image Selected');
      emit(SocialProfileImageErrorState());
    }
  }

  File? coverImage;

  Future getCoverImage() async {
    final PickedFile = await picker.getImage(source: ImageSource.gallery);

    if (PickedFile != null) {
      coverImage = File(PickedFile.path);
      emit(SocialCoverImageSuccssesState());
    } else {
      print('No Image Selected');
      emit(SocialCoverImageErrorState());
    }
  }

  // String? profileImageUrl;
  void uploadProfileImage({
    String? name,
    String? phone,
    String? bio,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // emit(SocialUploadCoverImageSuccssesState());
        getUserData();
        //  profileImageUrl = value;
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  // String? coverImageUrl;

  void uploadCoverImage({
    String? name,
    String? phone,
    String? bio,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialUploadCoverImageSuccssesState());
        getUserData();
        //     coverImageUrl = value;
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  void updateUser({
    String? name,
    String? phone,
    String? bio,
    String? cover,
    String? image,
  }) {
    SocialUserModel model = SocialUserModel(
        name: name,
        phone: phone ?? userModel.phone,
        uId: uId,
        email: userModel.email,
        cover: cover ?? userModel.cover,
        image: image ?? userModel.image,
        bio: bio,
        isEmailVerified: false);

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(model.toMap())
        .then((value) {
      //  emit(SocialGetUserLoadingState());
      getUserData();
      print(uId);
      print('zzzzzzzzzzz');
      // emit(SocialGetUserSuccessState());
      // emit(SocialGetUserSuccessState());
      //  emit(SocialUserUpdateSuccessState());
    }).catchError((error) {
      emit(SocialUserUpdateErrorState());
    });
  }

  File? PostImage;

  Future<void> getPostImage() async {
    final PickedFile = await picker.pickImage(source: ImageSource.gallery);
    emit(SocialPostImagePickedSuccssesState());

    if (PickedFile != null) {
      PostImage = File(PickedFile.path);

      emit(SocialPostImagePickedSuccssesState());
    } else {
      print('No Image Selected');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void uploadPostImage({
    required String text,
    required String dateTime,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(PostImage!.path).pathSegments.last}')
        .putFile(PostImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(text: text, postImage: value, dateTime: dateTime);
        print(value);
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void createPost({
    String? postImage,
    required String text,
    required String dateTime,
  }) {
    emit(SocialCreatePostLoadingState());
    PostModel model = PostModel(
      name: userModel.name,
      postImage: postImage ?? '',
      uId: uId,
      dateTime: dateTime,
      text: text,
      image: userModel.image,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void removePostImage() {
    PostImage = null;
    emit(SocialRemovePostImageState());
  }

  List<PostModel> posts = [];
  List<String> PostsId = [];
  List<String> PostssId = [];
  List<int> Likes = [];
  List<int> comments = [];

  void getPosts() {
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      emit(SocialgetPostSuccessState());
      value.docs.forEach((element) {
        element.reference.collection('comments').get().then((value) {
          comments.add(value.docs.length);
          posts.add(PostModel.fromJson(element.data()));
          PostsId.add(element.id);
        }).catchError((error) {});
      });
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          Likes.add(value.docs.length);
          /*PostsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));*/
          emit(SocialgetPostSuccessState());
        }).catchError((error) {});
      });
    }).catchError((error) {
      emit(SocialGetPostErrorState(error.toString()));
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  void commentsPost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(userModel.uId)
        .set({
      'comment': true,
    }).then((value) {
      emit(SocialCommentPostSuccessState());
    }).catchError((error) {
      emit(SocialCommentPostErrorState(error.toString()));
    });
  }

  List<SocialUserModel> users = [];
  void getUsers() {
    if (users.isEmpty)
      // ignore: curly_braces_in_flow_control_structures
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          users.add(SocialUserModel.fromJson(element.data()));
        });
        emit(SocialgetAllUsersSuccessState());
      }).catchError((error) {
        emit(SocialGetAllUsersErrorState(error.toString()));
      });
  }

  void sendMessage({
    required receiverId,
    required String dateTime,
    required String text,
  }) {
    MessageModel model = MessageModel(
        text: text, senderId: uId, receiverId: receiverId, dateTime: dateTime);

    //set my Chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });

    //set Receiver Chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(uId)
        .collection('message')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    required receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc('BduLBBnMvPY6IY1pm7jDDy1tu6W2')
        .collection('message')
        // .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(SocialGetMessageSuccessState());
    });
  }
}


  


/* rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if false;
    }
  }
}*/


