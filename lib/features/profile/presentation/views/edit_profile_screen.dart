import 'package:appointify_app/core/helper_functions/get_user.dart';
import 'package:appointify_app/core/utils/app_colors.dart';
import 'package:appointify_app/core/utils/app_images.dart';
import 'package:appointify_app/core/widgets/custom_app_bar.dart';
import 'package:appointify_app/core/widgets/custom_button.dart';
import 'package:appointify_app/core/widgets/custom_text_field.dart';
import 'package:appointify_app/features/auth/domain/entities/user_entity.dart';
import 'package:appointify_app/features/profile/presentation/cubits/profile_edit_cubit/profile_edit_cubit.dart';
import 'package:appointify_app/features/profile/presentation/cubits/profile_edit_cubit/profile_edit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  static const String routeName = '/editProfile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late UserEntity _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await getUser();
      setState(() {
        _currentUser = user!;
        _nameController.text = user.name;
        _emailController.text = user.email;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load user data'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context,
        title: 'Edit Profile',
        showBackButton: true,
        showSettingsButton: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : BlocConsumer<ProfileEditCubit, ProfileEditState>(
        listener: (context, state) {
          if (state is ProfileEditFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ProfileEditSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile picture (can be enhanced later)
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.primaryLight,
                          child: Image.asset(Assets.imagesProfileImage)
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Name field
                  const Text(
                    'Full Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                      textInputType: TextInputType.name,
                      controller: _nameController,
                      hintText: 'Enter your full name',
                      prefixIcon: const Icon(Icons.person_outline),
                      validator: (value) {
                        if (value == null || value
                            .trim()
                            .isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    textInputType: TextInputType.name,
                    controller: _emailController,
                    hintText: 'Your email address',
                    prefixIcon: const Icon(Icons.email_outlined),
                    readOnly: true,
                    enabled: false,
                  ),
                  const SizedBox(height: 32),

                  // Submit button
                  state is ProfileEditLoading
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                    onPressed: _submitForm,
                    text: 'Save Changes',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create updated user object
      final updatedUser = UserEntity(
        uId: _currentUser.uId,
        email: _currentUser.email,
        name: _nameController.text.trim(),
      );

      // Update profile using cubit
      context.read<ProfileEditCubit>().updateUserProfile(updatedUser);
    }
  }
}
