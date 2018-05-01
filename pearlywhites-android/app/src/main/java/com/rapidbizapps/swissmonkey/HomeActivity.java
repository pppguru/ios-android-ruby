package com.rapidbizapps.swissmonkey;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v7.app.AlertDialog;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonPrimitive;
import com.google.gson.reflect.TypeToken;
import com.netcompss.ffmpeg4android.GeneralUtils;
import com.rapidbizapps.swissmonkey.Services.RetroHelper;
import com.rapidbizapps.swissmonkey.fragments.AboutUsFragment;
import com.rapidbizapps.swissmonkey.fragments.ProfileDetailFragment;
import com.rapidbizapps.swissmonkey.fragments.ProfileFragment;
import com.rapidbizapps.swissmonkey.fragments.SettingsFragment;
import com.rapidbizapps.swissmonkey.fragments.WelcomeFragment;
import com.rapidbizapps.swissmonkey.jobs.AlertsAdapter;
import com.rapidbizapps.swissmonkey.models.Notification;
import com.rapidbizapps.swissmonkey.models.Profile;
import com.rapidbizapps.swissmonkey.profile.ProfileRootFragment;
import com.rapidbizapps.swissmonkey.resideMenu.ResideMenu;
import com.rapidbizapps.swissmonkey.resideMenu.ResideMenuItem;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.DialogUtility;
import com.rapidbizapps.swissmonkey.utility.PreferencesData;
import com.rapidbizapps.swissmonkey.utility.Utility;

import java.io.File;
import java.lang.reflect.Type;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper;

public class HomeActivity extends FragmentActivity implements View.OnClickListener {

    private static final int MY_INITIAL_PERMISSIONS_READ_EXTERNAL_STORAGE = 7781;
    Context context;
    private ResideMenu resideMenu;
    private ResideMenuItem itemWelcome;
    private ResideMenuItem itemProfile;
    private ResideMenuItem itemSettings;
    private ResideMenuItem itemAbout;
    private ResideMenuItem itemlogout;

    TextView header_text;
    ImageView iv_save;

    private JsonArray jobsArray;
    public ArrayList<Notification> mJobs = new ArrayList<>();
    BaseAdapter mAlertsAdapter;

    @BindView(R.id.notification_number_tv)
    TextView notificationNumber_iv;

    @BindView(R.id.notification)
    RelativeLayout jobAlerts_rl;

    private static final String LOG_TAG = "HomeActivity";
    private AlertDialog mAlertDialog;

    //for saving profile
    public String mAuthToken, name, addressLine1, addressLine2, city, state, zip, email, phoneNumber, aboutMe, licenseNumber, languages, salaryMin, salaryMax,
            licenseDate = "", licenseMonth = "", licenseYear = "", newEmail, workAvailabilitydate, otherReqs, otherSoftwareExperience;

    public boolean isNewEmail;
    public JsonArray mShifts = new JsonArray();
    private static final int MY_PERMISSIONS_READ_EXTERNAL_STORAGE = 2;
    Dialog dialog;

    public int mProgress;
    private int number;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);
        GeneralUtils.checkForPermissionsMAndAbove(this, false);
        ButterKnife.bind(this);


      /*  if(getIntent().getStringExtra(Constants.NOTIFICATION_MESSAGE)!=null)
        {
           String msg= getIntent().getStringExtra(Constants.NOTIFICATION_MESSAGE);
            DialogUtility.showDialogWithOneButton(this,Constants.APP_NAME,msg);
        }*/


        mAuthToken = PreferencesData.getString(this, Constants.AUTHORIZATION_KEY, "");
        context = HomeActivity.this;
        initializeUiElements();
        setUpMenu();

        //to avoid asking while logging out
        checkInitialReadPermission();

        if (getIntent() != null && getIntent().hasExtra(Constants.SHOW_PROFILE)) {
            changeFragment(ProfileRootFragment.newInstance());  //directed from advanced job search
        } else {
            if (savedInstanceState == null) {
                changeFragment(new WelcomeFragment());
                setHeaderText(Constants.WELCOME);
            }
        }
        getAlertsFromServer();
    }

    @OnClick(R.id.notification)
    void onAlertClick() {
        // load Profile screen if it is not empty
        if (Profile.getInstance().getZipcode() == null) {
            DialogUtility.completeProfileAlert(this, Constants.APP_NAME, getString(R.string.complete_profile_alert), new DialogUtility.PositiveButtonCallback() {
                @Override
                public void onPositiveButtonClick(Dialog dialog) {
                    changeFragment(ProfileRootFragment.newInstance());
                    dialog.dismiss();
                }
            }, new DialogUtility.NegativeButtonCallback() {
                @Override
                public void onNegativeButtonClick(Dialog dialog) {
                    dialog.dismiss();
                }
            }, "OK", "Cancel");
        } else {
            if (mAlertDialog != null && !mJobs.isEmpty()) {

                mAlertDialog.show();
                //
                PreferencesData.saveInt(context, Constants.NOTIFICATION_NUMBER, mJobs.size());

                DisplayMetrics displaymetrics = new DisplayMetrics();
                getWindowManager().getDefaultDisplay().getMetrics(displaymetrics);
                int height = displaymetrics.heightPixels;
                int width = displaymetrics.widthPixels;
                float mDensity = context.getResources().getDisplayMetrics().density;

                //make it appear right
                Window window = mAlertDialog.getWindow();
                WindowManager.LayoutParams windowAttributes = window.getAttributes();
                windowAttributes.gravity = Gravity.TOP | Gravity.RIGHT;
                windowAttributes.flags &= ~WindowManager.LayoutParams.FLAG_DIM_BEHIND;
                Log.e("---", " mDensity ---" + mDensity);
                int tempHeight = Integer.parseInt(getResources().getString(R.string.alert_dialog_hieght));
                int tempHeight_single = Integer.parseInt(getResources().getString(R.string.alert_dialog_hieght_single));
                int modifiedHeight = 0;
                if (mJobs.size() > 1) {
                    modifiedHeight = Math.round(tempHeight * mDensity);
                } else {
                    modifiedHeight = Math.round(tempHeight_single * mDensity);
                }
                int marginTop = Integer.parseInt(getResources().getString(R.string.alert_dialog_margin_top));
                int modifiedTop = Math.round(mDensity * marginTop);
                Log.e("---", " modifiedTop ---" + modifiedTop);
                windowAttributes.y = modifiedTop;
                window.setLayout(width - Integer.parseInt(getResources().getString(R.string.alert_dialog_width_reduce)), modifiedHeight);
                window.setAttributes(windowAttributes);

                //seding surver call for making nonviewed to viewd if number >0
                if (number > 0) {
                    if (Utility.isConnectingToInternet(HomeActivity.this)) {
                        viewedNotifications();
                    } else {
                        Toast.makeText(HomeActivity.this, "Please check your internet connection", Toast.LENGTH_LONG).show();

                    }
                }


            } else {
                DialogUtility.showDialogWithOneButton((Activity) context, Constants.APP_NAME, getString(R.string.no_notifications));
            }
        }
    }


    private void viewedNotifications() {

        Notification tempNotification = new Notification();
        tempNotification.setViewed("No");
        ArrayList<Integer> idsList = new ArrayList();
        JsonArray notificationsArray = new JsonArray();
        for (Notification notification : mJobs) {
            if (notification.equals(tempNotification)) {
                JsonPrimitive notificationIdPrimitive = new JsonPrimitive(notification.getId());
//                idsList.add(notification.getId());
                notificationsArray.add(notificationIdPrimitive);
            }
        }


        JsonObject requestBody = new JsonObject();
        requestBody.addProperty(Constants.AUTH_TOKEN_KEY, PreferencesData.getString(this, Constants.AUTHORIZATION_KEY, ""));
        requestBody.add(Constants.VIEWED_IDS, notificationsArray);
        RetroHelper.getBaseClassService(context, "", "").viewNotifications(requestBody, new Callback<JsonObject>() {
            @Override
            public void success(JsonObject jsonObject, Response response) {
                if (jsonObject != null) {
                    boolean result = jsonObject.get(Constants.SUCCESS_RESPONSE_KEY).getAsBoolean();

                    try {
                        if (result) {
                            notificationNumber_iv.setVisibility(View.GONE);
                            for (Notification notification : mJobs) {
                                notification.setViewed("Yes");
                            }
                            number = 0;
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                }

            }


            @Override
            public void failure(RetrofitError error) {
                if (error != null && error.getResponse().getStatus() == 501) {
                    Utility.showAppUpdateAlert((Activity) context);
                }

                Utility.serviceCallFailureMessage(error, (Activity) context);
            }
        });
    }


    public void getAlertsFromServer() {
        JsonObject requestBody = new JsonObject();
        requestBody.addProperty(Constants.AUTH_TOKEN_KEY, PreferencesData.getString(this, Constants.AUTHORIZATION_KEY, ""));
        RetroHelper.getBaseClassService(context, "", "").getNotifications(requestBody, new Callback<JsonObject>() {
            @Override
            public void success(JsonObject jsonObject, Response response) {
                if (jsonObject != null) {
                    jobsArray = jsonObject.getAsJsonArray(Constants.SUCCESS_RESPONSE_KEY);
                    Type type = new TypeToken<List<Notification>>() {
                    }.getType();
                    mJobs = new Gson().fromJson(jobsArray.toString(), type);
                    Collections.sort(mJobs, new JobComparator());

                  /*  String json = new Gson().toJson(mJobs);
                   PreferencesData.saveString(HomeActivity.this,Constants.NOTIFICATION,json);*/
                    // Collections.reverse(mJobs);
                }
                setupAlerts();
            }


            @Override
            public void failure(RetrofitError error) {
                if (error != null && error.getResponse() != null && error.getResponse().getStatus() == 501) {
                    Utility.showAppUpdateAlert((Activity) context);
                }

                Utility.serviceCallFailureMessage(error, (Activity) context);
            }
        });
    }

    public class JobComparator implements Comparator {

        @Override
        public int compare(Object lhs, Object rhs) {
            Notification lhsJob = (Notification) lhs;
            Notification rhsJob = (Notification) rhs;
            Date lhsDate = null, rhsDate = null;

            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US);
            try {
                lhsDate = format.parse(lhsJob.getUpdated_at());
                rhsDate = format.parse(rhsJob.getUpdated_at());
            } catch (ParseException e) {
                e.printStackTrace();
            }

            if (rhsDate.after(lhsDate)) {
                return 1;
            }
            return -1;
        }
    }


    private void setupAlerts() {
        mAlertsAdapter = new AlertsAdapter(mJobs, this);
        Log.e("--", "--" + mJobs.size() + "  " + PreferencesData.getInt(context, Constants.NOTIFICATION_NUMBER, 0));
        //number = mJobs.size() - PreferencesData.getInt(context, Constants.NOTIFICATION_NUMBER, 0);
        number = 0;
        Notification tempNotification = new Notification();
        tempNotification.setViewed("No");

        for (Notification notification : mJobs) {
            if (notification.equals(tempNotification)) {
                number++;
            }

        }


        showNotification();
        if (number > 0) {
            notificationNumber_iv.setVisibility(View.VISIBLE);
            notificationNumber_iv.setText(String.valueOf(number));

        } else {
            notificationNumber_iv.setVisibility(View.GONE);
        }

        //store the current value

        mAlertDialog = new AlertDialog.Builder(this)
                .setAdapter(mAlertsAdapter, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {

                    }
                })
                .create();

        mAlertDialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
            @Override
            public void onDismiss(DialogInterface dialog) {
                try {
                    if (mJobs.size() > 25) {
                        int listSize = mJobs.size();
                        for (int i = listSize - 1; i > 24; --i) {
                            mJobs.remove(i);
                        }
                    }
                    mAlertsAdapter.notifyDataSetChanged();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });


        ListView listView = mAlertDialog.getListView();
        listView.setBackground(getResources().getDrawable(R.drawable.alert_list_background));
        listView.setDivider(getResources().getDrawable(R.drawable.alerts_list_divider));
        listView.setDividerHeight(1);


    }

    public void initializeUiElements() {

        iv_save = (ImageView) findViewById(R.id.header_right_image);
        iv_save.setOnClickListener(this);

        header_text = (TextView) findViewById(R.id.header_text);

        //getAlertsFromServer();

    }

    public void setHeaderBackground() {
        ((RelativeLayout) findViewById(R.id.rl_header)).setBackgroundResource(R.color.white);
        //.setBackground(getResources().getColor(R.color.label_textcolor));
    }

    public void setHeaderText(String text) {

        ((TextView) findViewById(R.id.header_text)).setText(text);
    }

    public void showSaveButton() {
        (findViewById(R.id.header_right_image)).setVisibility(View.VISIBLE);
    }

    public void hideSaveButton() {
        (findViewById(R.id.header_right_image)).setVisibility(View.GONE);
    }

    public void showNotification() {
        jobAlerts_rl.setVisibility(View.VISIBLE);
    }

    public void showNotificationNumber() {
        showNotification();

        if (number > 0) {
            notificationNumber_iv.setVisibility(View.VISIBLE);
            notificationNumber_iv.setText(String.valueOf(number));
        } else {
            notificationNumber_iv.setVisibility(View.GONE);
        }

    }


    public void hideNotification() {
        jobAlerts_rl.setVisibility(View.GONE);
    }

    public ImageView getHeaderRightImage() {

        ImageView imageView = (ImageView) findViewById(R.id.header_right_image);

        return imageView;
    }


    public RelativeLayout getNotificationIcon() {
        return jobAlerts_rl;
    }

    private void setUpMenu() {

        // attach to current activity;
        resideMenu = new ResideMenu(this);
        //   resideMenu.setUse3D(true);
        // resideMenu.setBackground(R.drawable.menu_background);
        // resideMenu.setBackground(R.color.edittext_textcolor);
        resideMenu.attachToActivity(this);
        resideMenu.setMenuListener(menuListener);
        //valid scale factor is between 0.0f and 1.0f. leftmenu'width is 150dip.
        //resideMenu.setScaleValue(0.2f);

        // create menu items;
        itemWelcome = new ResideMenuItem(this, "Welcome");
        itemProfile = new ResideMenuItem(this, "Profile");
        itemSettings = new ResideMenuItem(this, "Settings");
        itemAbout = new ResideMenuItem(this, "Support");
        itemlogout = new ResideMenuItem(this, "Sign out");

        itemWelcome.setOnClickListener(this);
        itemProfile.setOnClickListener(this);
        itemSettings.setOnClickListener(this);
        itemAbout.setOnClickListener(this);
        itemlogout.setOnClickListener(this);

        resideMenu.addMenuItem(itemWelcome, ResideMenu.DIRECTION_LEFT);
        resideMenu.addMenuItem(itemProfile, ResideMenu.DIRECTION_LEFT);
        resideMenu.addMenuItem(itemSettings, ResideMenu.DIRECTION_LEFT);
        resideMenu.addMenuItem(itemAbout, ResideMenu.DIRECTION_LEFT);
        resideMenu.addMenuItem(itemlogout, ResideMenu.DIRECTION_LEFT);

        /*resideMenu.addMenuItem(itemCalendar, ResideMenu.DIRECTION_RIGHT);
        resideMenu.addMenuItem(itemSettings, ResideMenu.DIRECTION_RIGHT);*/

        // You can disable a direction by setting ->
        resideMenu.setSwipeDirectionDisable(ResideMenu.DIRECTION_RIGHT);

        findViewById(R.id.title_bar_left_menu).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                resideMenu.openMenu(ResideMenu.DIRECTION_LEFT);
            }
        });
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        return resideMenu.dispatchTouchEvent(ev);
    }


    @Override
    public void onClick(View view) {

        if (view == itemWelcome) {
            header_text.setText(Constants.WELCOME);
            changeFragment(new WelcomeFragment());
            resideMenu.closeMenu();
        } else if (view == itemProfile) {
            header_text.setText(Constants.PROFILE);
            if (mProgress == 20) {
                ProfileDetailFragment profileDetailFragment = new ProfileDetailFragment();
                changeFragment(profileDetailFragment);
            } else {
                ProfileFragment profileFragment = new ProfileFragment();
                Bundle bundle = new Bundle();
                bundle.putInt("progress", mProgress);
                profileFragment.setArguments(bundle);
                changeFragment(profileFragment);
            }
            resideMenu.closeMenu();
        } else if (view == itemSettings) {
            header_text.setText(Constants.SETTINGS);
            changeFragment(new SettingsFragment());
            resideMenu.closeMenu();
        } else if (view == itemAbout) {
            header_text.setText(Constants.SUPPORT);
            changeFragment(new AboutUsFragment());
            resideMenu.closeMenu();
        } else if (view == itemlogout) {
            showDialogForLogout();
            //logoutUser();
            //  changeFragment(new SettingsFragment());
        }


    }


    @Override
    protected void attachBaseContext(Context newBase) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase));
    }


    private ResideMenu.OnMenuListener menuListener = new ResideMenu.OnMenuListener() {
        @Override
        public void openMenu() {
            // Toast.makeText(context, "Menu is opened!", Toast.LENGTH_SHORT).show();
        }

        @Override
        public void closeMenu() {
            //  Toast.makeText(context, "Menu is closed!", Toast.LENGTH_SHORT).show();
        }
    };

    public void changeFragment(Fragment targetFragment) {
        resideMenu.clearIgnoredViewList();
        getSupportFragmentManager()
                .beginTransaction()
                .replace(R.id.main_fragment, targetFragment, targetFragment.getClass().getSimpleName())
                .setTransitionStyle(FragmentTransaction.TRANSIT_FRAGMENT_FADE)
                .commit();
    }

    // What good method is to access resideMenu？
    public ResideMenu getResideMenu() {
        return resideMenu;
    }


    public void showDialogForLogout() {
        dialog = new Dialog(HomeActivity.this);
        dialog.getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        dialog.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);
        dialog.setContentView(R.layout.dialog_two_button_layout);
        //   dialog.getWindow().setBackgroundDrawableResource(android.R.color.white);
        TextView title = (TextView) dialog.findViewById(R.id.dialog_title);
        title.setText("Swiss Monkey");
        TextView messageText = (TextView) dialog.findViewById(R.id.messageText);
        messageText.setText("Are you sure want to sign out?");
        dialog.findViewById(R.id.btNo).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                resideMenu.closeMenu();
                dialog.dismiss();
            }
        });
        dialog.findViewById(R.id.btYes).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                checkReadPermission();
            }
        });


        dialog.show();
    }

    @TargetApi(Build.VERSION_CODES.M)
    public void checkReadPermission() {
        if (ActivityCompat.checkSelfPermission(HomeActivity.this, android.Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{android.Manifest.permission.READ_EXTERNAL_STORAGE}, MY_PERMISSIONS_READ_EXTERNAL_STORAGE);
        } else {
            deleteFiles();
        }
    }

    @TargetApi(Build.VERSION_CODES.M)
    public void checkInitialReadPermission() {
        if (ActivityCompat.checkSelfPermission(HomeActivity.this, android.Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{android.Manifest.permission.READ_EXTERNAL_STORAGE}, MY_INITIAL_PERMISSIONS_READ_EXTERNAL_STORAGE);
        }
    }


    private void deleteFiles() {
        File dir = new File(Constants.baseUrl);
        if (dir.isDirectory()) {
            String[] children = dir.list();
            for (int i = 0; i < children.length; i++) {
                new File(dir, children[i]).delete();
            }
        }
        logoutUser();
        dialog.dismiss();

    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        Log.d(LOG_TAG, "onRequestPermissionsResult: ");

        if (requestCode == MY_PERMISSIONS_READ_EXTERNAL_STORAGE) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                deleteFiles();
            } else {
                logoutUser();
                dialog.dismiss();
                Toast.makeText(HomeActivity.this, "Please enable storage permissions", Toast.LENGTH_SHORT).show();
            }
        }

    }

    public void logoutUser() {
        String authHeader = PreferencesData.getString(HomeActivity.this, Constants.AUTHORIZATION_KEY, "");
        JsonObject logoutUserJsonObject = new JsonObject();
        logoutUserJsonObject.addProperty(Constants.AUTH_TOKEN_KEY, authHeader);
        logoutUserJsonObject.addProperty(Constants.DEVICE_TOKEN, PreferencesData.getString(context, Constants.REGISTRATION_TOKEN, ""));
        logoutUserJsonObject.addProperty(Constants.DEVICE_TYPE, Constants.ANDROID);
        if (Utility.isConnectingToInternet(context)) {
            Utility.showProgressDialog(context);
            RetroHelper.getBaseClassService(context, "", authHeader).logoutUser(logoutUserJsonObject, new Callback<JsonObject>() {
                @Override
                public void success(JsonObject jsonObject, Response response) {
                    if (jsonObject != null && jsonObject.toString().length() > 0) {
                        Utility.dismissDialog();
                        Log.d("SUCCESS sendcode", jsonObject.toString());
                        PreferencesData.saveString(context, Constants.AUTHORIZATION_KEY, "");
                        PreferencesData.saveString(context, Constants.REGISTRATION_TOKEN, "");
                        PreferencesData.clearPreferences(HomeActivity.this);
                        Intent i = new Intent(context, LoginActivity.class);
                        startActivity(i);
                        finish();
                    }
                }

                @Override
                public void failure(RetrofitError retrofitError) {
                    Utility.dismissDialog();
                    Utility.serviceCallFailureMessage(retrofitError, (Activity) context);

                }
            });
        } else {
            Toast.makeText(context, "Please check internet connection", Toast.LENGTH_LONG).show();
        }
    }

    public int getProgress() {
        int length = 0;
        //1
        if (Profile.getInstance().getName().length() > 0) {
            length += 1;
        }
        //2
        if (Profile.getInstance().getEmail().length() > 0) {
            length += 1;
        }
        //3
        if (Profile.getInstance().getPositionIDs() != null && Profile.getInstance().getPositionIDs().length > 0) {
            length += 1;
        }

        String address1 = Profile.getInstance().getAddressLine1();
        String address2 = Profile.getInstance().getAddressLine2();
        //4
        if ((address1 != null && address1.trim().length() > 0) || (address2 != null && address2.trim().length() > 0)) {
            length += 1;
        }

        //5
        if (Profile.getInstance().getStatename() != null && Profile.getInstance().getStatename().trim().length() > 0) {
            length += 1;
        }
        //6
        if (Profile.getInstance().getCityname() != null && Profile.getInstance().getCityname().trim().length() > 0) {
            length += 1;
        }
        //7
        if (Profile.getInstance().getZipcode() != null && Profile.getInstance().getZipcode().trim().length() > 0) {
            length += 1;
        }


        //8
        if (Profile.getInstance().getAboutMe() != null && Profile.getInstance().getAboutMe().length() > 0) {
            length += 1;
        }
        //9
        if (Profile.getInstance().getResume() != null && Profile.getInstance().getResume().length > 0) {
            length += 1;
        }
        //10
        if (Profile.getInstance().getVideo() != null && Profile.getInstance().getVideo().length > 0) {
            length += 1;
        }
        //11
        if (Profile.getInstance().getExperienceID() > -1) {
            length += 1;
        }
        //12
        if (Profile.getInstance().getBoardCertifiedID() > -1) {
            length += 1;
        }

        //13
        if (Profile.getInstance().getLicenseNumber() != null && Profile.getInstance().getLicenseNumber().trim().length() > 0) {
            length += 1;
        }
        //14
        if (Profile.getInstance().getWorkAvailablityID() > -1) {
            length += 1;
        }

        //15
        if (Profile.getInstance().getShifts() != null && Profile.getInstance().getShifts().length > 0) {
            length += 1;
        }
        //16
        if (Profile.getInstance().getLocationRangeID() > -1) {
            length += 1;
        }
        //17
        if (Profile.getInstance().getPracticeManagementID() != null && Profile.getInstance().getPracticeManagementID().length > 0) {
            length += 1;
        }
        //18
        if (Profile.getInstance().getCompensationID() > -1) {
            length += 1;
        }

        //19
        if (Profile.getInstance().getSalaryMin() != null && Profile.getInstance().getSalaryMin().length() > 0) {
            length += 1;
        }
        //20
        if (Profile.getInstance().getRecommendationLetters() != null && Profile.getInstance().getRecommendationLetters().length > 0) {
            length += 1;
        }
        Log.e(LOG_TAG, "getProgress length : " + length);
        return length;

    }


    // Our handler for received Intents. This will be called whenever an Intent
    // with an action named "custom-event-name" is broadcasted.
    private BroadcastReceiver mMessageReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            // TODO Auto-generated method stub
            // Get extra data included in the Intent
            String message = intent.getStringExtra("message");
            // Log.d("receiver", "Got message: " + message);

            message = message.substring(1, message.length() - 1);
            Log.d(LOG_TAG, "message :" + message);
            message = message.replace("\\", "");

            JsonParser parser = new JsonParser();
            JsonObject jsonObject = (JsonObject) parser.parse(message);

            Type type = new TypeToken<Notification>() {
            }.getType();
            Notification notification = new Gson().fromJson(jsonObject, type);

            boolean isExist = false;
            for (Notification notification1 : mJobs) {
                if (notification.getId() == notification1.getId()) {
                    isExist = true;
                    break;
                }
            }

            if (!isExist) {
//                mJobs.add(notification);
                mJobs.add(0, notification); // TODO: 1/9/16 add at the beginning

                number = ++number;

                Fragment frag = getSupportFragmentManager().findFragmentById(R.id.main_fragment);

                if (frag.getTag() != null && frag.getTag().equals("WelcomeFragment")) {
                    if (number > 0) {
                        showNotification();
                        notificationNumber_iv.setVisibility(View.VISIBLE);
                        notificationNumber_iv.setText(String.valueOf(number));

                    } else {
                        notificationNumber_iv.setVisibility(View.GONE);
                    }

                }
            }

        }
    };


    @Override
    protected void onResume() {
        super.onResume();
        LocalBroadcastManager.getInstance(this).registerReceiver(mMessageReceiver, new IntentFilter("notification"));

        Log.d(LOG_TAG, "onResume: ");
        Utility.checkTermsAndConditionsStatus(this);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        LocalBroadcastManager.getInstance(this).unregisterReceiver(
                mMessageReceiver);
    }


}
