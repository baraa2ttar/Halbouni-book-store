import 'package:adv/core/constant/app_assets.dart';
import 'package:adv/core/constant/app_strings.dart';

class AppConstants {
  static const List<String> bookingDates = [
    'Today, 23 Feb',
    'Tomorrow, 24 Feb',
    'Thu, 25 Feb',
    'Fri, 26 Feb',
    'Sat, 27 Feb',
    'Sun, 28 Feb',
    'Mon, 29 Feb',
  ];
  static const List<int> availableSlotsList = [
    0,
    2,
    3,
    5,
    4,
    7,
    5,
  ];
  static const List<String> timeSlotsAfternoon = [
    '1:00 PM',
    '1:30 PM',
    '2:00 PM',
    '2:30 PM',
    '3:00 PM',
    '3:30 PM',
    '4:00 PM',
  ];
  static const List<String> timeSlotsEvening = [
    '5:00 PM',
    '5:30 PM',
    '6:00 PM',
    '6:30 PM',
    '7:00 PM',
  ];


  static final List<String> dayOptions = List.generate(31, (i) => '${i + 1}');

  static const List<String> monthOptions = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  static final List<String> yearOptions = List.generate(
    100,
        (i) => '${DateTime.now().year - i}',
  );

  static const List<String> genderOptions = ['Male', 'Female', 'Others'];
}



// Mock Data:
final List<Map<String, dynamic>> diagnosticsList = [
  {
    'cardTitle': AppStrings.diagnosticsFirstTitle,
    'cardSubtitle': AppStrings.diagnosticsSubtitle,
    'numberOfTests': 69,
    'image': AppAssets.img5,
      'price': 350,
    'offPrice': 330,
    'percentageOff': 35,
  },
  {
    'cardTitle': AppStrings.diagnosticsFirstTitle,
    'cardSubtitle':AppStrings.diagnosticsSubtitle,
    'numberOfTests': 30,
    'image':AppAssets.img7,
        'price': 250,
    'offPrice': 230,
    'percentageOff': 20,
  },

  {
    'cardTitle': AppStrings.diagnosticsFirstTitle,
    'cardSubtitle':AppStrings.diagnosticsSubtitle,
    'numberOfTests': 30,
    'image':AppAssets.img4,
    'price': 250,
    'offPrice': 230,
    'percentageOff': 20,
  },

];

  List<Map<String, String>> kFakeDoctors = [
  {
    "image": AppAssets.img15,
    "name": "Dr. Pediatrician",
    "specialty": "Specialist Cardiologist",
  },
  {
    "image": AppAssets.img14,
    "name": "Dr. Mistry Brick",
    "specialty": "Specialist Dentist",
  },
  {
    "image": AppAssets.img2,
    "name": "Dr. Ether Wall",
    "specialty": "Specialist Cancer",
  },
  {
    "image": AppAssets.img13,
    "name": "Dr. Johan smith",
    "specialty": "Specialist cardiologist",
  },
  {
    "image": AppAssets.img13,
    "name": "Dr. Johan smith",
    "specialty": "Pediatrician",
  },
];

  final  List<Map<String, dynamic>> doctorsList = [
    {
      'name': 'Dr. Shruti Kedia',
      'specialization': 'Tooths Dentis',
      'experience': '8 Years experience',
      'image': AppAssets.img1,
      'rating': 87.0,
      'stories': '69 Patient Stories',
      'time': '10:00 ',
      'day': 'AM tomorrow',
    },
    {
      'name': 'Dr. Watamaniuk',
      'specialization': 'Tooths Dentist',
      'experience': '9 Years experience',
      'image': AppAssets.img6,
      'rating': 59.0,
      'stories': '82 Patient Stories',
      'time': '12:00 ',
      'day': 'PM today',
    },
    {
      'name': 'Dr. Crownover',
      'specialization': 'Tooths Dentis',
      'experience': '5 Years experience',
      'image': AppAssets.img3,
      'rating': 57.0,
      'stories': '76 Patient Stories',
      'time': '11:00 ',
      'day': 'PM tomorrow',
    },
    {
      'name': 'Dr. Balestra',
      'specialization': 'Tooths Dentis',
      'experience': '6 Years experience',
      'image': AppAssets.img6,
      'rating': 90.0,
      'stories': '48 Patient Stories',
      'time': '4:00 ',
      'day': 'PM tomorrow',
    },
  ];


