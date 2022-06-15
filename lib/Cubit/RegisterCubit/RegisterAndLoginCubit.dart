// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_base_app/Cubit/RegisterCubit/RegisterAndLoginSates.dart';
import 'package:fire_base_app/models/SocialUserModel.dart';
import 'package:fire_base_app/shared/components/conestaenc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(SocialRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user!.email);
      print(value.user!.uid);

      userCreate(name: name, email: email, phone: phone, uId: value.user!.uid);
      // emit(SocialRegisterSuccessState());
    }).catchError((error) {
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String phone,
    required String uId,
  }) {
    SocialUserModel model = SocialUserModel(
        email: email,
        name: name,
        phone: phone,
        uId: uId,
        bio: 'Write your bio...',
        cover:
            'https://img.freepik.com/free-photo/studio-shot-handsome-bearded-man-holds-chin-looks-thoughtfully-aside-thinks-deeply-about-something-wears-hat-sweater-poses-against-bright-vivid-orange-wall_273609-44602.jpg?t=st=1645085871~exp=1645086471~hmac=7ea6883679da2c8d65a13b1eedb8389090b75746ae59ae0569add6022d2dfd0a&w=740',
        image:
            'https://img.freepik.com/free-photo/studio-shot-handsome-bearded-man-holds-chin-looks-thoughtfully-aside-thinks-deeply-about-something-wears-hat-sweater-poses-against-bright-vivid-orange-wall_273609-44602.jpg?t=st=1645085871~exp=1645086471~hmac=7ea6883679da2c8d65a13b1eedb8389090b75746ae59ae0569add6022d2dfd0a&w=740',
        isEmailVerified: false);

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit((SocialCreateUserSuccessState()));
    }).catchError((error) {
      emit(SocialCreateUserErrorState(error.toString()));
    });
  }

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(SocialLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(SocialLoginSuccessState());
    }).catchError((error) {
      emit(SocialLoginErrorState());
    });
  }
}
