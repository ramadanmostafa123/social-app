abstract class SocialAppStates {}

class SocialAppInitialStata extends SocialAppStates {}

class HomeLoadingStete extends SocialAppStates {}

class HomeSuccessStete extends SocialAppStates {}

class HomeErrorStete extends SocialAppStates {
  final String error;
  HomeErrorStete(this.error);
}

class SocialAppChangePasswordVisibilityState extends SocialAppStates {}
