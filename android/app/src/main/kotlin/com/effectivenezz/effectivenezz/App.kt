package com.effectivenezz.effectivenezz

import android.app.Application
import android.util.Log

//import drift.com.drift.Drift

import com.google.android.gms.security.ProviderInstaller
import drift.com.drift.Drift
import drift.com.drift.helpers.LoggerListener
import io.flutter.app.FlutterApplication


/**
 * Created by eoin on 31/08/2017.
 */

class App : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()
        updateAndroidSecurityProvider()
        Drift.setupDrift(this, "yr4ewu8np62t")
    }


    //Only needed for API 19
    private fun updateAndroidSecurityProvider() {
        try {
            ProviderInstaller.installIfNeeded(this)
        } catch (t: Throwable) {
            t.printStackTrace()
            Log.e("SecurityException", "Google Play Services not available.")
        }

    }
}