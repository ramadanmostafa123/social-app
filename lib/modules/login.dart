// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:fire_base_app/Cubit/AppCubit.dart';
import 'package:fire_base_app/Cubit/AppStates.dart';
import 'package:fire_base_app/Cubit/RegisterCubit/RegisterAndLoginCubit.dart';
import 'package:fire_base_app/Cubit/RegisterCubit/RegisterAndLoginSates.dart';
import 'package:fire_base_app/layout/SocialLayout.dart';
import 'package:fire_base_app/modules/RegisterScreen.dart';
import 'package:fire_base_app/shared/components/comonents.dart';
import 'package:fire_base_app/shared/network/local/cache-Helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialAppLoginScreen extends StatelessWidget {
  //SocialAppLoginModel? loginModel;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => SocialRegisterCubit()),
        BlocProvider(create: (BuildContext context) => SocialAppCubit()),
      ],
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {
          if (state is SocialLoginErrorState) {
            showToast(
                text: 'Error While Login Please Try Agin',
                state: ToastStates.ERROR);
          }
          if (state is SocialLoginSuccessState) {
            {
              showToast(text: 'Login Success', state: ToastStates.SUCCESS);
              navigateAndFinish(context, SocialLayout());
            }
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
                        'LOGIN',
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: Colors.black),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Login now to communicate with freinds',
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 30,
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
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            SocialRegisterCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text);
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account ?"),
                          TextButton(
                            onPressed: () {
                              navigateTo(context, SocialAppRegisterScreen());
                            },
                            child: Text('REGISTER'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
