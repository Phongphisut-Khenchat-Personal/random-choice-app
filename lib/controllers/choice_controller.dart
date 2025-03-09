import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/ad_service.dart'; // เรียกใช้ AdService

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
      // ไม่แจ้งเตือน error ทั่วไป
    }
  }
  
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      removeAfterSpin.value = prefs.getBool('remove_after_spin') ?? false;
      resetAfterSpin.value = prefs.getBool('reset_after_spin') ?? false;
    } catch (e) {
      // ไม่แจ้งเตือน error ทั่วไป
    }
  }
  
  Future<void> _saveChoices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('wheel_choices', choices);
    } catch (e) {
      // ไม่แจ้งเตือน error ทั่วไป
    }
  }
  
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remove_after_spin', removeAfterSpin.value);
      await prefs.setBool('reset_after_spin', resetAfterSpin.value);
    } catch (e) {
      // ไม่แจ้งเตือน error ทั่วไป
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
  
  void addChoice(String choice) {
    if (choice.isEmpty) return;
    
    if (choices.contains(choice)) {
      Get.snackbar(
        'ตัวเลือกซ้ำ',
        'มีตัวเลือก "$choice" อยู่แล้ว',
        backgroundColor: Colors.amber[100],
        colorText: Colors.amber[800],
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    
    choices.add(choice);
    _saveChoices();
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
        backgroundColor: Colors.red[100],
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
      if (removeAfterSpin.value) {
        removeChoice(0);
      }
      if (resetAfterSpin.value) {
        clearAllChoicesWithoutDialog();
      }
      AdService.showInterstitialAd(); // แสดงโฆษณาคั่นระหว่างหน้า
      return;
    }
    
    isSpinning.value = true;
    
    final random = Random().nextInt(choices.length);
    
    controller.add(random);
    
    Timer(const Duration(seconds: 3), () {
      selectedChoice.value = choices[random];
      selectedIndex.value = random;
      isSpinning.value = false;
      
      _showResultDialog();
      
      if (removeAfterSpin.value && choices.isNotEmpty) {
        removeChoice(random);
      }
      
      if (resetAfterSpin.value) {
        clearAllChoicesWithoutDialog();
      }
      
      AdService.showInterstitialAd(); // แสดงโฆษณาคั่นระหว่างหน้า
    });
  }
  
  void _showResultDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        elevation: 8,
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emoji_events,
              size: 60,
              color: Colors.indigo,
            ),
            const SizedBox(height: 16),
            Text(
              selectedChoice.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(Get.context!).showSnackBar(
                  const SnackBar(
                    content: Text('คัดลอกผลลัพธ์แล้ว'),
                    backgroundColor: Colors.green,
                  ),
                );
                Get.back();
              },
              child: const Text(
                'คัดลอก',
                style: TextStyle(color: Colors.indigo),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: true,
    );
  }
  
  void clearAllChoices() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        elevation: 8,
        title: const Text(
          'ลบตัวเลือกทั้งหมด',
          style: TextStyle(color: Colors.indigo),
        ),
        content: const Text(
          'คุณต้องการลบตัวเลือกทั้งหมดใช่หรือไม่?',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('ยกเลิก', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              choices.clear();
              _saveChoices();
              Get.back();
            },
            child: const Text(
              'ลบทั้งหมด',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }
  
  void clearAllChoicesWithoutDialog() {
    choices.clear();
    _saveChoices();
  }
}