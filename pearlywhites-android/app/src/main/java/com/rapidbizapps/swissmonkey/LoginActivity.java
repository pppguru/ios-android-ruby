package com.rapidbizapps.swissmonkey;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;
import com.google.gson.JsonObject;
import com.rapidbizapps.swissmonkey.Services.RetroHelper;
import com.rapidbizapps.swissmonkey.notifications.RegistrationIntentService;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.DialogUtility;
import com.rapidbizapps.swissmonkey.utility.PreferencesData;
import com.rapidbizapps.swissmonkey.utility.Utility;
import com.rba.MaterialEditText;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper;

public class LoginActivity extends AppCompatActivity {

    private static final String TAG = LoginActivity.class.getSimpleName();
    Context context;
    Activity activity;
    @BindView(R.id.et_username)
    com.rba.MaterialEditText et_username;
    @BindView(R.id.et_password)
    MaterialEditText et_password;
    private static final int PLAY_SERVICES_RESOLUTION_REQUEST = 533;
    private BroadcastReceiver approvedReceiver;
    private View.OnClickListener statusListener;

    private String mRegToken;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        ButterKnife.bind(this);

        context = LoginActivity.this;
        activity = LoginActivity.this;
        Utility.hideKeyboard(LoginActivity.this);

        approvedReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                Log.d(TAG, "onReceive: " + "msg received");


                if (intent.getAction().equals("REG_TOKEN")) {
                    mRegToken = intent.getStringExtra("reg_token");
                    Log.d("receiver", "Got message: " + mRegToken);
                    loginUser();
                }

                //createNotification(intent.getStringExtra(Constants.NOTIFICATION));
            }
        };

        statusListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                JsonObject jsonObject = new JsonObject();
                jsonObject.addProperty(Constants.AUTH_TOKEN_KEY, PreferencesData.getString(context, Constants.AUTHORIZATION_KEY, ""));
                RetroHelper.getBaseClassService(context, "", "").activateUser(jsonObject, new Callback<JsonObject>() {
                    @Override
                    public void success(JsonObject jsonObject, Response response) {
                        sendRegistrationToken();
                    }

                    @Override
                    public void failure(RetrofitError error) {
                        if (error != null && error.getResponse() != null && error.getResponse().getStatus() == 501) {
                            Utility.showAppUpdateAlert((Activity) context);
                        } else {
                            DialogUtility.showDialogWithOneButton((Activity) context, Constants.APP_NAME, "Unable to reactivate. Please try later");
                        }
                        // TODO: 02-07-2016 show Snackbar instead of alert. bad UX!
                    }
                });
            }
        };


    }

    private boolean checkPlayServices() {
        GoogleApiAvailability apiAvailability = GoogleApiAvailability.getInstance();
        int resultCode = apiAvailability.isGooglePlayServicesAvailable(this);
        if (resultCode != ConnectionResult.SUCCESS) {
            if (apiAvailability.isUserResolvableError(resultCode)) {
                apiAvailability.getErrorDialog(this, resultCode, PLAY_SERVICES_RESOLUTION_REQUEST).show();
            } else {
                Log.i(TAG, "This device is not supported.");
            }
            return false;
        }
        return true;
    }


    @OnClick(R.id.tv_registerNow)
    public void onRegisterNowClick() {
        Log.d(TAG, "onRegisterNowClick: ");
        Intent intent = new Intent(context, RegisterActivity.class);
        startActivity(intent);
        finish();
    }

    @OnClick(R.id.iv_login)
    public void onLoginClick() {
        Log.d(TAG, "onLoginClick: ");
        if (checkPlayServices()) {
            if (Utility.isConnectingToInternet(context)) {
                Utility.showProgressDialog(context);
                Intent registrationIntent = new Intent(this, RegistrationIntentService.class);
                startService(registrationIntent);
            } else {
                DialogUtility.showDialogWithOneButton(LoginActivity.this, Constants.APP_NAME, getString(R.string.check_internet));
            }
        }
    }

    @OnClick(R.id.tv_forgotPassword)
    public void onForgotPasswordClick() {
        Log.d(TAG, "onForgotPasswordClick: ");
        DialogUtility.showDialogWithEditText(activity);
    }


    public void loginUser() {
        String authHeader = PreferencesData.getString(LoginActivity.this, Constants.AUTHORIZATION_KEY, "");
        JsonObject loginUserJsonObject = new JsonObject();

        if (et_username.getText().toString().length() == 0) {
            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, Constants.REQUIRED_FIELDS);
        } else if (et_password.getText().toString().length() == 0) {
            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, Constants.REQUIRED_FIELDS);
        } else if (!Utility.isValidEmail(et_username.getText().toString().trim())) {
            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, Constants.INVALID_EMAIL);
        } else {

            loginUserJsonObject.addProperty("username", et_username.getText().toString().trim());
            loginUserJsonObject.addProperty("password", et_password.getText().toString());

            if (Utility.isConnectingToInternet(context)) {
                Utility.showProgressDialog(context);
                RetroHelper.getBaseClassService(context, "", authHeader).loginUser(loginUserJsonObject, new Callback<JsonObject>() {
                    @Override
                    public void success(JsonObject jsonObject, Response response) {
                        if (jsonObject != null && jsonObject.toString().length() > 0) {
                            Utility.dismissDialog();
                            PreferencesData.saveString(context, Constants.AUTHORIZATION_KEY, jsonObject.get("authtoken").getAsString());
                            PreferencesData.saveString(context, Constants.USERNAME, et_username.getText().toString().trim());
                            if (jsonObject.get("UserBlockedStatus") != null
                                    && jsonObject.get("UserBlockedStatus").getAsString().equalsIgnoreCase("User Blocked")) {
//                                DialogUtility.showDialogWithTwoButtons((Activity) context, Constants.APP_NAME, getString(R.string.account_deactivated_alert), statusListener, "YES", "NO");
                                DialogUtility.showDialogWithOneButton((Activity) context, Constants.APP_NAME, getString(R.string.account_blocked_alert));
                                PreferencesData.clearPreferences(LoginActivity.this);
                            } else if (jsonObject.has(Constants.PRIVACY_POLICY_STATUS_KEY) && !jsonObject.get(Constants.PRIVACY_POLICY_STATUS_KEY).getAsBoolean()) {
                                DialogUtility.showTermsAndConditionsDialog((Activity) context, true, null); //true to post status
                            } else {
                                sendRegistrationToken();
                            }
                        }
                    }

                    @Override
                    public void failure(RetrofitError retrofitError) {
                        Utility.dismissDialog();
                        Utility.serviceCallFailureMessage(retrofitError, activity);
                    }
                });
            } else {
                DialogUtility.showDialogWithOneButton(activity, Constants.NO_NETWORK_HEADER, Constants.NO_NETWORK);
            }
        }
    }

    private void sendRegistrationToken() {
        Log.d(TAG, "sendRegistrationToken: " + PreferencesData.getString(context, Constants.REGISTRATION_TOKEN, ""));
        JsonObject gcmObject = new JsonObject();
        gcmObject.addProperty(Constants.AUTH_TOKEN_KEY, PreferencesData.getString(context, Constants.AUTHORIZATION_KEY, ""));
        gcmObject.addProperty(Constants.TOKEN, PreferencesData.getString(context, Constants.REGISTRATION_TOKEN, ""));
        gcmObject.addProperty(Constants.DEVICE_TYPE, Constants.ANDROID);
        RetroHelper.getBaseClassService(context, "", "").sendRegistrationToken(gcmObject, new Callback<JsonObject>() {
            @Override
            public void success(JsonObject jsonObject, Response response) {
                Log.d(TAG, "success: sent token");
                Intent i = new Intent(context, HomeActivity.class);
                startActivity(i);
                finish();
            }

            @Override
            public void failure(RetrofitError error) {
                if (error != null && error.getResponse() != null && error.getResponse().getStatus() == 501) {
                    Utility.showAppUpdateAlert((Activity) context);
                } else {
                    Intent i = new Intent(context, HomeActivity.class);
                    startActivity(i);
                    finish();
                }
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        IntentFilter intentFiler = new IntentFilter();
        intentFiler.addAction(Constants.MESSAGE_RECEIVED);
        intentFiler.addAction("REG_TOKEN");

        this.registerReceiver(approvedReceiver, intentFiler);
    }

    @Override
    protected void onPause() {
        this.unregisterReceiver(approvedReceiver);
        super.onPause();
    }

    void showVerifyEmailDialog(final Activity activity, String header, String msg) {
        final android.app.Dialog dialog = new android.app.Dialog(activity);
        dialog.getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        dialog.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);
        dialog.setContentView(R.layout.dialog_single_button_layout);
        //   dialog.getWindow().setBackgroundDrawableResource(android.R.color.white);
        TextView title = (TextView) dialog.findViewById(R.id.dialog_title);
        title.setText(header);
        TextView messageText = (TextView) dialog.findViewById(R.id.messageText);
        messageText.setText(msg);
        dialog.findViewById(R.id.btOK).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Log.d(TAG, "onClick: verified email");
                et_password.setText("");
                et_username.setText("");
                dialog.dismiss();
            }
        });
        dialog.show();
    }

    @Override
    protected void attachBaseContext(Context newBase) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase));
    }

}
