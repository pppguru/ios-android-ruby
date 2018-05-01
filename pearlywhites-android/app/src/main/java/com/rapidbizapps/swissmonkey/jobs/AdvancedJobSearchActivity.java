package com.rapidbizapps.swissmonkey.jobs;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import com.google.gson.reflect.TypeToken;
import com.rapidbizapps.swissmonkey.HomeActivity;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.Services.DataHelper;
import com.rapidbizapps.swissmonkey.Services.RetroHelper;
import com.rapidbizapps.swissmonkey.models.CompensationRange;
import com.rapidbizapps.swissmonkey.models.ExperienceRange;
import com.rapidbizapps.swissmonkey.models.Job;
import com.rapidbizapps.swissmonkey.models.JobType;
import com.rapidbizapps.swissmonkey.models.LocationRange;
import com.rapidbizapps.swissmonkey.models.Position;
import com.rapidbizapps.swissmonkey.models.Profile;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.DialogUtility;
import com.rapidbizapps.swissmonkey.utility.DropdownAdapter;
import com.rapidbizapps.swissmonkey.utility.PreferencesData;
import com.rapidbizapps.swissmonkey.utility.Utility;
import com.rba.MaterialEditText;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Hashtable;
import java.util.List;

import butterknife.BindView;
import butterknife.BindViews;
import butterknife.ButterKnife;
import butterknife.OnClick;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper;

public class AdvancedJobSearchActivity extends AppCompatActivity {

    private static final String LOG_TAG = "AdvanceJobSearcActivity";

    boolean[] morningClicked, afternoonClicked, eveningClicked;

    public static final int COMPENSATION_PREFERENCES_CLICKED = 1;

    public static final int COMPENSATION_PREFERENCES_NOT_CLICKED = 2;
    private int isCompensationPreferencesClicked = COMPENSATION_PREFERENCES_NOT_CLICKED;

    @BindView(R.id.select_position_advanced)
    MaterialEditText selectPosition_et;

    @BindView(R.id.enter_city_advanced)
    MaterialEditText cityOrZip_et;

    @BindView(R.id.increment_miles_advanced)
    ImageView incrementMiles_iv;

    @BindView(R.id.decrement_miles_advanced)
    ImageView decrementMiles_iv;

    @BindView(R.id.experience_advanced_search)
    MaterialEditText experience_et;

    @BindView(R.id.job_type_advanced)
    MaterialEditText jobType_et;

    @BindView(R.id.from_compensation_advanced)
    EditText fromCompensation_et;

    @BindView(R.id.to_compensation_advanced)
    EditText toCompensation_et;

    @BindView(R.id.compensation_preferences_advanced_search)
    MaterialEditText compensationPreferences_et;

    @BindView(R.id.find_in_range_advanced)
    TextView range_tv;

    @BindView(R.id.weekLL)
    LinearLayout row_LL;

    @BindViews({R.id.monday_morning, R.id.tuesday_morning, R.id.wednesday_morning, R.id.thursday_morning, R.id.friday_morning, R.id.saturday_morning, R.id.sunday_morning})
    List<ImageView> morningViews;

    @BindViews({R.id.monday_afternoon, R.id.tuesday_afternoon, R.id.wednesday_afternoon, R.id.thursday_afternoon, R.id.friday_afternoon, R.id.saturday_afternoon, R.id.sunday_afternoon})
    List<ImageView> afternoonViews;

    @BindViews({R.id.monday_evening, R.id.tuesday_evening, R.id.wednesday_evening, R.id.thursday_evening, R.id.friday_evening, R.id.saturday_evening, R.id.sunday_evening})
    List<ImageView> eveningViews;

    List<LocationRange> mLocationRanges;
    int mRangeIndex = 0, milesRange = 20, mExperienceId, mCompensationId, minRangeIndex = 0;
    String mCityOrZip;

    JsonArray mShiftObjects;
    JsonObject morningShift, afternoonShift, eveningShift;
    JsonArray morningArray, afternoonArray, eveningArray;
    JsonPrimitive mondayPrimitive, tuesdayPrimitive, wednesdayPrimitive, thursdayPrimitive, fridayPrimitive, saturdayPrimitive, sundayPrimitive;
    private Context mContext;

    ArrayList<Job> mJobs;

    AlertDialog mPositionDialog, mExperienceDialog, mJobTypeDialog, mCompensationDialog;

    private Hashtable<Integer, Position> mPositionsHashtable = new Hashtable<>();
    private ArrayList<Integer> mSelectedPositions = new ArrayList<>();
    private boolean[] mSelectedPositionsArray = new boolean[0];

    private Hashtable<Integer, JobType> mJobTypesHashtable = new Hashtable<>();
    private ArrayList<Integer> mSelectedJobTypes = new ArrayList<>();
    private boolean[] mSelectedJobTypesArray = new boolean[0];

    @BindView(R.id.notification)
    RelativeLayout notification_rl;

    @BindView(R.id.title_bar_left_menu)
    ImageView backArrow_iv;

    int fromValue;
    int toValue;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_advanced_job_search);
        ButterKnife.bind(this);
        mContext = this;


        mLocationRanges = DataHelper.getInstance().getLocationRanges();

        for (int i = 0; i < mLocationRanges.size(); i++) {
            if (mLocationRanges.get(i).getToRange() == 20) {
                mRangeIndex = i;
                minRangeIndex = i;
                break;
            }
        }

        if (mLocationRanges != null)
            range_tv.setText(mLocationRanges.get(mRangeIndex).getMilesRange());

        selectPosition_et.setKeyListener(null);
        selectPosition_et.setFocusable(false);
        compensationPreferences_et.setKeyListener(null);
        compensationPreferences_et.setFocusable(false);
        experience_et.setKeyListener(null);
        experience_et.setFocusable(false);
        jobType_et.setKeyListener(null);
        jobType_et.setFocusable(false);

        row_LL.setBackgroundColor(getResources().getColor(R.color.work_day_preferences_bg));
        setupDays();
        setupSpinnerData();

        if (savedInstanceState == null) {
            setHeaderText(Constants.ADVANCED_SEARCH);
            backArrow_iv.setImageResource(R.drawable.ic_image_navigate_before);
            notification_rl.setVisibility(View.GONE);
//            showNotification();
        }
        fromCompensation_et.addTextChangedListener(new TextWatcher() {
            int len = 0;

            @Override
            public void afterTextChanged(Editable s) {
                String str = fromCompensation_et.getText().toString();
                if (str.length() == 1 && len < str.length()) {//len check for backspace
                    fromCompensation_et.setText("$" + str);
                    fromCompensation_et.setSelection(2);
                } else if (str.length() == 1 && len > str.length()) {
                    fromCompensation_et.setText("");
                }
            }

            @Override
            public void beforeTextChanged(CharSequence arg0, int arg1, int arg2, int arg3) {

                String str = fromCompensation_et.getText().toString();
                len = str.length();
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            }


        });

        toCompensation_et.addTextChangedListener(new TextWatcher() {
            int len = 0;

            @Override
            public void afterTextChanged(Editable s) {
                String str = toCompensation_et.getText().toString();
                if (str.length() == 1 && len < str.length()) {//len check for backspace
                    toCompensation_et.setText("$" + str);
                    toCompensation_et.setSelection(2);
                } else if (str.length() == 1 && len > str.length()) {
                    toCompensation_et.setText("");
                }
            }

            @Override
            public void beforeTextChanged(CharSequence arg0, int arg1, int arg2, int arg3) {

                String str = toCompensation_et.getText().toString();
                len = str.length();
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            }


        });


    }

    @Override
    protected void onResume() {
        super.onResume();
        Log.d(LOG_TAG, "onResume: ");
        Utility.checkTermsAndConditionsStatus(this);

    }

    public void setHeaderText(String text) {
        ((TextView) findViewById(R.id.header_text)).setText(text);
    }

    private void setupDays() {
        morningClicked = new boolean[7];
        afternoonClicked = new boolean[7];
        eveningClicked = new boolean[7];

        mShiftObjects = new JsonArray();

        morningArray = new JsonArray();
        afternoonArray = new JsonArray();
        eveningArray = new JsonArray();

        morningShift = new JsonObject();
        afternoonShift = new JsonObject();

        eveningShift = new JsonObject();

        mondayPrimitive = new JsonPrimitive(Constants.MONDAY);
        tuesdayPrimitive = new JsonPrimitive(Constants.TUESDAY);
        wednesdayPrimitive = new JsonPrimitive(Constants.WEDNESDAY);
        thursdayPrimitive = new JsonPrimitive(Constants.THURSDAY);
        fridayPrimitive = new JsonPrimitive(Constants.FRIDAY);
        saturdayPrimitive = new JsonPrimitive(Constants.SATURDAY);
        sundayPrimitive = new JsonPrimitive(Constants.SUNDAY);
    }

    private void setupSpinnerData() {
        // Setup positions
        final List<Position> positions = DataHelper.getInstance().getPositions();
        mSelectedPositionsArray = new boolean[positions.size()];
        Arrays.fill(mSelectedPositionsArray, false);

        mPositionsHashtable = new Hashtable<>();
        for (Position position : positions) {
            mPositionsHashtable.put(position.getPositionId(), position);
        }

        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        CharSequence[] dialogList = new CharSequence[positions.size()];
        // set the dialog title
        for (int i = 0; i < positions.size(); i++) {
            dialogList[i] = positions.get(i).getPositionName().toUpperCase();
        }

        // specify the list array, the items to be selected by default (null for none),
        // and the listener through which to receive call backs when items are selected
        // R.array.choices were set in the resources res/values/strings.xml
        mPositionDialog = builder.setMultiChoiceItems(dialogList, mSelectedPositionsArray, new DialogInterface.OnMultiChoiceClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which, boolean isChecked) {
                mSelectedPositionsArray[which] = isChecked;
                if (isChecked) {
                    mSelectedPositions.add(positions.get(which).getPositionId());
                } else {
                    mSelectedPositions.remove(new Integer(positions.get(which).getPositionId()));
                }
                StringBuilder stringBuilder = new StringBuilder();
                for (int pos : mSelectedPositions) {
                    if (stringBuilder.length() > 0) stringBuilder.append(", ");
                    stringBuilder.append(mPositionsHashtable.get(pos).getPositionName());
                }

                selectPosition_et.setText(stringBuilder.toString());
            }
        }).setPositiveButton("OK", null).create();


        // Setup Job Types
        final List<JobType> jobTypes = DataHelper.getInstance().getJobTypes();
        mSelectedJobTypesArray = new boolean[jobTypes.size()];
        Arrays.fill(mSelectedJobTypesArray, false);

        mJobTypesHashtable = new Hashtable<>();
        for (JobType jobType : jobTypes) {
            mJobTypesHashtable.put(jobType.getJobTypeId(), jobType);
        }

        builder = new AlertDialog.Builder(this);
        dialogList = new CharSequence[jobTypes.size()];
        // set the dialog title
        for (int i = 0; i < jobTypes.size(); i++) {
            dialogList[i] = jobTypes.get(i).getJobType().toUpperCase();
        }

        // specify the list array, the items to be selected by default (null for none),
        // and the listener through which to receive call backs when items are selected
        // R.array.choices were set in the resources res/values/strings.xml
        mJobTypeDialog = builder.setMultiChoiceItems(dialogList, mSelectedJobTypesArray, new DialogInterface.OnMultiChoiceClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which, boolean isChecked) {
                mSelectedJobTypesArray[which] = isChecked;
                if (isChecked) {
                    mSelectedJobTypes.add(jobTypes.get(which).getJobTypeId());
                } else {
                    mSelectedJobTypes.remove(new Integer(jobTypes.get(which).getJobTypeId()));
                }
                StringBuilder stringBuilder = new StringBuilder();
                for (int pos : mSelectedJobTypes) {
                    if (stringBuilder.length() > 0) stringBuilder.append(", ");
                    stringBuilder.append(mJobTypesHashtable.get(pos).getJobType());
                }

                jobType_et.setText(stringBuilder.toString());
            }
        }).setPositiveButton("OK", null).create();


        ArrayAdapter<ExperienceRange> experienceRangeArrayAdapter = new DropdownAdapter<>(this, android.R.layout.simple_list_item_1, DataHelper.getInstance().getExperiences());
        experienceRangeArrayAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        mExperienceDialog = new AlertDialog.Builder(this)
                .setAdapter(experienceRangeArrayAdapter, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        ExperienceRange experience = DataHelper.getInstance().getExperiences().get(which);
                        experience_et.setText(experience.toString());
                        mExperienceId = experience.getExperienceRangeId();
                        dialog.dismiss();
                    }
                })
                .create();

        setupData(mExperienceDialog);

        ArrayAdapter<CompensationRange> compensationRangeArrayAdapter = new DropdownAdapter<>(this, android.R.layout.simple_list_item_1, DataHelper.getInstance().getCompensationRanges());
        compensationRangeArrayAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        mCompensationDialog = new AlertDialog.Builder(this)
                .setAdapter(compensationRangeArrayAdapter, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        CompensationRange compensationRange = DataHelper.getInstance().getCompensationRanges().get(which);
                        compensationPreferences_et.setText(compensationRange.toString());
                        mCompensationId = compensationRange.getCompensationId();
                        dialog.dismiss();
                    }
                })
                .create();

        setupData(mCompensationDialog);
    }


    @OnClick(R.id.select_position_advanced)
    void onSelectPositionClick() {
        mPositionDialog.show();
    }

    @OnClick(R.id.increment_miles_advanced)
    void onIncrementMilesClick() {
        if (mRangeIndex < mLocationRanges.size() - 1) {
            ++mRangeIndex;
        }
        if (mRangeIndex == mLocationRanges.size()) {
            incrementMiles_iv.setEnabled(false);
            decrementMiles_iv.setEnabled(true);
        } else {
            range_tv.setText(mLocationRanges.get(mRangeIndex).getMilesRange());
        }

        Log.d(LOG_TAG, "onIncrementMilesClick: " + mRangeIndex);
    }

    @OnClick(R.id.decrement_miles_advanced)
    void onDecrementMilesClick() {
        if (mRangeIndex == minRangeIndex) {
            decrementMiles_iv.setEnabled(false);
            incrementMiles_iv.setEnabled(true);
        } else {
            if (mRangeIndex > 0)
                --mRangeIndex;
            range_tv.setText(mLocationRanges.get(mRangeIndex).getMilesRange());
        }

        Log.d(LOG_TAG, "onDecrementMilesClick: " + mRangeIndex);

    }

    @OnClick(R.id.experience_advanced_search)
    void onExperienceClick() {
        mExperienceDialog.show();
    }

    @OnClick(R.id.job_type_advanced)
    void onJobTypeClick() {
        mJobTypeDialog.show();
    }

    @OnClick(R.id.compensation_preferences_advanced_search)
    void onCompensationPreferencesClick() {
        isCompensationPreferencesClicked = COMPENSATION_PREFERENCES_CLICKED;
        mCompensationDialog.show();
    }


    @OnClick(R.id.findNow_advanced)
    void onFindNowClick() {
        if (Utility.isConnectingToInternet(mContext)) {
            if (Profile.getInstance().getZipcode() == null) {
                DialogUtility.completeProfileAlert(this, Constants.APP_NAME, getString(R.string.complete_profile_alert), new DialogUtility.PositiveButtonCallback() {
                    @Override
                    public void onPositiveButtonClick(Dialog dialog) {
                        Intent intent = new Intent(mContext, HomeActivity.class);
                        intent.putExtra(Constants.SHOW_PROFILE, true); //direct to profile
                        startActivity(intent);
                        dialog.dismiss();
                    }
                }, new DialogUtility.NegativeButtonCallback() {
                    @Override
                    public void onNegativeButtonClick(Dialog dialog) {
                        dialog.dismiss();
                    }
                }, "OK", "Cancel");
            } else {
                if (mSelectedPositions.size() == 0) {
                    DialogUtility.showDialogWithOneButton(this, Constants.APP_NAME, "Please select positions");
                    return;
                }

               /* if (cityOrZip_et.getText().toString().length() > 0 && !TextUtils.isDigitsOnly(cityOrZip_et.getText().toString())) {
                    DialogUtility.showDialogWithOneButton(this, Constants.APP_NAME, "Please enter a valid zip code");
                    return;
                }*/
                String fromCompensation = fromCompensation_et.getText().toString().trim();
                String toCompensation = toCompensation_et.getText().toString().trim();
                if (fromCompensation.length() == 0 && toCompensation.length() == 0) {

                    if (isCompensationPreferencesClicked == COMPENSATION_PREFERENCES_CLICKED) {
                        DialogUtility.showDialogWithOneButton(this, Constants.APP_NAME, "Please enter both compensation values");
                        return;
                    }

                } else if ((fromCompensation.length() > 0 && toCompensation.length() == 0) || (toCompensation.length() > 0 && fromCompensation.length() == 0)) {
                    DialogUtility.showDialogWithOneButton(this, Constants.APP_NAME, "Please enter both compensation values");
                    return;
                } else if (fromCompensation.length() > 0 && toCompensation.length() > 0) {
                    String removedDollarFromCompensation = fromCompensation.substring(1);
                    String removedDollarToCompensation = toCompensation.substring(1);

                    fromValue = Integer.parseInt(removedDollarFromCompensation);
                    toValue = Integer.parseInt(removedDollarToCompensation);

                    if (fromValue > toValue) {
                        DialogUtility.showDialogWithOneButton(this, Constants.APP_NAME, "To Range should be greater than From Range");
                        return;
                    }

                    // TODO: 2/3/2017 REMOVE comment for SWIS-299
//                    if (isCompensationPreferencesClicked == COMPENSATION_PREFERENCES_NOT_CLICKED) {
//                        DialogUtility.showDialogWithOneButton(this, Constants.APP_NAME, "Please select compensation preferences.");
//                        return;
//                    }
                }

                findJob();

            }

        } else {
            Toast.makeText(this, "Please check internet connection", Toast.LENGTH_LONG).show();
        }

    }


    void findJob() {
        final Intent intent = new Intent(this, JobResultsActivity.class);
        milesRange = mLocationRanges.get(mRangeIndex).getToRange();
        mCityOrZip = cityOrZip_et.getText().toString();

        JsonObject requestBoy = new JsonObject();
        requestBoy.addProperty(Constants.AUTH_TOKEN_KEY, PreferencesData.getString(this, Constants.AUTHORIZATION_KEY, ""));

        if (mShiftObjects.size() != 0)
            requestBoy.add(Constants.SHIFTS_KEY, mShiftObjects);

        JsonArray positionsArray = new JsonArray();
        for (int item : mSelectedPositions) {
            positionsArray.add(new JsonPrimitive(item + ""));
        }
        requestBoy.add(Constants.POSITION_KEY, positionsArray);

        if (!mCityOrZip.isEmpty()) {
            requestBoy.addProperty(Constants.SEARCH_KEY, mCityOrZip);
            intent.putExtra(Constants.SEARCH_KEY, mCityOrZip);
        }

        requestBoy.addProperty(Constants.MILES_KEY, milesRange);

        if (mExperienceId != 0)
            requestBoy.addProperty(Constants.EXPERIENCE_KEY, mExperienceId);

        if (!fromCompensation_et.getText().toString().isEmpty()){
            String fromRange = fromCompensation_et.getText().toString();
            if (fromRange.length() > 1){
                String removedDollarFromCompensation = fromRange.substring(1);
                requestBoy.addProperty(Constants.FROM_COMPENSATION_KEY, removedDollarFromCompensation);
            }
            else {
                requestBoy.addProperty(Constants.FROM_COMPENSATION_KEY, fromCompensation_et.getText().toString());
            }
        }

        if (!toCompensation_et.getText().toString().isEmpty()){
            String toRange = toCompensation_et.getText().toString();
            if (toRange.length() > 1) {
                String removedDollarToCompensation = toRange.substring(1);
                requestBoy.addProperty(Constants.TO_COMPENSATION_KEY, removedDollarToCompensation);
            }else {
                requestBoy.addProperty(Constants.TO_COMPENSATION_KEY, toCompensation_et.getText().toString());
            }
        }

        JsonArray jobTypesArray = new JsonArray();
        for (int item : mSelectedJobTypes) {
            jobTypesArray.add(new JsonPrimitive(JobType.toBackendName(item)));
        }
        requestBoy.add("job_type", jobTypesArray);

        Utility.showProgressDialog(mContext);
        RetroHelper.getBaseClassService(mContext, "", "").findJob(requestBoy, new Callback<JsonObject>() {
                    @Override
                    public void success(JsonObject jsonObject, Response response) {
                        Utility.dismissDialog();
                        if (jsonObject != null && jsonObject.has("jobs")) {
                            Type type = new TypeToken<List<Job>>() {
                            }.getType();
                            mJobs = new Gson().fromJson(jsonObject.getAsJsonArray("jobs").toString(), type);

                            if (mJobs.isEmpty()) {
                                DialogUtility.showDialogWithOneButton((Activity) mContext, Constants.APP_NAME, "No jobs found");
                            } else {
                                intent.putParcelableArrayListExtra(Constants.JOBS_INTENT_EXTRA, mJobs);
                                startActivity(intent);
                            }
                        }
                    }

                    @Override
                    public void failure(RetrofitError error) {
                        Utility.dismissDialog();
                        if (error != null && error.getResponse() != null && error.getResponse().getStatus() == 501) {
                            Utility.showAppUpdateAlert((Activity) mContext);
                        } else if (error != null) {
                            JobError jobError = (JobError) error.getBodyAs(JobError.class);
                            if (jobError != null)
                                DialogUtility.showDialogWithOneButton((Activity) mContext, Constants.APP_NAME, jobError.error);
                        } else {
                            DialogUtility.showDialogWithOneButton((Activity) mContext, Constants.APP_NAME, getString(R.string.no_jobs_found));
                        }
                        //  Log.e(LOG_TAG, error.getMessage());
                    }
                }
        );
    }

    void setupData(AlertDialog alertDialog) {
        ListView listView = alertDialog.getListView();
        listView.setBackground(getResources().getDrawable(R.drawable.list_dialog_background));
        listView.setDivider(getResources().getDrawable(R.drawable.list_divider));
        listView.setDividerHeight(1);
    }

    @OnClick({R.id.monday_morning, R.id.tuesday_morning, R.id.wednesday_morning, R.id.thursday_morning, R.id.friday_morning, R.id.saturday_morning, R.id.sunday_morning})
    void onMorningClick(ImageView imageView) {
        // TODO: 07-06-2016 add to request body
        switch (imageView.getId()) {
            case R.id.monday_morning:
                if (morningClicked[0]) {
                    imageView.setImageResource(R.drawable.day2);
                    morningClicked[0] = false;
                    morningArray.remove(mondayPrimitive);

                } else {
                    imageView.setImageResource(R.drawable.day3);
                    morningClicked[0] = true;
                    morningArray.add(mondayPrimitive);
                }

                break;

            case R.id.tuesday_morning:
                if (morningClicked[1]) {
                    imageView.setImageResource(R.drawable.day2);
                    morningClicked[1] = false;
                    morningArray.remove(tuesdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day3);
                    morningClicked[1] = true;
                    morningArray.add(tuesdayPrimitive);
                }

                break;

            case R.id.wednesday_morning:
                if (morningClicked[2]) {
                    imageView.setImageResource(R.drawable.day2);
                    morningClicked[2] = false;
                    morningArray.remove(wednesdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day3);
                    morningClicked[2] = true;
                    morningArray.add(wednesdayPrimitive);
                }

                break;
            case R.id.thursday_morning:
                if (morningClicked[3]) {
                    imageView.setImageResource(R.drawable.day2);
                    morningClicked[3] = false;
                    morningArray.remove(thursdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day3);
                    morningClicked[3] = true;
                    morningArray.add(thursdayPrimitive);
                }

                break;
            case R.id.friday_morning:
                if (morningClicked[4]) {
                    imageView.setImageResource(R.drawable.day2);
                    morningClicked[4] = false;
                    morningArray.remove(fridayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day3);
                    morningClicked[4] = true;
                    morningArray.add(fridayPrimitive);
                }
                break;
            case R.id.saturday_morning:
                if (morningClicked[5]) {
                    imageView.setImageResource(R.drawable.day2);
                    morningClicked[5] = false;
                    morningArray.remove(saturdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day3);
                    morningClicked[5] = true;
                    morningArray.add(saturdayPrimitive);
                }

                break;
            case R.id.sunday_morning:
                if (morningClicked[6]) {
                    imageView.setImageResource(R.drawable.day2);
                    morningClicked[6] = false;
                    morningArray.remove(sundayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day3);
                    morningClicked[6] = true;
                    morningArray.add(sundayPrimitive);
                }
                break;
        }

        if (morningArray.size() != 0) {
            morningShift.addProperty("shiftID", 1);
            morningShift.add("days", morningArray);
            mShiftObjects.add(morningShift);
        }


    }

    @OnClick({R.id.monday_afternoon, R.id.tuesday_afternoon, R.id.wednesday_afternoon, R.id.thursday_afternoon, R.id.friday_afternoon, R.id.saturday_afternoon, R.id.sunday_afternoon})
    void onAfternoonClick(ImageView imageView) {

        switch (imageView.getId()) {
            case R.id.monday_afternoon:
                if (afternoonClicked[0]) {
                    imageView.setImageResource(R.drawable.day2);
                    afternoonClicked[0] = false;
                    afternoonArray.remove(mondayPrimitive);

                } else {
                    imageView.setImageResource(R.drawable.day1);
                    afternoonClicked[0] = true;
                    afternoonArray.add(mondayPrimitive);
                }
                break;

            case R.id.tuesday_afternoon:
                if (afternoonClicked[1]) {
                    imageView.setImageResource(R.drawable.day2);
                    afternoonClicked[1] = false;
                    afternoonArray.remove(tuesdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day1);
                    afternoonClicked[1] = true;
                    afternoonArray.add(tuesdayPrimitive);
                }
                break;

            case R.id.wednesday_afternoon:
                if (afternoonClicked[2]) {
                    imageView.setImageResource(R.drawable.day2);
                    afternoonClicked[2] = false;
                    afternoonArray.remove(wednesdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day1);
                    afternoonClicked[2] = true;
                    afternoonArray.add(wednesdayPrimitive);
                }
                break;
            case R.id.thursday_afternoon:
                if (afternoonClicked[3]) {
                    imageView.setImageResource(R.drawable.day2);
                    afternoonClicked[3] = false;
                    afternoonArray.remove(thursdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day1);
                    afternoonClicked[3] = true;
                    afternoonArray.add(thursdayPrimitive);
                }
                break;
            case R.id.friday_afternoon:
                if (afternoonClicked[4]) {
                    imageView.setImageResource(R.drawable.day2);
                    afternoonClicked[4] = false;
                    afternoonArray.remove(fridayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day1);
                    afternoonClicked[4] = true;
                    afternoonArray.add(fridayPrimitive);
                }
                break;
            case R.id.saturday_afternoon:
                if (afternoonClicked[5]) {
                    imageView.setImageResource(R.drawable.day2);
                    afternoonClicked[5] = false;
                    afternoonArray.remove(saturdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day1);
                    afternoonClicked[5] = true;
                    afternoonArray.add(saturdayPrimitive);
                }
                break;
            case R.id.sunday_afternoon:
                if (afternoonClicked[6]) {
                    imageView.setImageResource(R.drawable.day2);
                    afternoonClicked[6] = false;
                    afternoonArray.remove(sundayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day1);
                    afternoonClicked[6] = true;
                    afternoonArray.add(sundayPrimitive);
                }
                break;
        }

        if (afternoonArray.size() != 0) {
            afternoonShift.addProperty("shiftID", 2);
            afternoonShift.add("days", afternoonArray);
            mShiftObjects.add(afternoonShift);
        }

    }

    @OnClick({R.id.monday_evening, R.id.tuesday_evening, R.id.wednesday_evening, R.id.thursday_evening, R.id.friday_evening, R.id.saturday_evening, R.id.sunday_evening})
    void onEveningClick(ImageView imageView) {
        switch (imageView.getId()) {
            case R.id.monday_evening:
                if (eveningClicked[0]) {
                    imageView.setImageResource(R.drawable.day2);
                    eveningClicked[0] = false;
                    eveningArray.remove(mondayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day4);
                    eveningClicked[0] = true;
                    eveningArray.add(mondayPrimitive);
                }
                break;

            case R.id.tuesday_evening:
                if (eveningClicked[1]) {
                    imageView.setImageResource(R.drawable.day2);
                    eveningClicked[1] = false;
                    eveningArray.remove(tuesdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day4);
                    eveningClicked[1] = true;
                    eveningArray.add(tuesdayPrimitive);
                }
                break;

            case R.id.wednesday_evening:
                if (eveningClicked[2]) {
                    imageView.setImageResource(R.drawable.day2);
                    eveningClicked[2] = false;
                    eveningArray.remove(wednesdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day4);
                    eveningClicked[2] = true;
                    eveningArray.add(wednesdayPrimitive);
                }
                break;
            case R.id.thursday_evening:
                if (eveningClicked[3]) {
                    imageView.setImageResource(R.drawable.day2);
                    eveningClicked[3] = false;
                    eveningArray.remove(thursdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day4);
                    eveningClicked[3] = true;
                    eveningArray.add(thursdayPrimitive);
                }
                break;
            case R.id.friday_evening:
                if (eveningClicked[4]) {
                    imageView.setImageResource(R.drawable.day2);
                    eveningClicked[4] = false;
                    eveningArray.remove(fridayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day4);
                    eveningClicked[4] = true;
                    eveningArray.add(fridayPrimitive);
                }
                break;
            case R.id.saturday_evening:
                if (eveningClicked[5]) {
                    imageView.setImageResource(R.drawable.day2);
                    eveningClicked[5] = false;
                    eveningArray.remove(saturdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day4);
                    eveningClicked[5] = true;
                    eveningArray.add(saturdayPrimitive);
                }
                break;
            case R.id.sunday_evening:
                if (eveningClicked[6]) {
                    imageView.setImageResource(R.drawable.day2);
                    eveningClicked[6] = false;
                    eveningArray.remove(sundayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day4);
                    eveningClicked[6] = true;
                    eveningArray.add(sundayPrimitive);
                }
                break;
        }

        if (eveningArray.size() != 0) {
            eveningShift.addProperty("shiftID", 3);
            eveningShift.add("days", eveningArray);
            mShiftObjects.add(eveningShift);
        }
    }


    public void showNotification() {
        (findViewById(R.id.notification)).setVisibility(View.VISIBLE);
    }

    public void hideNotification() {
        (findViewById(R.id.notification)).setVisibility(View.GONE);
    }

    public void hideMenu() {
        (findViewById(R.id.title_bar_left_menu)).setVisibility(View.GONE);
    }

    @OnClick(R.id.title_bar_left_menu)
    void onBackClick() {
        onBackPressed();
    }

    @Override
    protected void attachBaseContext(Context newBase) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase));
    }
}
