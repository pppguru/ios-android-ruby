package com.rapidbizapps.swissmonkey;

import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;

import com.flurry.android.FlurryAgent;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.gcm.GoogleCloudMessaging;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.PreferencesData;

import java.io.IOException;

public class SplashActivity extends AppCompatActivity {

    static final String TAG = "SplashActivity";
    private static final int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;
    private static int SPLASH_TIME_OUT = 1000;
    private Context context;
    private GoogleCloudMessaging gcm;
    private String regid;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);
        context = SplashActivity.this;

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {

                String authKey = PreferencesData.getString(context, Constants.AUTHORIZATION_KEY, "");
                if (authKey != null && authKey.length() > 0) {
                    Intent i = new Intent(SplashActivity.this, HomeActivity.class);
                    startActivity(i);
                    PreferencesData.saveBoolean(context, Constants.DOWNLOAD_VIDEOS, false); //user already logged in. Do not download videos
                    // overridePendingTransition(R.anim.fade_in, R.anim.fade_out);
                    finish();
                } else {
                    //    Intent i = new Intent(SplashActivity.this, LoginActivity.class);
                    Intent i = new Intent(SplashActivity.this, LoginActivity.class);
                    PreferencesData.saveBoolean(context, Constants.DOWNLOAD_VIDEOS, true); //user not logged in. Download files
                    startActivity(i);
                    finish();
                }

                //Registering to the GCM services
                //setUpGCMServices();

            }
        }, SPLASH_TIME_OUT);
    }

    @Override
    public void onBackPressed() {
    }

    @Override
    protected void onResume() {
        super.onResume();
        // Check device for Play Services APK.
        // checkPlayServices();
    }

    private void setUpGCMServices() {
        context = getApplicationContext();

        // Check device for Play Services APK. If check succeeds, proceed with GCM registration.
        if (checkPlayServices()) {
            gcm = GoogleCloudMessaging.getInstance(this);
            regid = getRegistrationId(context);

            if (regid.isEmpty()) {
                registerInBackground();
            } else {
                sendRegistrationIdToBackend(regid);
            }
        } else {
            Log.i(TAG, "No valid Google Play Services APK found.");
            Intent i = new Intent(SplashActivity.this, RegisterActivity.class);
            startActivity(i);
            finish();
        }
    }

    /**
     * Check the device to make sure it has the Google Play Services APK. If
     * it doesn't, display a dialog that allows users to download the APK from
     * the Google Play Store or enable it in the device's system settings.
     */
    private boolean checkPlayServices() {
        int resultCode = GooglePlayServicesUtil.isGooglePlayServicesAvailable(this);
        if (resultCode != ConnectionResult.SUCCESS) {
            if (GooglePlayServicesUtil.isUserRecoverableError(resultCode)) {
                GooglePlayServicesUtil.getErrorDialog(resultCode, this,
                        PLAY_SERVICES_RESOLUTION_REQUEST).show();
            } else {
                Log.i(TAG, "This device is not supported.");
                finish();
            }
            return false;
        }
        return true;
    }

    /**
     * Gets the current registration ID for application on GCM service, if there is one.
     * If result is empty, the app needs to register.
     *
     * @return registration ID, or empty string if there is no existing registration ID.
     */
    private String getRegistrationId(Context context) {
        //    final SharedPreferences prefs = getGcmPreferences(context);
        String registrationId = PreferencesData.getString(context, Constants.PROPERTY_REG_ID, "");
        Log.i(TAG, "Registration ID: " + registrationId);
        if (registrationId.isEmpty()) {
            Log.i(TAG, "Registration not found.");
            // registrationId="";
            return "";
        }
        /**
         * Check if app was updated; if so, it must clear the registration ID
         * since the existing regID is not guaranteed to work with the new app version.
         */
        int registeredVersion = PreferencesData.getInt(context, Constants.PROPERTY_APP_VERSION, Integer.MIN_VALUE);
        int currentVersion = getAppVersion(context);
        if (registeredVersion != currentVersion) {
            Log.i(TAG, "App version changed.");
            //  registrationId= "";
            return "";
        }
        return registrationId;
    }

    /**
     * @return Application's version code from the {@code PackageManager}.
     */
    private static int getAppVersion(Context context) {

            /*PackageInfo packageInfo = context.getPackageManager()
                    .getPackageInfo(context.getPackageName(), 0);*/
        return 400;

    }

    /**
     * Registers the application with GCM servers asynchronously.
     * Stores the registration ID and the app versionCode in the application's
     * shared preferences.
     */
    private void registerInBackground() {
        new AsyncTask<Void, Void, String>() {
            @Override
            protected String doInBackground(Void... params) {
                String msg = "";
                try {
                    if (gcm == null) {
                        gcm = GoogleCloudMessaging.getInstance(context);
                    }
                    regid = gcm.register(Constants.SENDER_IDENTITY);
                    msg = "Device registered, registration ID=" + regid;

                    // You should send the registration ID to your server over HTTP, so it
                    // can use GCM/HTTP or CCS to send messages to your app.
                    sendRegistrationIdToBackend(regid);

                    // For this demo: we don't need to send it because the device will send
                    // upstream messages to a server that echo back the message using the
                    // 'from' address in the message.

                    // Persist the regID - no need to register again.
                    //storeRegistrationId(context, regid);
                    PreferencesData.saveString(context, Constants.PROPERTY_REG_ID, regid);
                } catch (IOException ex) {
                    msg = "Error :" + ex.getMessage();
                    // If there is an error, don't just keep trying to register.
                    // Require the user to click a button again, or perform
                    // exponential back-off.
                }
                return msg;
            }

            @Override
            protected void onPostExecute(String msg) {
                //mDisplay.append(msg + "\n");
                Intent i = new Intent(SplashActivity.this, RegisterActivity.class);
                startActivity(i);
                finish();
            }
        }.execute(null, null, null);
    }


    /**
     * Sends the registration ID to your server over HTTP, so it can use GCM/HTTP or CCS to send
     * messages to your app. Not needed for this demo since the device sends upstream messages
     * to a server that echoes back the message using the 'from' address in the message.
     */
    private void sendRegistrationIdToBackend(String regId) {

    /*    //int randomHeaderIndex = new Random().nextInt(Constants.headersArray.length);
        //String randomHeader = (Constants.headersArray[randomHeaderIndex]);
        String android_id = Settings.Secure.getString(getContentResolver(),
                Settings.Secure.ANDROID_ID);
        Log.d("SUCCESS AND DEVICE ID",android_id);

        JsonObject deviceDataJsonObj = new JsonObject();
        deviceDataJsonObj.addProperty("deviceId",regId);
        deviceDataJsonObj.addProperty("deviceType","ANDROID");
        deviceDataJsonObj.addProperty("username",randomUserName);
        deviceDataJsonObj.addProperty("password",randomPassword);

        if(Utility.isConnectingToInternet(context)){

            Utility.showProgressDialog(context);
            Log.d(TAG, "getTasksDataFromServer: " + user.getAuthToken());
            ServiceHelper service = RetroHelper.getService(mAuthToken, context);

            util.getBaseClassService(Constants.userEndPoint,null).deviceRegisterPostCall(deviceDataJsonObj, new Callback<JsonObject>() {
                @Override
                public void success(JsonObject jsonObject, Response response) {
                    if(jsonObject!=null)
                    {
                        Log.d("SUCCESS authorizedToken",jsonObject.toString());
                        try {
                            JSONObject responseJson = new JSONObject(jsonObject.toString());
                            Log.d("authToken",responseJson.get("authToken").toString());
                            PreferencesData.saveString(SplashActivity.this,Constants.authorizationKey,
                                    responseJson.get("authToken").toString());
                        } catch (JSONException e) {
                            e.printStackTrace();
                            PreferencesData.saveString(SplashActivity.this,Constants.authorizationKey,"");
                        }

                        Intent i = new Intent(SplashActivity.this, AboutrBAActivity.class);
                        startActivity(i);
                        finish();
                    }

                }

                @Override
                public void failure(RetrofitError retrofitError) {
                    if(retrofitError!=null)
                    {
                        Log.d("FAILURE DEVICE ID", "");
                        Intent i = new Intent(SplashActivity.this, AboutrBAActivity.class);
                        startActivity(i);
                        finish();

                        //  util.dismissDialog();
                        //  util.serviceCallFailureMessage(retrofitError, context);
                    }

                }
            });
        }else{
            Log.d("Network error","No network connection");
            Intent i = new Intent(SplashActivity.this, AboutrBAActivity.class);
            startActivity(i);
            finish();
        }

*/
    }

    @Override
    protected void onStart() {
        super.onStart();
        FlurryAgent.onStartSession(this, Constants.FLURRY_APIKEY);

    }

    @Override
    protected void onStop() {
        super.onStop();
        FlurryAgent.onEndSession(this);

    }

}
