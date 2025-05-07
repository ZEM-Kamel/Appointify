plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // FlutterFire config
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter Gradle plugin must come last
}

android {
    namespace = "com.example.appointify_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true // ✅ Enable desugaring
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.appointify_app"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    implementation("com.facebook.android:facebook-login:latest.release")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}


flutter {
    source = "../.."
}
