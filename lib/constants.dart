
const CATEGORIES = [
  'Music',
  'Life Style',
  'Intercollegiate Events',
  'Miscellaneous',
  'Literary and Dramatics',
  'Acharya Kannada Vedike',
  'Management Events',
  'Design and Digital Arts',
  'Gaming',
  'Technical',
  'Adventure Sport',
  'Photography',
  'Marketing'
];

const YEARS = [
  'First Year',
  'Second Year',
  'Third Year',
  'Fourth Year'
];

const SKILLS = [
  'Design',
  'Art',
  'Content Writing',
  'Video Editing',
  'Creative Thinking',
  'Web Development',
  'App Development',
  'Graffiti',
  'Photography',
  'Videography',
  'Emcee',
  'Poster Making',
  'Photo Editing',
  'Digital Marketing',
];

enum College {
  Acharya_Institute_Of_Technology,
  Acharya_NRV_School_Of_Architecture,
  Acharya_and_BM_Reddy_College_Of_Pharmacy,
  Acharya_School_Of_Management,
  Acharya_Polytechnic,
  Acharya_Institute_Of_Graduate_Studies,
  Smt_Nagarathnamma_School_Of_Nursing,
  Acharya_Pre_University_College,
  Acharya_School_Of_Design,
  Acharya_School_Of_Law,
  Acharya_College_Of_Education,
  CPRD
}

const Map<College, List<String>> DEPARTMENTS = {
  College.CPRD: [
    'CPRD'
  ],
  College.Acharya_Institute_Of_Technology: [
    'Aeronautical',
    'Automobile',
    'Bio Technology',
    'Computer Science',
    'Civil Engineering',
    'Construction Technology & Management',
    'Electrical And Electronics',
    'Electronics And Communication',
    'Information Science',
    'Mechanical Engineering',
    'Mechatronics',
    'Mining',
    'Manufacturing Science And Engg',
    'Master of Business Administration',
    'Master of Computer Application',
    'MTech - Cyber Forensics and Information Security',
    'MTech - Computer Networking',
    'MTech - Computer Science And Engg',
    'MTech - Power Systems',
    'MTech - Digital Communication',
    'MTech - Product Design And Manufacturing',
    'MTech - Bio Technology',
    'MTech - Machine Design',
  ],
  College.Acharya_Polytechnic: [
    'Aeronautical',
    'Architecture',
    'Automobile',
    'Apparel Design And Fabrication Tech',
    'Computer Science',
    'Civil Engineering',
    'Commercial Practice',
    'Electrical And Electronics',
    'Electronics And Communication',
    'Mechanical Engineering',
    'Mechatronics',
    'Mining',
  ],
  College.Acharya_Institute_Of_Graduate_Studies: [
    'B.B.A',
    'B.B.A International Immersion',
    'B.C.A - Bachelor in Computer Application',
    'Bachelor Of Commerce',
    'Apparel Design And Fabrication Tech',
    'Bachelor Of Social Work',
    'B.A - Bachelor Of Arts',
    'B.A - Bachelor Of Arts In Journalism',
    'Bachelor Of Science',
    'Master Of International Business',
    'Master Of Finance And Accounting',
    'Master Of Commerce',
    'M.Sc - Physics',
    'M.Sc - Chemistry',
    'M.Sc - Mathematics',
    'M.Sc - Psychology',
    'M.Sc - Fashion and Apparel Design',
    'M.Sc - Electronic Media',
    'M.A - English',
    'M.A - Economics',
    'M.A - Journalism And Mass Communication',
    'Master Of Social Work',
  ],
  College.Acharya_and_BM_Reddy_College_Of_Pharmacy: [
    'D.Pharm',
    'B.Pharm',
    'M.Pharm',
    'Pharm D',
  ],
  College.Smt_Nagarathnamma_School_Of_Nursing: [
    'Diploma in Nursing',
    'B.Sc - Nursing',
    'Post B.Sc - Nursing',
    'M.Sc - Nursing'
  ],
  College.Acharya_Pre_University_College: [
    'P.C.M.B',
    'P.C.M.C',
    'P.C.M.E',
    'C.E.B.A'
  ],
  College.Acharya_NRV_School_Of_Architecture: [
    'Bachelor Of Architecture'
  ],
  College.Acharya_School_Of_Management: [
    'P.G.D.M',
    'M.B.A',
    'M.F.A',
    'M.I.B',
    'B.B.M'
  ],
  College.Acharya_School_Of_Design: [
    'Bachelor Degree',
    'Master Degree'
  ],
  College.Acharya_School_Of_Law: [
    'BBA LLB',
    'BA LLB',
    'LLB',
  ],
  College.Acharya_College_Of_Education: [
    'B.Ed',
    'D.Ed'
  ]
};

const double kBannerTitleFontSize = 40.0;
const double kBannerSubTitleFontSize = 25.0;
const double kValueWidgetFontSize = 25.0;
