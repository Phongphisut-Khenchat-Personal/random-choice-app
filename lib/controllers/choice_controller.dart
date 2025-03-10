import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/ad_service.dart';

class WheelController extends GetxController {
  var choices = <String>[].obs;
  var selectedChoice = "".obs;
  var isSpinning = false.obs;
  var selectedIndex = 0.obs;
  var removeAfterSpin = false.obs;
  var resetAfterSpin = false.obs;
  
  final StreamController<int> controller = StreamController<int>.broadcast();

  @override
  void onInit() {
    super.onInit();
    _loadChoices();
    _loadSettings();
  }
  
  @override
  void onClose() {
    controller.close();
    super.onClose();
  }
  
  Future<void> _loadChoices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedChoices = prefs.getStringList('wheel_choices');
      if (savedChoices != null && savedChoices.isNotEmpty) {
        choices.assignAll(savedChoices);
      }
    } catch (e) {
      debugPrint('Error loading choices: $e');
      Get.snackbar(
        'ข้อผิดพลาด',
        'ไม่สามารถโหลดตัวเลือกได้ กรุณาลองใหม่',
        backgroundColor: Colors.red[50],
        colorText: Colors.red[800],
      );
    }
  }
  
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      removeAfterSpin.value = prefs.getBool('remove_after_spin') ?? false;
      resetAfterSpin.value = prefs.getBool('reset_after_spin') ?? false;
    } catch (e) {
      debugPrint('Error loading settings: $e');
      Get.snackbar(
        'ข้อผิดพลาด',
        'ไม่สามารถโหลดการตั้งค่าได้ กรุณาลองใหม่',
        backgroundColor: Colors.red[50],
        colorText: Colors.red[800],
      );
    }
  }
  
  Future<void> _saveChoices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('wheel_choices', choices);
    } catch (e) {
      debugPrint('Error saving choices: $e');
      Get.snackbar(
        'ข้อผิดพลาด',
        'ไม่สามารถบันทึกตัวเลือกได้ กรุณาลองใหม่',
        backgroundColor: Colors.red[50],
        colorText: Colors.red[800],
      );
    }
  }
  
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remove_after_spin', removeAfterSpin.value);
      await prefs.setBool('reset_after_spin', resetAfterSpin.value);
    } catch (e) {
      debugPrint('Error saving settings: $e');
      Get.snackbar(
        'ข้อผิดพลาด',
        'ไม่สามารถบันทึกการตั้งค่าได้ กรุณาลองใหม่',
        backgroundColor: Colors.red[50],
        colorText: Colors.red[800],
      );
    }
  }
  
  void toggleRemoveAfterSpin(bool value) {
    removeAfterSpin.value = value;
    _saveSettings();
  }
  
  void toggleResetAfterSpin(bool value) {
    resetAfterSpin.value = value;
    _saveSettings();
  }
  
  void addChoice(String input) {
    // แยกข้อความด้วยช่องว่าง
    List<String> newChoices = input.trim().split(' ').where((choice) => choice.isNotEmpty).toList();
    
    for (String choice in newChoices) {
      if (choice.length > 50) {
        Get.snackbar(
          'ตัวเลือกยาวเกินไป',
          'กรุณาใช้ตัวเลือกที่มีความยาวไม่เกิน 50 ตัวอักษร',
          backgroundColor: Colors.red[50],
          colorText: Colors.red[800],
        );
        continue;
      }
      if (choices.contains(choice)) {
        Get.snackbar(
          'ตัวเลือกซ้ำ',
          'มีตัวเลือก "$choice" อยู่แล้ว',
          backgroundColor: Colors.amber[50],
          colorText: Colors.amber[800],
        );
        continue;
      }
      choices.add(choice);
    }
    if (newChoices.isNotEmpty) _saveChoices();
  }
  
  void removeChoice(int index) {
    if (index < 0 || index >= choices.length) return;
    choices.removeAt(index);
    _saveChoices();
  }
  
  void spinWheel() {
    if (choices.isEmpty) {
      Get.snackbar(
        'ไม่มีตัวเลือก',
        'กรุณาเพิ่มตัวเลือกอย่างน้อย 1 รายการ',
        backgroundColor: Colors.red[50],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    if (isSpinning.value) return;

    if (choices.length == 1) {
      selectedChoice.value = choices[0];
      selectedIndex.value = 0;
      _showResultDialog();
      _handlePostSpinActions();
      return;
    }

    isSpinning.value = true;
    final random = Random().nextInt(choices.length);
    controller.add(random);

    // รอให้วงล้อหมุนเสร็จ (3 วินาที) ก่อนดำเนินการต่อ
    Timer(const Duration(seconds: 3), () {
      if (!isSpinning.value) return;
      selectedChoice.value = choices[random];
      selectedIndex.value = random;
      isSpinning.value = false;
      _showResultDialog();
      _handlePostSpinActions();
    });
  }
  
  void _handlePostSpinActions() {
    if (removeAfterSpin.value && choices.isNotEmpty) {
      removeChoice(selectedIndex.value);
    }
    if (resetAfterSpin.value) {
      clearAllChoicesWithoutDialog();
    }
    AdService.showInterstitialAd();
  }
  
  void _showResultDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'ผลลัพธ์',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  selectedChoice.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
  
  void clearAllChoices() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'ลบตัวเลือกทั้งหมด?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'คุณต้องการลบตัวเลือกทั้งหมดใช่หรือไม่?',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Text(
                      'ยกเลิก',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 30),
                  GestureDetector(
                    onTap: () {
                      choices.clear();
                      _saveChoices();
                      Get.back();
                    },
                    child: const Text(
                      'ลบ',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
  
  void clearAllChoicesWithoutDialog() {
    choices.clear();
    _saveChoices();
  }
}