// ignore_for_file: prefer_const_constructors, avoid_print, avoid_unnecessary_containers, unused_local_variable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fire_base_app/Cubit/AppCubit.dart';
import 'package:fire_base_app/Cubit/AppStates.dart';
import 'package:fire_base_app/Cubit/RegisterCubit/RegisterAndLoginCubit.dart';
import 'package:fire_base_app/Cubit/RegisterCubit/RegisterAndLoginSates.dart';
import 'package:fire_base_app/layout/SocialLayout.dart';
import 'package:fire_base_app/shared/components/comonents.dart';
import 'package:fire_base_app/shared/components/conestaenc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialAppRegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => SocialRegisterCubit()),
        BlocProvider(create: (BuildContext context) => SocialAppCubit()),
      ],
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {
          if (state is SocialCreateUserSuccessState) {
            navigateAndFinish(context, SocialLayout());
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'REGISTER now to communicate with freinds',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                            controller: nameController,
                            type: TextInputType.emailAddress,
                            label: 'User Name',
                            prefix: Icons.person,
                            /* onTap: () {
                              print('taped');
                            },*/
                            onSubmit: (value) {},
                            validate: (value) {
                              if (value.isempty) {
                                return 'email must not be empty';
                              }
                            }),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            label: 'Email Address',
                            prefix: Icons.email,
                            /* onTap: () {
                              print('taped');
                            },*/
                            onSubmit: (value) {},
                            validate: (value) {
                              if (value.isempty) {
                                return 'email must not be empty';
                              }
                            }),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                            validate: (value) {
                              if (value.isempty) {
                                return 'Password must not be empty';
                              }
                            },
                            controller: passwordController,
                            type: TextInputType.emailAddress,
                            label: 'Password ',
                            prefix: Icons.lock_clock_outlined,
                            suffix: SocialAppCubit.get(context).suffix,
                            isPassword: SocialAppCubit.get(context).isPassword,
                            suffixPressed: () {
                              SocialAppCubit.get(context)
                                  .changePasswordVisibility();
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                            controller: phoneController,
                            type: TextInputType.phone,
                            label: ' phone',
                            prefix: Icons.phone,
                            /* onTap: () {
                              print('taped');
                            },*/
                            onSubmit: (value) {},
                            validate: (value) {
                              if (value.isempty) {
                                return 'phone must not be empty';
                              }
                            }),
                        SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)),
                          height: 45,
                          width: double.infinity,
                          child: ConditionalBuilder(
                            condition: state is! SocialRegisterLoadingState,
                            builder: (context) => TextButton(
                              child: Text(
                                'REGISTER',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                SocialRegisterCubit.get(context).userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text);
                              },
                            ),
                            fallback: (context) => Center(
                              child: Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: CircularProgressIndicator()),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
