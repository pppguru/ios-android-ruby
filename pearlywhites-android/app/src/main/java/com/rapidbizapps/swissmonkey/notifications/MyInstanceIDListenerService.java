package com.rapidbizapps.swissmonkey.notifications;

import android.content.Intent;

import com.google.android.gms.iid.InstanceIDListenerService;

/**
 * Created by mlanka on 23-03-2016.
 */
public class MyInstanceIDListenerService extends InstanceIDListenerService {

    @Override
    public void onTokenRefresh() {
        Intent intent = new Intent(this,RegistrationIntentService.class);
        startService(intent);
    }
}
