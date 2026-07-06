package com.example.sound_detective.util

import android.content.Context
import android.content.pm.PackageManager

object PackageLabelResolver {
    fun labelFor(context: Context, packageName: String): String {
        return try {
            val pm = context.packageManager
            val appInfo = pm.getApplicationInfo(packageName, 0)
            pm.getApplicationLabel(appInfo).toString()
        } catch (e: PackageManager.NameNotFoundException) {
            packageName
        }
    }
}
