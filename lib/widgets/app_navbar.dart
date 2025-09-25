// import 'package:adv/core/exports/ui_exports.dart';
// import 'package:adv/view/doctor_appointment/screens/doctor_appointment_screen.dart';
//
// class AppNavBarView extends StatelessWidget {
//   AppNavBarView({super.key});
//
//   final HomeController controller = Get.put(HomeController());
//
//   final icons = [
//     AppAssets.homeIcon,
//     AppAssets.heartIcon,
//     AppAssets.bookIcon,
//     AppAssets.chatIcon,
//   ];
//
//   final screens = [
//     const HomeMainScreen(),
//     const FavouriteDoctorScreen(),
//     const DoctorsScreen(),
//     const DoctorAppointmentScreen()
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       drawer: CustomDrawer(),
//       backgroundColor: Colors.transparent,
//       body: Stack(
//         children: [
//           Obx(() => Positioned.fill(
//                 child: screens[controller.selectedIndex.value],
//               )),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20.r),
//                     topRight: Radius.circular(20.r)),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColor.blackColor.withOpacity(0.25),
//                     blurRadius: 180,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(icons.length, (index) {
//                   return Obx(() {
//                     final isSelected = controller.selectedIndex.value == index;
//
//                     return GestureDetector(
//                       onTap: () => controller.changeIndex(index),
//                       child: AnimatedContainer(
//                         width: 48.r,
//                         height: 48.r,
//                         duration: const Duration(milliseconds: 200),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? AppColor.primaryColor
//                               : Colors.transparent,
//                           shape: BoxShape.circle,
//                         ),
//                         child: SvgPicture.asset(
//                           icons[index],
//                           colorFilter: ColorFilter.mode(
//                             isSelected
//                                 ? AppColor.whiteColor
//                                 : AppColor.navbarIconColor,
//                             BlendMode.srcIn,
//                           ),
//                         ),
//                       ),
//                     );
//                   });
//                 }),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
