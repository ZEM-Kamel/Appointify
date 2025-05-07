import 'package:appointify_app/features/specialists/domain/entities/specialist_entity.dart';

class MockSpecialists {
  static List<SpecialistEntity> _allSpecialists = [];

  static final List<SpecialistEntity> medicalSpecialists = [
    SpecialistEntity(
      id: '1',
      name: 'Dr. Sarah Johnson',
      specialization: 'Cardiologist',
      category: 'Medical',
      bio: 'Experienced cardiologist with over 15 years of practice. Specializes in heart disease prevention and treatment.',
      workingDays: [
        WorkingDayEntity(day: 'Monday', startTime: '09:00', endTime: '17:00'),
        WorkingDayEntity(day: 'Wednesday', startTime: '09:00', endTime: '17:00'),
        WorkingDayEntity(day: 'Friday', startTime: '09:00', endTime: '17:00'),
      ],
      imageUrl: 'https://img.freepik.com/fotos-premium/retrato-confiante-jovem-medica-feminina-em-um-fundo-branco-gerado-por-ia_943087-2803.jpg?w=740',
      rating: 4.8,
      reviewsCount: 156,
    ),
    SpecialistEntity(
      id: '2',
      name: 'Dr. Michael Chen',
      specialization: 'Neurologist',
      category: 'Medical',
      bio: 'Board-certified neurologist specializing in movement disorders and neuro-degenerative diseases.',
      workingDays: [
        WorkingDayEntity(day: 'Tuesday', startTime: '10:00', endTime: '18:00'),
        WorkingDayEntity(day: 'Thursday', startTime: '10:00', endTime: '18:00'),
      ],
      imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/portrait-of-a-happy-young-doctor-in-his-clinic-royalty-free-image-1661432441.jpg?crop=0.66698xw:1xh;center,top&resize=1200:*',
      rating: 4.9,
      reviewsCount: 203,
    ),
  ];

  static final List<SpecialistEntity> fitnessSpecialists = [
    SpecialistEntity(
      id: '3',
      name: 'Alex Thompson',
      specialization: 'Personal Trainer',
      category: 'Fitness',
      bio: 'Certified personal trainer with expertise in strength training and weight loss programs.',
      workingDays: [
        WorkingDayEntity(day: 'Monday', startTime: '06:00', endTime: '20:00'),
        WorkingDayEntity(day: 'Wednesday', startTime: '06:00', endTime: '20:00'),
        WorkingDayEntity(day: 'Friday', startTime: '06:00', endTime: '20:00'),
      ],
      imageUrl: 'https://i0.wp.com/imaginewithrashid.com/wp-content/uploads/2024/06/rashidckk_Photo_of_a_personal_trainer_facing_the_camera_in_pr_f166d693-9dfc-4c8d-907d-ee9ceada4ddb_3.webp?resize=771%2C1024&ssl=1',
      rating: 4.7,
      reviewsCount: 89,
    ),
    SpecialistEntity(
      id: '4',
      name: 'Emma Wilson',
      specialization: 'Yoga Instructor',
      category: 'Fitness',
      bio: 'Experienced yoga instructor specializing in Vinyasa and Hatha yoga practices.',
      workingDays: [
        WorkingDayEntity(day: 'Tuesday', startTime: '07:00', endTime: '19:00'),
        WorkingDayEntity(day: 'Thursday', startTime: '07:00', endTime: '19:00'),
        WorkingDayEntity(day: 'Saturday', startTime: '08:00', endTime: '14:00'),
      ],
      imageUrl: 'https://images.stockcake.com/public/3/f/c/3fc0bad2-3ab3-4859-8c10-4d0c0c7f2379_large/peaceful-morning-meditation-stockcake.jpg',
      rating: 4.9,
      reviewsCount: 124,
    ),
  ];

  static final List<SpecialistEntity> consultingSpecialists = [
    SpecialistEntity(
      id: '5',
      name: 'Lisa Chen',
      specialization: 'Business Consultant',
      category: 'Consulting',
      bio: 'Strategic business consultant with expertise in digital transformation and process optimization.',
      workingDays: [
        WorkingDayEntity(day: 'Monday', startTime: '09:00', endTime: '17:00'),
        WorkingDayEntity(day: 'Wednesday', startTime: '09:00', endTime: '17:00'),
        WorkingDayEntity(day: 'Friday', startTime: '09:00', endTime: '17:00'),
      ],
      imageUrl: 'https://img.freepik.com/fotos-premium/seria-pensativa-jovem-mulher-bonita-vestindo-camisa-branca-sentir-se-como-cool-empresario-confiante-cruzar-as-maos_343960-31601.jpg?w=740',
      rating: 4.6,
      reviewsCount: 78,
    ),
  ];

  static final List<SpecialistEntity> educationSpecialists = [
    SpecialistEntity(
      id: '6',
      name: 'Dr. Thomas Wilson',
      specialization: 'Mathematics Tutor',
      category: 'Education',
      bio: 'Mathematics professor with 20 years of teaching experience, specializing in advanced calculus and statistics.',
      workingDays: [
        WorkingDayEntity(day: 'Tuesday', startTime: '14:00', endTime: '20:00'),
        WorkingDayEntity(day: 'Thursday', startTime: '14:00', endTime: '20:00'),
        WorkingDayEntity(day: 'Saturday', startTime: '10:00', endTime: '16:00'),
      ],
      imageUrl: 'https://changesparksjoy.com/wp-content/uploads/2025/02/teacher-outfits-with-heels.png',
      rating: 4.8,
      reviewsCount: 95,
    ),
  ];

  static final List<SpecialistEntity> therapySpecialists = [
    SpecialistEntity(
      id: '7',
      name: 'Dr. James Wilson',
      specialization: 'Psychologist',
      category: 'Therapy',
      bio: 'Licensed psychologist specializing in cognitive behavioral therapy and stress management.',
      workingDays: [
        WorkingDayEntity(day: 'Monday', startTime: '10:00', endTime: '18:00'),
        WorkingDayEntity(day: 'Wednesday', startTime: '10:00', endTime: '18:00'),
        WorkingDayEntity(day: 'Friday', startTime: '10:00', endTime: '18:00'),
      ],
      imageUrl: 'https://img.freepik.com/fotos-gratis/homem-de-meia-idade-vestindo-uma-jaqueta-rindo-feliz_150588-72.jpg?t=st=1746479618~exp=1746483218~hmac=9dbb2a43ca141d068d21f6e85d72d7df1996b02ba9560627d6aa71f64c0b8a75&w=740',
      rating: 4.7,
      reviewsCount: 112,
    ),
  ];

  static final List<SpecialistEntity> legalSpecialists = [
    SpecialistEntity(
      id: '8',
      name: 'John Smith',
      specialization: 'Family Law',
      category: 'Legal',
      bio: 'Experienced family law attorney specializing in divorce, child custody, and adoption cases.',
      workingDays: [
        WorkingDayEntity(day: 'Tuesday', startTime: '09:00', endTime: '17:00'),
        WorkingDayEntity(day: 'Thursday', startTime: '09:00', endTime: '17:00'),
      ],
      imageUrl: 'https://i.pinimg.com/736x/db/32/85/db3285b95dd1a9b0804799fc8e0657cf.jpg',
      rating: 4.9,
      reviewsCount: 167,
    ),
  ];

  static List<SpecialistEntity> getAllSpecialists() {
    if (_allSpecialists.isEmpty) {
      _allSpecialists = [
        ...medicalSpecialists,
        ...fitnessSpecialists,
        ...consultingSpecialists,
        ...educationSpecialists,
        ...therapySpecialists,
        ...legalSpecialists,
      ];
    }
    return _allSpecialists;
  }

  static List<SpecialistEntity> getPopularSpecialists() {
    return [
      medicalSpecialists[0],
      fitnessSpecialists[0],
      consultingSpecialists[0],
      educationSpecialists[0],
      therapySpecialists[0],
      legalSpecialists[0],
    ];
  }

  static List<SpecialistEntity> getMedicalSpecialists() {
    return [
      SpecialistEntity(
        id: '1',
        name: 'Dr. Sarah Johnson',
        specialization: 'Cardiologist',
        category: 'Medical',
        bio: 'Experienced cardiologist with over 15 years of practice. Specializes in heart disease prevention and treatment.',
        workingDays: [
          WorkingDayEntity(day: 'Monday', startTime: '09:00', endTime: '17:00'),
          WorkingDayEntity(day: 'Wednesday', startTime: '09:00', endTime: '17:00'),
          WorkingDayEntity(day: 'Friday', startTime: '09:00', endTime: '17:00'),
        ],
        imageUrl: 'https://img.freepik.com/fotos-premium/retrato-confiante-jovem-medica-feminina-em-um-fundo-branco-gerado-por-ia_943087-2803.jpg?w=740',
        rating: 4.8,
        reviewsCount: 156,
      ),
      SpecialistEntity(
        id: '4',
        name: 'Dr. Michael Brown',
        specialization: 'Pediatrician',
        category: 'Medical',
        bio: 'Caring pediatrician with expertise in child development and preventive care.',
        workingDays: [
          WorkingDayEntity(day: 'Tuesday', startTime: '08:00', endTime: '16:00'),
          WorkingDayEntity(day: 'Thursday', startTime: '08:00', endTime: '16:00'),
          WorkingDayEntity(day: 'Saturday', startTime: '09:00', endTime: '13:00'),
        ],
        imageUrl: 'https://img.freepik.com/premium-photo/male-doctor-light-surface_392895-24691.jpg?w=740',
        rating: 4.7,
        reviewsCount: 98,
      ),
      SpecialistEntity(
        id: '5',
        name: 'Dr. Emily Davis',
        specialization: 'Dermatologist',
        category: 'Medical',
        bio: 'Board-certified dermatologist specializing in skin care and cosmetic procedures.',
        workingDays: [
          WorkingDayEntity(day: 'Monday', startTime: '10:00', endTime: '18:00'),
          WorkingDayEntity(day: 'Wednesday', startTime: '10:00', endTime: '18:00'),
          WorkingDayEntity(day: 'Friday', startTime: '10:00', endTime: '18:00'),
        ],
        imageUrl: 'https://img.freepik.com/premium-photo/beautiful-smiling-female-doctor-stand-office_151013-12509.jpg?w=740',
        rating: 4.9,
        reviewsCount: 203,
      ),
    ];
  }

  static List<SpecialistEntity> getFitnessSpecialists() {
    return [
      SpecialistEntity(
        id: '2',
        name: 'James Wilson',
        specialization: 'Personal Trainer',
        category: 'Fitness',
        bio: 'Certified personal trainer with expertise in strength training and weight loss programs.',
        workingDays: [
          WorkingDayEntity(day: 'Tuesday', startTime: '07:00', endTime: '19:00'),
          WorkingDayEntity(day: 'Thursday', startTime: '07:00', endTime: '19:00'),
          WorkingDayEntity(day: 'Saturday', startTime: '08:00', endTime: '14:00'),
        ],
        imageUrl: 'https://i0.wp.com/imaginewithrashid.com/wp-content/uploads/2024/06/rashidckk_Photo_of_a_personal_trainer_facing_the_camera_in_pr_f166d693-9dfc-4c8d-907d-ee9ceada4ddb_3.webp?resize=771%2C1024&ssl=1',
        rating: 4.7,
        reviewsCount: 89,
      ),
      SpecialistEntity(
        id: '6',
        name: 'Sophia Martinez',
        specialization: 'Yoga Instructor',
        category: 'Fitness',
        bio: 'Experienced yoga instructor specializing in Hatha and Vinyasa yoga.',
        workingDays: [
          WorkingDayEntity(day: 'Monday', startTime: '06:00', endTime: '20:00'),
          WorkingDayEntity(day: 'Wednesday', startTime: '06:00', endTime: '20:00'),
          WorkingDayEntity(day: 'Friday', startTime: '06:00', endTime: '20:00'),
        ],
        imageUrl: 'https://images.stockcake.com/public/3/f/c/3fc0bad2-3ab3-4859-8c10-4d0c0c7f2379_large/peaceful-morning-meditation-stockcake.jpg',
        rating: 4.9,
        reviewsCount: 124,
      ),
      SpecialistEntity(
        id: '7',
        name: 'David Lee',
        specialization: 'Nutritionist',
        category: 'Fitness',
        bio: 'Registered dietitian helping clients achieve their health goals through proper nutrition.',
        workingDays: [
          WorkingDayEntity(day: 'Tuesday', startTime: '09:00', endTime: '17:00'),
          WorkingDayEntity(day: 'Thursday', startTime: '09:00', endTime: '17:00'),
          WorkingDayEntity(day: 'Saturday', startTime: '10:00', endTime: '14:00'),
        ],
        imageUrl: 'https://static.tumblr.com/8ga6oi7/g7fm7ddzk/29929_1436858515415_3357711_n.jpg',
        rating: 4.8,
        reviewsCount: 76,
      ),
    ];
  }

  static List<SpecialistEntity> getConsultingSpecialists() {
    return [
      SpecialistEntity(
        id: '3',
        name: 'Lisa Chen',
        specialization: 'Business Consultant',
        category: 'Consulting',
        bio: 'Strategic business consultant helping companies optimize their operations and increase profitability.',
        workingDays: [
          WorkingDayEntity(day: 'Monday', startTime: '10:00', endTime: '18:00'),
          WorkingDayEntity(day: 'Wednesday', startTime: '10:00', endTime: '18:00'),
          WorkingDayEntity(day: 'Friday', startTime: '10:00', endTime: '18:00'),
        ],
        imageUrl: 'https://img.freepik.com/fotos-premium/seria-pensativa-jovem-mulher-bonita-vestindo-camisa-branca-sentir-se-como-cool-empresario-confiante-cruzar-as-maos_343960-31601.jpg?w=740',
        rating: 4.6,
        reviewsCount: 78,
      ),
      SpecialistEntity(
        id: '8',
        name: 'Robert Taylor',
        specialization: 'Financial Advisor',
        category: 'Consulting',
        bio: 'Certified financial planner helping clients achieve their financial goals.',
        workingDays: [
          WorkingDayEntity(day: 'Tuesday', startTime: '09:00', endTime: '17:00'),
          WorkingDayEntity(day: 'Thursday', startTime: '09:00', endTime: '17:00'),
          WorkingDayEntity(day: 'Saturday', startTime: '10:00', endTime: '14:00'),
        ],
        imageUrl: 'https://img.freepik.com/fotos-gratis/retrato-de-um-homem-sorridente-sentado-em-um-cafe-bar-com-seu-laptop_342744-944.jpg?t=st=1746478963~exp=1746482563~hmac=e9cc2e046dc592600a5c3c670adc24b013a631e380110b54a523deb7764d19a0&w=996',
        rating: 4.7,
        reviewsCount: 92,
      ),
      SpecialistEntity(
        id: '9',
        name: 'Jennifer Adams',
        specialization: 'Career Coach',
        category: 'Consulting',
        bio: 'Professional career coach helping individuals achieve their career aspirations.',
        workingDays: [
          WorkingDayEntity(day: 'Monday', startTime: '09:00', endTime: '17:00'),
          WorkingDayEntity(day: 'Wednesday', startTime: '09:00', endTime: '17:00'),
          WorkingDayEntity(day: 'Friday', startTime: '09:00', endTime: '17:00'),
        ],
        imageUrl: 'https://camillestyles.com/wp-content/uploads/2023/03/catt-sadler-redefine-success-683x1024.jpg',
        rating: 4.8,
        reviewsCount: 67,
      ),
    ];
  }

  static List<SpecialistEntity> getEducationSpecialists() {
    return [
      SpecialistEntity(
        id: '10',
        name: 'Dr. Thomas Wilson',
        specialization: 'Mathematics Tutor',
        category: 'Education',
        bio: 'PhD in Mathematics with 10 years of teaching experience.',
        workingDays: [
          WorkingDayEntity(day: 'Monday', startTime: '14:00', endTime: '20:00'),
          WorkingDayEntity(day: 'Wednesday', startTime: '14:00', endTime: '20:00'),
          WorkingDayEntity(day: 'Friday', startTime: '14:00', endTime: '20:00'),
        ],
        imageUrl: 'https://img.freepik.com/fotos-premium/professor-masculino-fotorrealista-na-escola-inteligencia-artificial-generativa_446633-190888.jpg?w=740',
        rating: 4.8,
        reviewsCount: 95,
      ),
      SpecialistEntity(
        id: '11',
        name: 'Maria Garcia',
        specialization: 'Language Instructor',
        category: 'Education',
        bio: 'Certified language instructor specializing in English and Spanish.',
        workingDays: [
          WorkingDayEntity(day: 'Tuesday', startTime: '15:00', endTime: '21:00'),
          WorkingDayEntity(day: 'Thursday', startTime: '15:00', endTime: '21:00'),
          WorkingDayEntity(day: 'Saturday', startTime: '10:00', endTime: '16:00'),
        ],
        imageUrl: 'https://changesparksjoy.com/wp-content/uploads/2025/02/teacher-outfits-with-heels.png',
        rating: 4.9,
        reviewsCount: 112,
      ),
      SpecialistEntity(
        id: '12',
        name: 'Dr. Richard Chen',
        specialization: 'Science Educator',
        category: 'Education',
        bio: 'Experienced science teacher with expertise in physics and chemistry.',
        workingDays: [
          WorkingDayEntity(day: 'Monday', startTime: '16:00', endTime: '22:00'),
          WorkingDayEntity(day: 'Wednesday', startTime: '16:00', endTime: '22:00'),
          WorkingDayEntity(day: 'Friday', startTime: '16:00', endTime: '22:00'),
        ],
        imageUrl: 'https://64.media.tumblr.com/185a51412d649e62a34169afc37b55ce/tumblr_mz8puw5GFf1rxhfixo1_500.jpg',
        rating: 4.7,
        reviewsCount: 84,
      ),
    ];
  }

  static List<SpecialistEntity> getTherapySpecialists() {
    return [
      SpecialistEntity(
        id: '13',
        name: 'Dr. Sarah Thompson',
        specialization: 'Clinical Psychologist',
        category: 'Therapy',
        bio: 'Licensed clinical psychologist specializing in cognitive-behavioral therapy.',
        workingDays: [
          WorkingDayEntity(day: 'Monday', startTime: '09:00', endTime: '17:00'),
          WorkingDayEntity(day: 'Wednesday', startTime: '09:00', endTime: '17:00'),
          WorkingDayEntity(day: 'Friday', startTime: '09:00', endTime: '17:00'),
        ],
        imageUrl: 'https://images.squarespace-cdn.com/content/v1/61aebd273db458125282f926/1506128d-8fd9-4d1e-bf9d-517e60112c0c/Chartered+Clinical+Psychologist%2C+CBT+Therapist+%26+ACT+Coach?format=2500w',
        rating: 4.7,
        reviewsCount: 112,
      ),
      SpecialistEntity(
        id: '14',
        name: 'Dr. Michael Rodriguez',
        specialization: 'Family Counselor',
        category: 'Therapy',
        bio: 'Experienced family therapist helping them strengthen their relationships.',
        workingDays: [
          WorkingDayEntity(day: 'Tuesday', startTime: '10:00', endTime: '18:00'),
          WorkingDayEntity(day: 'Thursday', startTime: '10:00', endTime: '18:00'),
          WorkingDayEntity(day: 'Saturday', startTime: '09:00', endTime: '13:00'),
        ],
        imageUrl: 'https://img.freepik.com/fotos-gratis/homem-de-meia-idade-vestindo-uma-jaqueta-rindo-feliz_150588-72.jpg?t=st=1746479618~exp=1746483218~hmac=9dbb2a43ca141d068d21f6e85d72d7df1996b02ba9560627d6aa71f64c0b8a75&w=740',
        rating: 4.8,
        reviewsCount: 95,
      ),
      SpecialistEntity(
        id: '15',
        name: 'Dr. Emily Wilson',
        specialization: 'Child Psychologist',
        category: 'Therapy',
        bio: 'Specialized in child psychology and developmental disorders.',
        workingDays: [
          WorkingDayEntity(day: 'Monday', startTime: '08:00', endTime: '16:00'),
          WorkingDayEntity(day: 'Wednesday', startTime: '08:00', endTime: '16:00'),
          WorkingDayEntity(day: 'Friday', startTime: '08:00', endTime: '16:00'),
        ],
        imageUrl: 'https://img.freepik.com/free-photo/smiling-portrait-girl-female-psychologist-having-conversation-office_23-2148026293.jpg?t=st=1746479645~exp=1746483245~hmac=c89519e5c0f0cfadd233ed04887d632e379559242c03c9a5bc5a40d1897ddbaf&w=996',
        rating: 4.9,
        reviewsCount: 78,
      ),
    ];
  }

  static List<SpecialistEntity> getLegalSpecialists() {
    return [
      SpecialistEntity(
        id: '16',
        name: 'John Smith',
        specialization: 'Family Lawyer',
        category: 'Legal',
        bio: 'Experienced family lawyer specializing in divorce and child custody cases.',
        workingDays: [
          WorkingDayEntity(day: 'Monday', startTime: '09:00', endTime: '17:00'),
          WorkingDayEntity(day: 'Wednesday', startTime: '09:00', endTime: '17:00'),
          WorkingDayEntity(day: 'Friday', startTime: '09:00', endTime: '17:00'),
        ],
        imageUrl: 'https://i.pinimg.com/736x/db/32/85/db3285b95dd1a9b0804799fc8e0657cf.jpg',
        rating: 4.9,
        reviewsCount: 167,
      ),
      SpecialistEntity(
        id: '17',
        name: 'Elizabeth Brown',
        specialization: 'Corporate Lawyer',
        category: 'Legal',
        bio: 'Expert in corporate law and business contracts.',
        workingDays: [
          WorkingDayEntity(day: 'Tuesday', startTime: '09:00', endTime: '17:00'),
          WorkingDayEntity(day: 'Thursday', startTime: '09:00', endTime: '17:00'),
          WorkingDayEntity(day: 'Saturday', startTime: '10:00', endTime: '14:00'),
        ],
        imageUrl: 'https://img.freepik.com/free-photo/portrait-female-lawyer-formal-suit-with-clipboard_23-2148915798.jpg?ga=GA1.1.528061003.1746278443&semt=ais_hybrid&w=740',
        rating: 4.7,
        reviewsCount: 89,
      ),
      SpecialistEntity(
        id: '18',
        name: 'David Johnson',
        specialization: 'Criminal Defense',
        category: 'Legal',
        bio: 'Experienced criminal defense attorney with a strong track record.',
        workingDays: [
          WorkingDayEntity(day: 'Monday', startTime: '09:00', endTime: '17:00'),
          WorkingDayEntity(day: 'Wednesday', startTime: '09:00', endTime: '17:00'),
          WorkingDayEntity(day: 'Friday', startTime: '09:00', endTime: '17:00'),
        ],
        imageUrl: 'https://img-aig.sea187.com/v1/300/20240805/a6559ec4-551d-411e-a34a-5cb1c97dcc88_1-DPlWJxKFB8PKkFVg.webp',
        rating: 4.8,
        reviewsCount: 124,
      ),
    ];
  }
} 