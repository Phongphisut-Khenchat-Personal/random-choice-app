import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../controllers/choice_controller.dart';
import '../services/ad_service.dart';

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
      adUnitId: AdService.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Failed to load banner ad: $error');
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
        Colors.blueGrey[200],
        Colors.blueGrey[300],
        Colors.blueGrey[400],
        Colors.blueGrey[500],
        Colors.blueGrey[600],
        Colors.blueGrey[700],
      ];
      return colors[index % colors.length]!;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'วงล้อ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 20),
            tooltip: 'ตั้งค่า',
            onPressed: () {
              Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ตั้งค่า',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Obx(() => SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'ลบตัวเลือกหลังหมุน',
                            style: TextStyle(fontSize: 14),
                          ),
                          subtitle: const Text(
                            'ลบตัวเลือกที่สุ่มได้ทันที',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          value: controller.removeAfterSpin.value,
                          activeColor: Colors.blueGrey,
                          onChanged: (value) => controller.toggleRemoveAfterSpin(value),
                        )),
                        const SizedBox(height: 10),
                        Obx(() => SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'รีเซ็ตหลังหมุน',
                            style: TextStyle(fontSize: 14),
                          ),
                          subtitle: const Text(
                            'ล้างตัวเลือกทั้งหมดหลังหมุน',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          value: controller.resetAfterSpin.value,
                          activeColor: Colors.blueGrey,
                          onChanged: (value) => controller.toggleResetAfterSpin(value),
                        )),
                      ],
                    ),
                  ),
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Obx(() {
                        if (controller.choices.isEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_circle_outline,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'เพิ่มตัวเลือก',
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        if (controller.choices.length == 1) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'เพิ่มตัวเลือกอย่างน้อย 2 รายการ\nเพื่อหมุนวงล้อ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        return FortuneWheel(
                          physics: CircularPanPhysics(
                            duration: const Duration(seconds: 3),
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
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          indicators: const [
                            FortuneIndicator(
                              alignment: Alignment.topCenter,
                              child: TriangleIndicator(
                                color: Colors.blueGrey,
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => GestureDetector(
                    onTap: controller.isSpinning.value || controller.choices.isEmpty
                        ? null
                        : () async {
                            await Future.delayed(Duration.zero);
                            controller.spinWheel();
                          },
                    child: Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        color: controller.isSpinning.value || controller.choices.isEmpty
                            ? Colors.grey[300]
                            : Colors.blueGrey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        controller.isSpinning.value ? 'กำลังหมุน...' : 'หมุน',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'ตัวเลือก',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey,
                              ),
                            ),
                            const Spacer(),
                            Obx(() => GestureDetector(
                              onTap: controller.choices.isEmpty ? null : () => controller.clearAllChoices(),
                              child: Text(
                                'ลบทั้งหมด',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: controller.choices.isEmpty ? Colors.grey : Colors.red,
                                ),
                              ),
                            )),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Get.dialog(
                                  Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    backgroundColor: Colors.white,
                                    child: const Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'วิธีใช้งาน',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            '1. เพิ่มตัวเลือกที่ต้องการสุ่ม\n'
                                            '2. กดปุ่ม "หมุน" เพื่อสุ่ม\n'
                                            '3. รอผลลัพธ์\n\n'
                                            '* สามารถลบตัวเลือกโดยกดไอคอนถังขยะ\n'
                                            '* สามารถลบทั้งหมดได้ที่ปุ่ม "ลบทั้งหมด"\n'
                                            '* ตั้งค่าเพิ่มเติมได้ที่ไอคอนการตั้งค่า',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  barrierDismissible: true,
                                );
                              },
                              child: const Icon(
                                Icons.help_outline,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: textController,
                                decoration: const InputDecoration(
                                  hintText: 'เพิ่มตัวเลือก (คั่นด้วยช่องว่าง)',
                                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                                ),
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    controller.addChoice(value);
                                    textController.clear();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                if (textController.text.isNotEmpty) {
                                  controller.addChoice(textController.text);
                                  textController.clear();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'เพิ่ม',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Obx(() {
                          if (controller.choices.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: Text(
                                  'ไม่มีตัวเลือก',
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ),
                            );
                          }
                          
                          return Column(
                            children: List.generate(
                              controller.choices.length,
                              (index) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: getWheelColor(index),
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        controller.choices[index],
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => controller.removeChoice(index),
                                      child: const Icon(
                                        Icons.delete_outline,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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