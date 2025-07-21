import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skin_muse/features/auth/presentation/bloc/editprofile/edit_profile_bloc.dart';
import 'package:skin_muse/features/auth/presentation/bloc/editprofile/edit_profile_event.dart';
import 'package:skin_muse/features/auth/presentation/bloc/editprofile/edit_profile_state.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  File? _image;

  final _nameController = TextEditingController();
  final _confirmNameController = TextEditingController();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final Color lightPink = const Color(0xFFF48FB1);

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });

      context.read<EditProfileBloc>().add(
        UpdateProfilePhotoPressed(picked.path),
      );
    }
  }

  void _showCenteredModal(Widget child) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: child,
              ),
              Positioned(
                right: 8,
                top: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditNameModal() {
    _nameController.clear();
    _confirmNameController.clear();

    _showCenteredModal(
      BlocConsumer<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileSuccess && state.message.contains("name")) {
            Navigator.of(context).pop(); // close modal
            // delay to ensure modal closes first, then pop back with new name
            Future.delayed(const Duration(milliseconds: 300), () {
              Navigator.of(context).pop(_nameController.text);
            });
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is EditProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          bool isLoading = state is EditProfileLoading;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Edit Your Name",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: lightPink,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmNameController,
                decoration: InputDecoration(
                  labelText: "Confirm Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightPink,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            if (_nameController.text.isEmpty ||
                                _confirmNameController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill all fields'),
                                ),
                              );
                              return;
                            }
                            if (_nameController.text !=
                                _confirmNameController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Names do not match'),
                                ),
                              );
                              return;
                            }
                            context.read<EditProfileBloc>().add(
                              UpdateNamePressed(_nameController.text),
                            );
                          },
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "Save",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showChangePasswordModal() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    _showCenteredModal(
      BlocConsumer<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileSuccess &&
              state.message.contains("password")) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is EditProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          bool isLoading = state is EditProfileLoading;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Change Password",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: lightPink,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Current Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "New Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightPink,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            if (_currentPasswordController.text.isEmpty ||
                                _newPasswordController.text.isEmpty ||
                                _confirmPasswordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill all fields'),
                                ),
                              );
                              return;
                            }
                            if (_newPasswordController.text !=
                                _confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Passwords do not match'),
                                ),
                              );
                              return;
                            }
                            context.read<EditProfileBloc>().add(
                              ChangePasswordPressed(
                                _currentPasswordController.text,
                                _newPasswordController.text,
                              ),
                            );
                          },
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "Save",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFFFFF0F5);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightPink,
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        _image != null
                            ? FileImage(_image!)
                            : const AssetImage("assets/profile.png")
                                as ImageProvider,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Update your photo",
                    style: TextStyle(
                      color: lightPink,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            ListTile(
              leading: Icon(Icons.person_outline, color: lightPink, size: 30),
              title: const Text(
                "Edit your name",
                style: TextStyle(fontSize: 20),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 20),
              onTap: _showEditNameModal,
            ),
            const Divider(height: 1, thickness: 1),
            ListTile(
              leading: Icon(Icons.lock_outline, color: lightPink, size: 30),
              title: const Text(
                "Change password",
                style: TextStyle(fontSize: 20),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 20),
              onTap: _showChangePasswordModal,
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
    );
  }
}
