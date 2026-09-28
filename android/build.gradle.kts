allprojects {
    repositories {
        // dl.google.com / maven.google.com / repo.maven.apache.org were unreachable from this
        // machine at build time (a firewall sinks those hosts with fake 404s while
        // storage.googleapis.com / pub.dev work). Aliyun mirrors Google Maven and Maven Central,
        // so use the mirrors first; keep the real repos as fallbacks for when the network improves.
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/central") }
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}