import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.icore_ess"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.icore_ess"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Production release builds must use the release signing configuration.
            // Fallback to debug signing in release builds is strictly prohibited.
            signingConfig = signingConfigs.getByName("release")

            // Enable R8 for production hardening
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

gradle.taskGraph.whenReady {
    val isReleaseBuild = allTasks.any { task ->
        val name = task.name.lowercase()
        (name.contains("assemblerelease") ||
         name.contains("bundlerelease") ||
         name.contains("packagerelease") ||
         name.contains("signrelease") ||
         name.contains("flutterbuildrelease"))
    }
    if (isReleaseBuild) {
        if (!keystorePropertiesFile.exists()) {
            throw GradleException(
                "RELEASE BUILD ERROR: Production signing configuration 'key.properties' was not found in root project directory. " +
                "Release builds strictly require production signing credentials and will not fall back to debug signing."
            )
        }
        val storeFilePath = keystoreProperties["storeFile"] as String?
        if (storeFilePath.isNullOrBlank() || !file(storeFilePath).exists()) {
            throw GradleException(
                "RELEASE BUILD ERROR: Keystore file '${storeFilePath ?: "unspecified"}' defined in key.properties was not found or not specified. " +
                "Release builds strictly require a valid production keystore."
            )
        }
    }
}
