package com.rapidbizapps.swissmonkey.notifications;

/**
 * Created by mlanka on 30-06-2016.
 */

import android.app.IntentService;
import android.content.Intent;
import android.content.SharedPreferences;
import android.util.Log;

import com.google.android.gms.gcm.GoogleCloudMessaging;
import com.google.android.gms.iid.InstanceID;

import java.io.IOException;


import android.app.IntentService;
import android.content.Intent;
import android.content.SharedPreferences;
import android.util.Log;

import com.google.android.gms.gcm.GcmPubSub;
import com.google.android.gms.gcm.GoogleCloudMessaging;
import com.google.android.gms.iid.InstanceID;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.PreferencesData;

import java.io.IOException;


public class RegistrationIntentService extends IntentService {

    private static final String TAG = RegistrationIntentService.class.getSimpleName();


    SharedPreferences mSharedPreferences;

    private static final String[] TOPICS = {"global"};

    public RegistrationIntentService(String name) {
        super(name);

    }

    public RegistrationIntentService() {
        super("harry_potter");

    }

    @Override
    protected void onHandleIntent(Intent intent) {
        InstanceID instanceID = InstanceID.getInstance(this);

        try {
            String token = instanceID.getToken(Constants.SENDER_ID, GoogleCloudMessaging.INSTANCE_ID_SCOPE);
            PreferencesData.saveString(this, Constants.REGISTRATION_TOKEN, token);

            Intent broadcastIntent = new Intent("REG_TOKEN");
            broadcastIntent.putExtra("reg_token", token);
            this.sendBroadcast(broadcastIntent);


            Log.d(TAG, token);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}