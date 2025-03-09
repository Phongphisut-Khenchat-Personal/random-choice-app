import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../controllers/choice_controller.dart';
import '../services/ad_service.dart'; // เรียกใช้ AdService

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdService.bannerAdUnitId, // ใช้จาก AdService
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WheelController>();
    final textController = TextEditingController();
    
    Color getWheelColor(int index) {
      final colors = [
        Colors.red[400],
        Colors.blue[400],
        Colors.green[400],
        Colors.amber[400],
        Colors.purple[400],
        Colors.teal[400],
        Colors.pink[400],
        Colors.orange[400],
      ];
      return colors[index % colors.length]!;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('วงล้อสุ่มตัวเลือก'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'ตั้งค่า',
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.white,
                  elevation: 8,
                  title: const Text(
                    'ตั้งค่า',
                    style: TextStyle(color: Colors.indigo),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() => SwitchListTile(
                        title: const Text('ลบตัวเลือกหลังหมุน'),
                        value: controller.removeAfterSpin.value,
                        activeColor: Colors.indigo,
                        onChanged: (value) => controller.toggleRemoveAfterSpin(value),
                      )),
                      Obx(() => SwitchListTile(
                        title: const Text('รีเซ็ตวงล้อหลังหมุน'),
                        value: controller.resetAfterSpin.value,
                        activeColor: Colors.indigo,
                        onChanged: (value) => controller.toggleResetAfterSpin(value),
                      )),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        'ปิด',
                        style: TextStyle(color: Colors.indigo),
                      ),
                    ),
                  ],
                ),
                barrierDismissible: true,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ส่วนแสดงวงล้อ
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                '🎯 วงล้อของคุณ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Obx(() {
                                  if (controller.choices.isEmpty) {
                                    return const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_circle_outline,
                                            size: 48,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'ยังไม่มีตัวเลือก\nกรุณาเพิ่มตัวเลือกด้านล่าง',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  
                                  if (controller.choices.length == 1) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            size: 48,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'เพิ่มตัวเลือกอย่างน้อย 2 รายการ\nเพื่อหมุนวงล้อ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  
                                  return FortuneWheel(
                                    physics: CircularPanPhysics(
                                      duration: const Duration(seconds: 1, milliseconds: 500),
                                      curve: Curves.decelerate,
                                    ),
                                    animateFirst: false,
                                    selected: controller.controller.stream,
                                    items: List.generate(
                                      controller.choices.length,
                                      (index) => FortuneItem(
                                        style: FortuneItemStyle(
                                          color: getWheelColor(index),
                                          borderWidth: 0,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 50.0),
                                          child: Text(
                                            controller.choices[index],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    indicators: const [
                                      FortuneIndicator(
                                        alignment: Alignment.topCenter,
                                        child: TriangleIndicator(
                                          color: Colors.indigo,
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 200,
                                height: 50,
                                child: Obx(() => ElevatedButton.icon(
                                  onPressed: controller.isSpinning.value || controller.choices.length < 2
                                      ? null
                                      : controller.spinWheel,
                                  icon: Icon(
                                    controller.isSpinning.value
                                        ? Icons.hourglass_top
                                        : Icons.rotate_right,
                                    size: 24,
                                  ),
                                  label: Text(
                                    controller.isSpinning.value
                                        ? 'กำลังหมุน...'
                                        : 'หมุนวงล้อ',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: Colors.grey[400],
                                  ),
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // ส่วนเพิ่มตัวเลือก
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.format_list_bulleted, color: Colors.indigo),
                            const SizedBox(width: 8),
                            const Text(
                              'จัดการตัวเลือก',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: controller.clearAllChoices,
                              child: const Text(
                                'ลบทั้งหมด',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.help_outline, size: 20),
                              onPressed: () {
                                Get.dialog(
                                  AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    backgroundColor: Colors.white,
                                    elevation: 8,
                                    title: const Text(
                                      'วิธีใช้งาน',
                                      style: TextStyle(color: Colors.indigo),
                                    ),
                                    content: const SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('1. เพิ่มตัวเลือกที่ต้องการสุ่ม'),
                                          Text('2. กดปุ่ม "หมุนวงล้อ" เพื่อสุ่มตัวเลือก'),
                                          Text('3. รอให้วงล้อหยุดหมุน'),
                                          Text('4. ดูผลลัพธ์ในกล่องที่โผล่ขึ้นมา'),
                                          SizedBox(height: 8),
                                          Text('* สามารถลบตัวเลือกโดยการกดปุ่มลบ'),
                                          Text('* สามารถลบตัวเลือกทั้งหมดโดยกดปุ่ม "ลบทั้งหมด"'),
                                          Text('* สามารถตั้งค่าเพิ่มเติมได้ในเมนูการตั้งค่า'),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: const Text(
                                          'เข้าใจแล้ว',
                                          style: TextStyle(color: Colors.indigo),
                                        ),
                                      ),
                                    ],
                                  ),
                                  barrierDismissible: true,
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: textController,
                                decoration: const InputDecoration(
                                  hintText: 'พิมพ์ตัวเลือกที่นี่...',
                                  prefixIcon: Icon(Icons.add_circle_outline),
                                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                                ),
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    controller.addChoice(value);
                                    textController.clear();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                if (textController.text.isNotEmpty) {
                                  controller.addChoice(textController.text);
                                  textController.clear();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('เพิ่ม'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Obx(() {
                            if (controller.choices.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: Text(
                                    'ยังไม่มีตัวเลือก',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              );
                            }
                            
                            return Column(
                              children: List.generate(
                                controller.choices.length,
                                (index) => ListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                  leading: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: getWheelColor(index),
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    controller.choices[index],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                    onPressed: () => controller.removeChoice(index),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // เพิ่มโฆษณาแบนเนอร์ที่ด้านล่าง
          if (_bannerAd != null)
            Container(
              alignment: Alignment.center,
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
    );
  }
}