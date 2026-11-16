import java.util.Properties

plugins {
    id("com.android.application")
    // Ditambahkan otomatis oleh `flutterfire configure`:
    // id("com.google.gms.google-services")
    // id("com.google.firebase.crashlytics")
    id("dev.flutter.flutter-gradle-plugin")
}

// Signing release dibaca dari android/key.properties (JANGAN di-commit).
val keystoreProperties = Properties().apply {
    val f = rootProject.file("key.properties")
    if (f.exists()) f.inputStream().use { load(it) }
}

android {
    namespace = "id.pelatihan.tokoku_pro"
    compileSdk = 37 // flutter_local_notifications 23 mensyaratkan compileSdk 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true // wajib untuk flutter_local_notifications
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "id.pelatihan.tokoku_pro"
        minSdk = flutter.minSdkVersion   // 24 di Flutter 3.47
        targetSdk = flutter.targetSdkVersion // 36 = syarat Google Play sejak 31 Agu 2026
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
        // Patrol (Hari 4): runner instrumentasi + data app dibersihkan per test
        testInstrumentationRunner = "pl.leancode.patrol.PatrolJUnitRunner"
        testInstrumentationRunnerArguments["clearPackageData"] = "true"
    }

    testOptions {
        execution = "ANDROIDX_TEST_ORCHESTRATOR"
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = (keystoreProperties["storeFile"] as String?)?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    // AGP 9 mematikan resValue secara default; dibutuhkan untuk app_name per flavor.
    buildFeatures {
        resValues = true
    }

    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "TokoKu DEV")
        }
        create("prod") {
            dimension = "env"
            resValue("string", "app_name", "TokoKu Pro")
        }
    }

    buildTypes {
        release {
            signingConfig = if (keystoreProperties.isEmpty) {
                signingConfigs.getByName("debug") // agar `flutter run --release` lokal tetap jalan
            } else {
                signingConfigs.getByName("release")
            }
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    androidTestUtil("androidx.test:orchestrator:1.5.1")
}

flutter {
    source = "../.."
}
