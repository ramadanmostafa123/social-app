// ignore_for_file: prefer_const_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fire_base_app/Cubit/cubit/cubits.dart';
import 'package:fire_base_app/Cubit/cubit/states.dart';
import 'package:fire_base_app/models/SocialUserModel.dart';
import 'package:fire_base_app/modules/screens/chatDetailes.dart';
import 'package:fire_base_app/shared/components/comonents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) => {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).users.isNotEmpty,
          fallback: (context) => Center(child: CircularProgressIndicator()),
          builder: (context) => ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
                  chatBuildItem(SocialCubit.get(context).users[index], context),
              separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Container(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  ),
              itemCount: SocialCubit.get(context).users.length),
        );
      },
    );
  }

  Widget chatBuildItem(SocialUserModel model, context) => InkWell(
        onTap: () {
          navigateTo(context, ChatDetailesScreen(userModel: model));
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage('${model.image}'),
              ),
              SizedBox(
                width: 15,
              ),
              Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    '${model.name} ',
                    style: TextStyle(height: 1.4, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
      );
}
