import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isLoggedIn = false;
  String _userEmail = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  String get userEmail => _userEmail;

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _userEmail = prefs.getString('userEmail') ?? '';
    notifyListeners();
    return _isLoggedIn;
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));
      if (email.isEmpty || !email.contains('@')) {
        _isLoading = false;
        _errorMessage = 'Please enter a valid email address.';
        notifyListeners();
        return false;
      }
      if (password.length < 6) {
        _isLoading = false;
        _errorMessage = 'Password must be at least 6 characters.';
        notifyListeners();
        return false;
      }
      await _saveLoginState(email.trim());
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Something went wrong. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));
      if (email.isEmpty || !email.contains('@')) {
        _isLoading = false;
        _errorMessage = 'Please enter a valid email address.';
        notifyListeners();
        return false;
      }
      if (password.length < 6) {
        _isLoading = false;
        _errorMessage = 'Password must be at least 6 characters.';
        notifyListeners();
        return false;
      }
      await _saveLoginState(email.trim());
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Something went wrong. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.setString('userEmail', '');
    _isLoggedIn = false;
    _userEmail = '';
    notifyListeners();
  }

  Future<void> _saveLoginState(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', email);
    _isLoggedIn = true;
    _userEmail = email;
  }
}