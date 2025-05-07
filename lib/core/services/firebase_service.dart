import 'package:appointify_app/core/services/database_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService implements DatabaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static FirebaseAuth get auth => _auth;
  static FirebaseFirestore get firestore => _firestore;
  static FirebaseStorage get storage => _storage;

  @override
  Future<void> addData(
      {required String path,
        required Map<String, dynamic> data,
        String? documentId}) async {
    if (documentId != null) {
      firestore.collection(path).doc(documentId).set(data);
    } else {
      await firestore.collection(path).add(data);
    }
  }

  @override
  Future<dynamic> getData(
      {required String path,
        String? documentId,
        Map<String, dynamic>? query}) async {
    if (documentId != null) {
      var data = await firestore.collection(path).doc(documentId).get();
      return data.data();
    } else {
      Query<Map<String, dynamic>> data = firestore.collection(path);
      if (query != null) {
        if (query['orderBy'] != null) {
          var orderByField = query['orderBy'];
          var descending = query['descending'];
          data = data.orderBy(orderByField, descending: descending);
        }
        if (query['limit'] != null) {
          var limit = query['limit'];
          data = data.limit(limit);
        }
      }
      var result = await data.get();
      return result.docs.map((e) => e.data()).toList();
    }
  }

  @override
  Future<bool> checkIfDataExists(
      {required String path, required String documentId}) async {
    var data = await firestore.collection(path).doc(documentId).get();
    return data.exists;
  }

  @override
  Future<void> updateData({
    required String path,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await firestore.collection(path).doc(documentId).update(data);
  }

  // Specialists Collection
  static CollectionReference get specialistsCollection => 
      _firestore.collection('specialists');

  // Categories Collection
  static CollectionReference get categoriesCollection => 
      _firestore.collection('categories');

  // Appointments Collection
  static CollectionReference get appointmentsCollection => 
      _firestore.collection('appointments');

  // Users Collection
  static CollectionReference get usersCollection => 
      _firestore.collection('users');

  // Reviews Collection
  static CollectionReference get reviewsCollection => 
      _firestore.collection('reviews');

  // Helper Methods
  static Future<void> addSpecialist(Map<String, dynamic> data) async {
    final docRef = specialistsCollection.doc();
    await docRef.set({
      ...data,
      'id': docRef.id,
    });
  }

  static Future<void> addCategory(Map<String, dynamic> data) async {
    await categoriesCollection.add(data);
  }

  static Future<void> updateSpecialistCount(String categoryId, int count) async {
    await categoriesCollection.doc(categoryId).update({
      'specialistsCount': count,
    });
  }

  static Future<void> migrateMockData() async {
    // Add categories first
    final categories = [
      {
        'name': 'Medical',
        'icon': 'medical_services',
        'description': 'Doctors & Specialists',
        'color': '#E3F2FD',
        'specializations': [
          'Cardiologist',
          'Neurologist',
          'Pediatrician',
          'Dermatologist',
        ],
        'specialistsCount': 3,
        'isActive': true,
      },
      {
        'name': 'Fitness',
        'icon': 'fitness_center',
        'description': 'Trainers & Coaches',
        'color': '#E8F5E9',
        'specializations': [
          'Personal Trainer',
          'Yoga Instructor',
          'Nutritionist',
          'Sports Coach',
        ],
        'specialistsCount': 3,
        'isActive': true,
      },
      {
        'name': 'Consulting',
        'icon': 'business',
        'description': 'Business & Finance',
        'color': '#FFF3E0',
        'specializations': [
          'Business Consultant',
          'Financial Advisor',
          'Career Coach',
          'Marketing Expert',
        ],
        'specialistsCount': 3,
        'isActive': true,
      },
      {
        'name': 'Education',
        'icon': 'school',
        'description': 'Tutors & Teachers',
        'color': '#F3E5F5',
        'specializations': [
          'Mathematics Tutor',
          'Language Instructor',
          'Science Educator',
          'Music Teacher',
        ],
        'specialistsCount': 3,
        'isActive': true,
      },
      {
        'name': 'Therapy',
        'icon': 'psychology',
        'description': 'Mental Health',
        'color': '#E8EAF6',
        'specializations': [
          'Clinical Psychologist',
          'Marriage Counselor',
          'Child Psychologist',
          'Behavioral Therapist',
        ],
        'specialistsCount': 3,
        'isActive': true,
      },
      {
        'name': 'Legal',
        'icon': 'gavel',
        'description': 'Lawyers & Attorneys',
        'color': '#FCE4EC',
        'specializations': [
          'Family Lawyer',
          'Corporate Lawyer',
          'Criminal Defense',
          'Immigration Lawyer',
        ],
        'specialistsCount': 3,
        'isActive': true,
      },
    ];

    // Add categories to Firestore
    for (var category in categories) {
      await addCategory(category);
    }

    // Add specialists
    final specialists = [
      // Medical Specialists
      {
        'name': 'Dr. Sarah Johnson',
        'specialization': 'Cardiologist',
        'category': 'Medical',
        'bio': 'Experienced cardiologist with over 15 years of practice. Specializes in heart disease prevention and treatment.',
        'imageUrl': 'https://img.freepik.com/fotos-premium/retrato-confiante-jovem-medica-feminina-em-um-fundo-branco-gerado-por-ia_943087-2803.jpg?w=740',
        'rating': 4.8,
        'reviewsCount': 120,
        'isAvailable': true,
        'workingDays': [
          {
            'day': 'Monday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
          {
            'day': 'Wednesday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
          {
            'day': 'Friday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
        ],
      },
      {
        'name': 'Dr. Michael Chen',
        'specialization': 'Neurologist',
        'category': 'Medical',
        'bio': 'Board-certified neurologist specializing in movement disorders and neuro-degenerative diseases.',
        'imageUrl': 'https://hips.hearstapps.com/hmg-prod/images/portrait-of-a-happy-young-doctor-in-his-clinic-royalty-free-image-1661432441.jpg?crop=0.66698xw:1xh;center,top&resize=1200:*',
        'rating': 4.9,
        'reviewsCount': 95,
        'isAvailable': true,
        'workingDays': [
          {
            'day': 'Tuesday',
            'startTime': '10:00',
            'endTime': '18:00',
          },
          {
            'day': 'Thursday',
            'startTime': '10:00',
            'endTime': '18:00',
          },
        ],
      },
      {
        'name': 'Dr. Emily Davis',
        'specialization': 'Dermatologist',
        'category': 'Medical',
        'bio': 'Board-certified dermatologist specializing in skin care and cosmetic procedures.',
        'imageUrl': 'https://img.freepik.com/premium-photo/beautiful-smiling-female-doctor-stand-office_151013-12509.jpg?w=740',
        'rating': 4.7,
        'reviewsCount': 150,
        'isAvailable': true,
        'workingDays': [
          {
            'day': 'Monday',
            'startTime': '10:00',
            'endTime': '18:00',
          },
          {
            'day': 'Wednesday',
            'startTime': '10:00',
            'endTime': '18:00',
          },
          {
            'day': 'Friday',
            'startTime': '10:00',
            'endTime': '18:00',
          },
        ],
      },

      // Fitness Specialists
      {
        'name': 'Alex Thompson',
        'specialization': 'Personal Trainer',
        'category': 'Fitness',
        'bio': 'Certified personal trainer with expertise in strength training and weight loss programs.',
        'imageUrl': 'https://i0.wp.com/imaginewithrashid.com/wp-content/uploads/2024/06/rashidckk_Photo_of_a_personal_trainer_facing_the_camera_in_pr_f166d693-9dfc-4c8d-907d-ee9ceada4ddb_3.webp?resize=771%2C1024&ssl=1',
        'rating': 4.8,
        'reviewsCount': 85,
        'isAvailable': true,
        'workingDays': [
          {
            'day': 'Monday',
            'startTime': '06:00',
            'endTime': '20:00',
          },
          {
            'day': 'Wednesday',
            'startTime': '06:00',
            'endTime': '20:00',
          },
          {
            'day': 'Friday',
            'startTime': '06:00',
            'endTime': '20:00',
          },
        ],
      },
      {
        'name': 'Emma Wilson',
        'specialization': 'Yoga Instructor',
        'category': 'Fitness',
        'bio': 'Experienced yoga instructor specializing in Vinyasa and Hatha yoga practices.',
        'imageUrl': 'https://images.stockcake.com/public/3/f/c/3fc0bad2-3ab3-4859-8c10-4d0c0c7f2379_large/peaceful-morning-meditation-stockcake.jpg',
        'rating': 4.9,
        'reviewsCount': 110,
        'isAvailable': true,
        'workingDays': [
          {
            'day': 'Tuesday',
            'startTime': '07:00',
            'endTime': '19:00',
          },
          {
            'day': 'Thursday',
            'startTime': '07:00',
            'endTime': '19:00',
          },
          {
            'day': 'Saturday',
            'startTime': '08:00',
            'endTime': '14:00',
          },
        ],
      },
      {
        'name': 'David Lee',
        'specialization': 'Nutritionist',
        'category': 'Fitness',
        'bio': 'Registered dietitian helping clients achieve their health goals through proper nutrition.',
        'imageUrl': 'https://static.tumblr.com/8ga6oi7/g7fm7ddzk/29929_1436858515415_3357711_n.jpg',
        'rating': 4.7,
        'reviewsCount': 75,
        'isAvailable': true,
        'workingDays': [
          {
            'day': 'Tuesday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
          {
            'day': 'Thursday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
          {
            'day': 'Saturday',
            'startTime': '10:00',
            'endTime': '14:00',
          },
        ],
      },

      // Consulting Specialists
      {
        'name': 'Lisa Chen',
        'specialization': 'Business Consultant',
        'category': 'Consulting',
        'bio': 'Strategic business consultant helping companies optimize their operations and increase profitability.',
        'imageUrl': 'https://img.freepik.com/fotos-premium/seria-pensativa-jovem-mulher-bonita-vestindo-camisa-branca-sentir-se-como-cool-empresario-confiante-cruzar-as-maos_343960-31601.jpg?w=740',
        'rating': 4.8,
        'reviewsCount': 90,
        'isAvailable': true,
        'workingDays': [
          {
            'day': 'Monday',
            'startTime': '10:00',
            'endTime': '18:00',
          },
          {
            'day': 'Wednesday',
            'startTime': '10:00',
            'endTime': '18:00',
          },
          {
            'day': 'Friday',
            'startTime': '10:00',
            'endTime': '18:00',
          },
        ],
      },
      {
        'name': 'Robert Taylor',
        'specialization': 'Financial Advisor',
        'category': 'Consulting',
        'bio': 'Certified financial planner helping clients achieve their financial goals.',
        'imageUrl': 'https://img.freepik.com/fotos-gratis/retrato-de-um-homem-sorridente-sentado-em-um-cafe-bar-com-seu-laptop_342744-944.jpg?t=st=1746478963~exp=1746482563~hmac=e9cc2e046dc592600a5c3c670adc24b013a631e380110b54a523deb7764d19a0&w=996',
        'rating': 4.9,
        'reviewsCount': 120,
        'isAvailable': true,
        'workingDays': [
          {
            'day': 'Tuesday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
          {
            'day': 'Thursday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
          {
            'day': 'Saturday',
            'startTime': '10:00',
            'endTime': '14:00',
          },
        ],
      },
      {
        'name': 'Jennifer Adams',
        'specialization': 'Career Coach',
        'category': 'Consulting',
        'bio': 'Professional career coach helping individuals achieve their career aspirations.',
        'imageUrl': 'https://camillestyles.com/wp-content/uploads/2023/03/catt-sadler-redefine-success-683x1024.jpg',
        'rating': 4.7,
        'reviewsCount': 85,
        'isAvailable': true,
        'workingDays': [
          {
            'day': 'Monday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
          {
            'day': 'Wednesday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
          {
            'day': 'Friday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
        ],
      },

      // Education Specialists
      {
        'name': 'Dr. Thomas Wilson',
        'specialization': 'Mathematics Tutor',
        'category': 'Education',
        'bio': 'PhD in Mathematics with 10 years of teaching experience.',
        'imageUrl': 'https://img.freepik.com/fotos-premium/professor-masculino-fotorrealista-na-escola-inteligencia-artificial-generativa_446633-190888.jpg?w=740',
        'rating': 4.8,
        'reviewsCount': 95,
        'isAvailable': true,
        'workingDays': [
          {
            'day': 'Monday',
            'startTime': '14:00',
            'endTime': '20:00',
          },
          {
            'day': 'Wednesday',
            'startTime': '14:00',
            'endTime': '20:00',
          },
          {
            'day': 'Friday',
            'startTime': '14:00',
            'endTime': '20:00',
          },
        ],
      },
      {
        'name': 'Maria Garcia',
        'specialization': 'Language Instructor',
        'category': 'Education',
        'bio': 'Certified language instructor specializing in English and Spanish.',
        'imageUrl': 'https://changesparksjoy.com/wp-content/uploads/2025/02/teacher-outfits-with-heels.png',
        'rating': 4.9,
        'reviewsCount': 110,
        'isAvailable': true,
        'workingDays': [
          {
            'day': 'Tuesday',
            'startTime': '15:00',
            'endTime': '21:00',
          },
          {
            'day': 'Thursday',
            'startTime': '15:00',
            'endTime': '21:00',
          },
          {
            'day': 'Saturday',
            'startTime': '10:00',
            'endTime': '16:00',
          },
        ],
      },
      {
        'name': 'Dr. Richard Chen',
        'specialization': 'Science Educator',
        'category': 'Education',
        'bio': 'Experienced science teacher with expertise in physics and chemistry.',
        'imageUrl': 'https://64.media.tumblr.com/185a51412d649e62a34169afc37b55ce/tumblr_mz8puw5GFf1rxhfixo1_500.jpg',
        'rating': 4.7,
        'reviewsCount': 85,
        'isAvailable': true,
        'workingDays': [
          {
            'day': 'Monday',
            'startTime': '16:00',
            'endTime': '22:00',
          },
          {
            'day': 'Wednesday',
            'startTime': '16:00',
            'endTime': '22:00',
          },
          {
            'day': 'Friday',
            'startTime': '16:00',
            'endTime': '22:00',
          },
        ],
      },

      // Therapy Specialists
      {
        'name': 'Dr. Sarah Thompson',
        'specialization': 'Clinical Psychologist',
        'category': 'Therapy',
        'bio': 'Licensed clinical psychologist specializing in cognitive-behavioral therapy.',
        'imageUrl': 'https://images.squarespace-cdn.com/content/v1/61aebd273db458125282f926/1506128d-8fd9-4d1e-bf9d-517e60112c0c/Chartered+Clinical+Psychologist%2C+CBT+Therapist+%26+ACT+Coach?format=2500w',
        'rating': 4.8,
        'reviewsCount': 100,
        'isAvailable': true,
        'workingDays': [
          {
            'day': 'Monday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
          {
            'day': 'Wednesday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
          {
            'day': 'Friday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
        ],
      },
      {
        'name': 'Dr. Michael Rodriguez',
        'specialization': 'Marriage Counselor',
        'category': 'Therapy',
        'bio': 'Experienced marriage and family therapist helping couples strengthen their relationships.',
        'imageUrl': 'https://img.freepik.com/fotos-gratis/homem-de-meia-idade-vestindo-uma-jaqueta-rindo-feliz_150588-72.jpg?t=st=1746479618~exp=1746483218~hmac=9dbb2a43ca141d068d21f6e85d72d7df1996b02ba9560627d6aa71f64c0b8a75&w=740',
        'rating': 4.9,
        'reviewsCount': 95,
        'isAvailable': true,
        'workingDays': [
          {
            'day': 'Tuesday',
            'startTime': '10:00',
            'endTime': '18:00',
          },
          {
            'day': 'Thursday',
            'startTime': '10:00',
            'endTime': '18:00',
          },
          {
            'day': 'Saturday',
            'startTime': '09:00',
            'endTime': '13:00',
          },
        ],
      },
      {
        'name': 'Dr. Emily Wilson',
        'specialization': 'Child Psychologist',
        'category': 'Therapy',
        'bio': 'Specialized in child psychology and developmental disorders.',
        'imageUrl': 'https://img.freepik.com/free-photo/smiling-portrait-girl-female-psychologist-having-conversation-office_23-2148026293.jpg?t=st=1746479645~exp=1746483245~hmac=c89519e5c0f0cfadd233ed04887d632e379559242c03c9a5bc5a40d1897ddbaf&w=996',
        'rating': 4.7,
        'reviewsCount': 80,
        'isAvailable': true,
        'workingDays': [
          {
            'day': 'Monday',
            'startTime': '08:00',
            'endTime': '16:00',
          },
          {
            'day': 'Wednesday',
            'startTime': '08:00',
            'endTime': '16:00',
          },
          {
            'day': 'Friday',
            'startTime': '08:00',
            'endTime': '16:00',
          },
        ],
      },

      // Legal Specialists
      {
        'name': 'John Smith',
        'specialization': 'Family Lawyer',
        'category': 'Legal',
        'bio': 'Experienced family lawyer specializing in divorce and child custody cases.',
        'imageUrl': 'https://i.pinimg.com/736x/db/32/85/db3285b95dd1a9b0804799fc8e0657cf.jpg',
        'rating': 4.8,
        'reviewsCount': 90,
        'isAvailable': true,
        'workingDays': [
          {
            'day': 'Monday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
          {
            'day': 'Wednesday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
          {
            'day': 'Friday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
        ],
      },
      {
        'name': 'Elizabeth Brown',
        'specialization': 'Corporate Lawyer',
        'category': 'Legal',
        'bio': 'Expert in corporate law and business contracts.',
        'imageUrl': 'https://img.freepik.com/free-photo/portrait-female-lawyer-formal-suit-with-clipboard_23-2148915798.jpg?ga=GA1.1.528061003.1746278443&semt=ais_hybrid&w=740',
        'rating': 4.9,
        'reviewsCount': 110,
        'isAvailable': true,
        'workingDays': [
          {
            'day': 'Tuesday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
          {
            'day': 'Thursday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
          {
            'day': 'Saturday',
            'startTime': '10:00',
            'endTime': '14:00',
          },
        ],
      },
      {
        'name': 'David Johnson',
        'specialization': 'Criminal Defense',
        'category': 'Legal',
        'bio': 'Experienced criminal defense attorney with a strong track record.',
        'imageUrl': 'https://img-aig.sea187.com/v1/300/20240805/a6559ec4-551d-411e-a34a-5cb1c97dcc88_1-DPlWJxKFB8PKkFVg.webp',
        'rating': 4.7,
        'reviewsCount': 85,
        'isAvailable': true,
        'workingDays': [
          {
            'day': 'Monday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
          {
            'day': 'Wednesday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
          {
            'day': 'Friday',
            'startTime': '09:00',
            'endTime': '17:00',
          },
        ],
      },
    ];

    // Add specialists to Firestore
    for (var specialist in specialists) {
      await addSpecialist(specialist);
    }
  }

  // Search specialists by name
  static Future<List<Map<String, dynamic>>> searchSpecialists(String query) async {
    try {
      final snapshot = await specialistsCollection
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();
      
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error searching specialists: $e');
      return [];
    }
  }

  // Get specialists by category and rating
  static Future<List<Map<String, dynamic>>> getSpecialistsByCategoryAndRating(
    String category, {
    int limit = 10,
  }) async {
    try {
      final snapshot = await specialistsCollection
          .where('category', isEqualTo: category)
          .orderBy('rating', descending: true)
          .limit(limit)
          .get();
      
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error getting specialists by category: $e');
      return [];
    }
  }
} 