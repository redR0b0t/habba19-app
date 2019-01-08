
const CATEGORIES = [
  'Music',
  'Life Style',
  'Intercollegiate Events',
  'Miscellaneous',
  'Literary and Dramatics',
  'Kannada Vadike',
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
    'MTech - Bio Technology',
    'MTech - Computer Science And Engg',
    'MTech - Computer Networking',
    'MTech - Product Design And Manufacturing',
    'MTech - Machine Design',
    'MTech - Power Systems'
  ],
  College.Acharya_Polytechnic: [
    'Aeronautical',
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
    'B.C.A - Bachelor in Computer Application',
    'M.C.A - Master in Computer Application',
    'B.A - Bachelor Of Arts (Journalism/Psychology)',
    'B.Sc - Electronics',
    'B.Sc - Physics, Chemistry, Maths',
    'B.Sc - F.A.D',
    'M.S - Mass Communication',
    'M.Sc - Chemistry',
    'M.A - English',
    'M.A - Economics',
    'M.Sc - Mathematics',
    'M.Sc - Physics',
    'English Languages',
    'Apparel Design And Fabrication Tech',
    'D.Ed - Diploma In Education',
    'B.Ed - Bachelor Of Education'
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
  ]
};
