import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jourapothole/core/utils/components/app_bar.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/core/utils/constants/app_images.dart';
import 'package:jourapothole/features/glob_widgets/my_map_widget.dart';
import 'package:jourapothole/features/home/controllers/home_controller.dart';
import 'package:jourapothole/features/main_tab/controller/bottom_nav_controller.dart';
import 'package:jourapothole/features/reports/view/components/reports_bottom_sheet.dart';
import 'package:jourapothole/features/reports/view/components/reports_details.dart';
import 'package:jourapothole/features/reports/view/screens/drafs_screen.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final navController = Get.find<BottomNavController>();
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: GlobalAppBar(
        actionChildren: SizedBox.shrink(), // Empty widget for actions
        isShowProfile: true, // Show profile section
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map Section
            SizedBox(
              height: 200.h,
              width: double.infinity,
              child: MyMapWidget(),
            ),
            const SizedBox(height: 16),

            // Buttons Section
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: AppColors.whiteColor,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => const PotholeReportBottomSheet(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Report a Pothole',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.redColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Quick Report',
                      style: TextStyle(color: AppColors.redColor),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Draft Reports Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Draft Reports',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => Get.to(const DrafsScreen()),
                  child: const Text(
                    'SEE ALL',
                    style: TextStyle(color: AppColors.blueColor),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 65.h,
              child: ListView.builder(
                itemCount: 2,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 5.w),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: AppColors.whiteColor,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => const PotholeReportBottomSheet(),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.w),
                      child: Container(
                        height: double.infinity,
                        width: 259.w,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          border: Border.all(
                            width: 1,
                            color: AppColors.primaryLightColor,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.location_on, color: AppColors.blueColor),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('2972 Westheimer Rd. Santa Ana'),
                                  SizedBox(height: 4),
                                  Text(
                                    'Time: 12.30 pm',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Recent Reports Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Reports',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    navController.changePage(3);
                  },
                  child: const Text(
                    'SEE ALL',
                    style: TextStyle(color: AppColors.blueColor),
                  ),
                ),
              ],
            ),

            Expanded(
              // Use Obx to react to changes in allPothole or isLoading
              child: Obx(() {
                // Show loading indicator while fetching
                if (homeController.isLoading.value) {
                  return const Center(child: CupertinoActivityIndicator());
                }
                // Show a message if the list is empty after loading
                else if (homeController.allPothole.isEmpty) {
                  return const Center(
                    child: Text(
                      'No reports found.',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }
                // Show the list if data is available
                else {
                  return ListView.builder(
                    itemCount: homeController.allPothole.length,
                    itemBuilder: (context, index) {
                      final potholeReport = homeController.allPothole[index];

                      return Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: _buildReportCard(
                          potholeReport.issue,
                          potholeReport.location.address,
                          potholeReport.status,
                          potholeReport.status == 'open'
                              ? Colors.red
                              : Colors.green,
                          (potholeReport.images != null &&
                                  potholeReport.images.isNotEmpty)
                              ? potholeReport.images[0]
                              : 'https://placehold.co/600x400',
                          () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: AppColors.whiteColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder:
                                  (context) => ReportProblemBottomSheet(
                                    report: potholeReport,
                                  ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(
    String issueType,
    String location,
    String status,
    Color statusColor,
    String image,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.lightBlueColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Container(
              width: 80.w,
              height: 60.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.greyColor.withOpacity(0.3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  filterQuality: FilterQuality.none,
                  image ?? 'https://placehold.co/600x400',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.error));
                  },
                ),
              ), // Replace with actual image
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Issue type: $issueType',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.blueColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.greyColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        'Issue Update:',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
