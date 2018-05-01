package com.rapidbizapps.swissmonkey.fragments;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.AlertDialog;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.ArrayAdapter;
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
import com.rapidbizapps.swissmonkey.Services.ProfileHelper;
import com.rapidbizapps.swissmonkey.Services.RetroHelper;
import com.rapidbizapps.swissmonkey.jobs.AdvancedJobSearchActivity;
import com.rapidbizapps.swissmonkey.jobs.JobError;
import com.rapidbizapps.swissmonkey.jobs.JobResultsActivity;
import com.rapidbizapps.swissmonkey.models.CompensationRange;
import com.rapidbizapps.swissmonkey.models.ExperienceRange;
import com.rapidbizapps.swissmonkey.models.Job;
import com.rapidbizapps.swissmonkey.models.JobType;
import com.rapidbizapps.swissmonkey.models.LocationRange;
import com.rapidbizapps.swissmonkey.models.Position;
import com.rapidbizapps.swissmonkey.models.PracticeManagementSoftware;
import com.rapidbizapps.swissmonkey.models.Profile;
import com.rapidbizapps.swissmonkey.models.Shift;
import com.rapidbizapps.swissmonkey.models.SoftwareProficiency;
import com.rapidbizapps.swissmonkey.models.State;
import com.rapidbizapps.swissmonkey.models.WorkAvailability;
import com.rapidbizapps.swissmonkey.profile.ProfileRootFragment;
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
import butterknife.ButterKnife;
import butterknife.OnClick;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;


public class WelcomeFragment extends Fragment {
    Context context;
    private static final String LOG_TAG = WelcomeFragment.class.getSimpleName();

    HomeActivity homeActivity;
    int milesRange = 20;

    @BindView(R.id.iv_findNow)
    ImageView findJobsNow_iv;

    @BindView(R.id.reveal_jobs_ll)
    LinearLayout revealJobs_ll;

    @BindView(R.id.reveal_jobs_icon)
    ImageView revealIcon_iv;

    @BindView(R.id.tv_advanceSearch)
    TextView advancedSearch_tv;

    private Hashtable<Integer, Position> mPositionsHashtable = new Hashtable<>();
    private ArrayList<Integer> mSelectedPositions = new ArrayList<>();
    private boolean[] mSelectedPositionsArray = new boolean[0];

    String mAuthToken;

    @BindView(R.id.job_menu)
    LinearLayout jobMenu_ll;

    @BindView(R.id.decrement_miles)
    ImageView decrementMiles_iv;

    @BindView(R.id.increment_miles)
    ImageView incrementMiles_iv;

    @BindView(R.id.find_in_range)
    TextView findInRange_tv;

    @BindView(R.id.et_position)
    MaterialEditText selectPosition_et;

    @BindView(R.id.et_zip_or_city)
    MaterialEditText cityOrZip_et;

    @BindView(R.id.search_content)
    RelativeLayout search_rl;
    private HomeActivity mActivity;


    public WelcomeFragment() {
        // Required empty public constructor
    }

    AlertDialog mAlertDialog;

    JsonObject commonRequest;
    Activity actv;

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        actv = activity;
    }

    public static WelcomeFragment newInstance() {
        WelcomeFragment fragment = new WelcomeFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mAuthToken = PreferencesData.getString(actv, Constants.AUTHORIZATION_KEY, "");
        commonRequest = new JsonObject();
        commonRequest.addProperty(Constants.AUTH_TOKEN_KEY, mAuthToken);

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View rootView = inflater.inflate(R.layout.fragment_welcome, container, false);
        ButterKnife.bind(this, rootView);

        homeActivity = (HomeActivity) actv;
        // homeActivity.getAlertsFromServer();
        homeActivity.hideSaveButton();
        selectPosition_et.setKeyListener(null);
        homeActivity.showNotificationNumber();
        jobMenu_ll.setVisibility(View.GONE);

        findInRange_tv.setText(getString(R.string.miles_range, milesRange));
        getPositionsFromServer();
        getProfileFromServer();
        return rootView;
    }

    private void getProfileFromServer() {
        Log.d(LOG_TAG, "getProfileFromServer: ");

        JsonObject profileJsonObject = new JsonObject();
        profileJsonObject.addProperty(Constants.AUTH_TOKEN_KEY, mAuthToken);

        if (Utility.isConnectingToInternet(actv)) {
            Log.d(LOG_TAG, "getProfileFromServer: request to be made");
            Utility.showProgressDialog(actv);
            RetroHelper.getBaseClassService(homeActivity, "", "").getProfileData(profileJsonObject, new Callback<Profile>() {

                @Override
                public void success(Profile profile, Response response) {
                    Utility.dismissDialog();
                    Profile.setInstance(profile);
                    ProfileHelper.setInstance();
                    homeActivity.mProgress = homeActivity.getProgress();
                }

                @Override
                public void failure(RetrofitError error) {
                    Utility.dismissDialog();
                    Utility.serviceCallFailureMessage(error, actv);
                    homeActivity.mProgress = 0;

                }
            });
        } else {
            Toast.makeText(actv, "Please check your internet connection", Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        mActivity = (HomeActivity) context;
    }

    @Override
    public void onDetach() {
        super.onDetach();
    }


    @OnClick(R.id.iv_findNow)
    public void onFindJobsClick(View view) {
        if (Utility.isConnectingToInternet(actv)) {

            if (Profile.getInstance().getZipcode() == null) {
                completeProfileAlert();

            } else {
                if (mSelectedPositions.size() == 0) {
                    DialogUtility.showDialogWithOneButton(actv, Constants.APP_NAME, "Please select positions");
                } else if (!cityOrZip_et.getText().toString().isEmpty() && TextUtils.isDigitsOnly(cityOrZip_et.getText().toString())) {

                    if (!(cityOrZip_et.getText().toString().length() >= 5 && cityOrZip_et.getText().toString().length() <= 9)) {
                        DialogUtility.showDialogWithOneButton(actv, Constants.APP_NAME, "Please enter a valid zip code");
                    } else {
                        findJobs();
                    }
                } else {
                    findJobs();
                }
            }

        } else {
            DialogUtility.showDialogWithOneButton(actv, Constants.APP_NAME, getString(R.string.check_internet));
        }

    }

    private void completeProfileAlert() {
        final android.app.Dialog dialog = new android.app.Dialog(actv);
        dialog.getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        dialog.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);
        dialog.setContentView(R.layout.dialog_two_button_layout);

        ((TextView) (dialog.findViewById(R.id.dialog_title))).setText(Constants.APP_NAME);
        ((TextView) (dialog.findViewById(R.id.messageText))).setText(getString(R.string.complete_profile_alert));

        TextView positiveButton = (TextView) dialog.findViewById(R.id.btYes);
        positiveButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ((HomeActivity) actv).changeFragment(ProfileRootFragment.newInstance());
                dialog.dismiss();
            }
        });
        positiveButton.setText(R.string.ok_button);

        TextView negativeButton = (TextView) dialog.findViewById(R.id.btNo);
        negativeButton.setText(R.string.cancel_button);

        negativeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });

        dialog.show();
    }

    void setupSpinnerData() {
        final List<Position> positions = DataHelper.getInstance().getPositions();
        mSelectedPositionsArray = new boolean[positions.size()];
        Arrays.fill(mSelectedPositionsArray, false);

        mPositionsHashtable = new Hashtable<>();
        for (Position position : positions) {
            mPositionsHashtable.put(position.getPositionId(), position);
        }

        AlertDialog.Builder builder = new AlertDialog.Builder(mActivity);
        CharSequence[] dialogList = new CharSequence[positions.size()];
        // set the dialog title
        for (int i = 0; i < positions.size(); i++) {
            dialogList[i] = positions.get(i).getPositionName().toUpperCase();
        }

        // specify the list array, the items to be selected by default (null for none),
        // and the listener through which to receive call backs when items are selected
        // R.array.choices were set in the resources res/values/strings.xml
        mAlertDialog = builder.setMultiChoiceItems(dialogList, mSelectedPositionsArray, new DialogInterface.OnMultiChoiceClickListener() {
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
    }

    void getPositionsFromServer() {
        if (Utility.isConnectingToInternet(actv)) {
            Utility.showProgressDialog(actv);
            RetroHelper.getBaseClassService(homeActivity, "", "").getDropDownListData(new Callback<JsonObject>() {
                JsonArray positionsArray, locationRangeArray, experienceArray, jobypeArray, compensationrangeArray, shiftsArray,
                        softwareProficiencyArray, practiceManagementArray, statesArray, workAvailabilityArray;

                @Override
                public void success(JsonObject jsonObject, Response response) {
                    Log.d(LOG_TAG, "success: ");
                    Utility.dismissDialog();
                    if (jsonObject != null) {
                        if (jsonObject.has(Constants.POSITIONS_KEY)) {
                            positionsArray = jsonObject.getAsJsonArray(Constants.POSITIONS_KEY);
                            Type type = new TypeToken<List<Position>>() {
                            }.getType();
                            List<Position> positions = new Gson().fromJson(positionsArray.toString(), type);
                            DataHelper.getInstance().setPositions(positions);
                        }


                        if (jsonObject.has(Constants.LOCATION_RANGE_KEY)) {
                            locationRangeArray = jsonObject.getAsJsonArray(Constants.LOCATION_RANGE_KEY);
                            Type type = new TypeToken<List<LocationRange>>() {
                            }.getType();

                            List<LocationRange> locationRanges = new Gson().fromJson(locationRangeArray.toString(), type);
                            DataHelper.getInstance().setLocationRanges(locationRanges);
                        }

                        if (jsonObject.has(Constants.EXPERIENCE_KEY)) {
                            experienceArray = jsonObject.getAsJsonArray(Constants.EXPERIENCE_KEY);
                            Type type = new TypeToken<List<ExperienceRange>>() {
                            }.getType();

                            List<ExperienceRange> experiences = new Gson().fromJson(experienceArray.toString(), type);
                            DataHelper.getInstance().setExperiences(experiences);
                        }

                        if (jsonObject.has(Constants.JOBS_TYPE_KEY)) {
                            jobypeArray = jsonObject.getAsJsonArray(Constants.JOBS_TYPE_KEY);
                            Type type = new TypeToken<List<JobType>>() {
                            }.getType();

                            List<JobType> jobTypes = new Gson().fromJson(jobypeArray.toString(), type);
                            DataHelper.getInstance().setJobTypes(jobTypes);
                        }

                        if (jsonObject.has(Constants.COMPENSATION_RANGE_KEY)) {
                            compensationrangeArray = jsonObject.getAsJsonArray(Constants.COMPENSATION_RANGE_KEY);
                            Type type = new TypeToken<List<CompensationRange>>() {
                            }.getType();

                            List<CompensationRange> compensationRanges = new Gson().fromJson(compensationrangeArray.toString(), type);
                            DataHelper.getInstance().setCompensationRanges(compensationRanges);
                        }

                        if (jsonObject.has(Constants.SOFTWARE_PROFICIENCY_KEY)) {
                            softwareProficiencyArray = jsonObject.getAsJsonArray(Constants.SOFTWARE_PROFICIENCY_KEY);
                            Type type = new TypeToken<List<SoftwareProficiency>>() {
                            }.getType();

                            List<SoftwareProficiency> softwareProficiencies = new Gson().fromJson(softwareProficiencyArray.toString(), type);

                            // Storing a list of all the items that contain sub-items.
                            for (int i = 0; i < softwareProficiencies.size(); i++) {
                                for (int j = 0; j < softwareProficiencies.size(); j++) {
                                    if (softwareProficiencies.get(j).getParentId() != null)
                                        if (softwareProficiencies.get(i).getSoftwareTypeId() == softwareProficiencies.get(j).getParentId()) {
                                            softwareProficiencies.get(i).getSubCategories().add(softwareProficiencies.get(j));
                                        }
                                }
                            }

                            DataHelper.getInstance().setSoftwareProficiencies(softwareProficiencies);
                        }


                        if (jsonObject.has(Constants.PRACTICE_MANAGEMENT_SOFTWARE_KEY)) {
                            practiceManagementArray = jsonObject.getAsJsonArray(Constants.PRACTICE_MANAGEMENT_SOFTWARE_KEY);
                            Type type = new TypeToken<List<PracticeManagementSoftware>>() {
                            }.getType();

                            List<PracticeManagementSoftware> practiceManagementSoftwares = new Gson().fromJson(practiceManagementArray.toString(), type);
                            DataHelper.getInstance().setPracticeManagementSoftwares(practiceManagementSoftwares);
                        }

                        if (jsonObject.has(Constants.SHIFTS_KEY)) {
                            shiftsArray = jsonObject.getAsJsonArray(Constants.SHIFTS_KEY);
                            Type type = new TypeToken<List<Shift>>() {
                            }.getType();

                            List<Shift> shifts = new Gson().fromJson(shiftsArray.toString(), type);
                            DataHelper.getInstance().setShifts(shifts);
                        }


                        if (jsonObject.has(Constants.STATE_LIST_KEY)) {
                            statesArray = jsonObject.getAsJsonArray(Constants.STATE_LIST_KEY);
                            Type type = new TypeToken<List<State>>() {
                            }.getType();

                            List<State> states = new Gson().fromJson(statesArray.toString(), type);
                            DataHelper.getInstance().setStates(states);
                        }

                        if (jsonObject.has(Constants.WORK_AVAILBILITY_KEY)) {
                            workAvailabilityArray = jsonObject.getAsJsonArray(Constants.WORK_AVAILBILITY_KEY);
                            Type type = new TypeToken<List<WorkAvailability>>() {
                            }.getType();

                            List<WorkAvailability> workAvailabilities = new Gson().fromJson(workAvailabilityArray.toString(), type);
                            DataHelper.getInstance().setWorkAvailabilities(workAvailabilities);
                        }

                    }

                    setupSpinnerData();
                }

                @Override
                public void failure(RetrofitError error) {
                    Utility.dismissDialog();
                    //  Checking if the error status (401) is for Blocked User.
                    // If not, showing the faliure message.
                    if (error.getResponse().getStatus() != 401)
                        Utility.serviceCallFailureMessage(error, mActivity);
                }
            });
        } else {
            Toast.makeText(actv, "Please check your network connection", Toast.LENGTH_SHORT).show();
        }
    }

    @OnClick(R.id.increment_miles)
    void onIncrementClick() {
        decrementMiles_iv.setEnabled(true);
        milesRange += 10;
        if (milesRange == 100) {
            incrementMiles_iv.setEnabled(false);
            decrementMiles_iv.setEnabled(true);
            findInRange_tv.setText(getString(R.string.miles_range2, milesRange));
        } else {
            findInRange_tv.setText(getString(R.string.miles_range, milesRange));
        }
    }

    @OnClick(R.id.decrement_miles)
    void onDecrementClick() {
        incrementMiles_iv.setEnabled(true);
        if (milesRange == 20) {
            decrementMiles_iv.setEnabled(false);
            incrementMiles_iv.setEnabled(true);
        } else {
            milesRange -= 10;
        }
        findInRange_tv.setText(getString(R.string.miles_range, milesRange));
    }


    @OnClick(R.id.et_position)
    void onSelectPositionClick() {
        mAlertDialog.show();
    }


    @OnClick(R.id.tv_advanceSearch)
    void onAdvancedSearchClick() {
        Intent intent = new Intent(actv, AdvancedJobSearchActivity.class);
        startActivity(intent);
    }

    private void findJobs() {
        JsonArray positionsArray = new JsonArray();
        for (int item : mSelectedPositions) {
            positionsArray.add(new JsonPrimitive(item + ""));
        }

        JsonObject jsonObject = new JsonObject();
        jsonObject.add(Constants.POSITION_KEY, positionsArray);
        jsonObject.addProperty(Constants.AUTH_TOKEN_KEY, mAuthToken);

        // TODO: 03-06-2016 use the location range from the response
        if (milesRange == 100)
            jsonObject.addProperty(Constants.MILES_KEY, 50000);
        else
            jsonObject.addProperty(Constants.MILES_KEY, milesRange);

        if (!cityOrZip_et.getText().toString().isEmpty()) {
            jsonObject.addProperty(Constants.SEARCH_KEY, cityOrZip_et.getText().toString());
        }

        Utility.showProgressDialog(actv);
        RetroHelper.getBaseClassService(homeActivity, "", "").findJob(jsonObject, new Callback<JsonObject>() {
            @Override
            public void success(JsonObject jsonObject, Response response) {
                Utility.dismissDialog();
                showJobs(jsonObject, "Job Results");
            }

            @Override
            public void failure(RetrofitError error) {
                Utility.dismissDialog();
                if (error != null && error.getResponse() != null) {
                    if (error.getResponse().getStatus() == 501) {
                        Utility.showAppUpdateAlert(mActivity);
                    } else if (error != null
                            && error.getResponse().getStatus() == 502){ // Blocked User.
                        Utility.serviceCallFailureMessage(error, mActivity);
                } else {
                    JobError jobError = (JobError) error.getBodyAs(JobError.class);
                    DialogUtility.showDialogWithOneButton(actv, Constants.APP_NAME, jobError.getError());
                }
            }
        }
    }

    );
}

    private void showJobs(JsonObject jsonObject, String headerText) {
        if (jsonObject != null && jsonObject.has("jobs")) {
            Type type = new TypeToken<List<Job>>() {
            }.getType();
            ArrayList<Job> jobs = new Gson().fromJson(jsonObject.getAsJsonArray("jobs").toString(), type);

            /*if(jobs.size() > 2){
                Log.e("KAR","value 1 ::"+jobs.get(0).getShiftsString());
                Log.e("KAR","value 2 ::"+jobs.get(1).getShiftsString());
            }*/

            if (jobs.isEmpty()) {
                DialogUtility.showDialogWithOneButton(actv, Constants.APP_NAME, "No jobs found");
            } else {
                Intent intent = new Intent(actv, JobResultsActivity.class);
                intent.putParcelableArrayListExtra(Constants.JOBS_INTENT_EXTRA, jobs);
                intent.putExtra(Constants.HEADER_TEXT_INTENT_EXTRA, headerText);
                if (!cityOrZip_et.getText().toString().isEmpty()) {
                    intent.putExtra(Constants.SEARCH_KEY, cityOrZip_et.getText().toString());
                }
                startActivity(intent);
            }
        }
    }


    @OnClick(R.id.reveal_jobs_ll)
    void onRevealJobMenuClick(View view) {
        startAnimation();
    }

    private void startAnimation() {
        if (Profile.getInstance().getZipcode() == null) {
            DialogUtility.completeProfileAlert(mActivity, Constants.APP_NAME, getString(R.string.complete_profile_alert), new DialogUtility.PositiveButtonCallback() {
                @Override
                public void onPositiveButtonClick(Dialog dialog) {
                    mActivity.changeFragment(ProfileRootFragment.newInstance());
                    dialog.dismiss();
                }
            }, new DialogUtility.NegativeButtonCallback() {
                @Override
                public void onNegativeButtonClick(Dialog dialog) {
                    dialog.dismiss();
                }
            }, "OK", "Cancel");
        } else {
            TranslateAnimation translateAnimation = new TranslateAnimation(0, 0, jobMenu_ll.getHeight(), 0);
            translateAnimation.setDuration(1000);
            translateAnimation.setFillEnabled(true);
            jobMenu_ll.startAnimation(translateAnimation);

            jobMenu_ll.setVisibility(View.VISIBLE);
            revealIcon_iv.setVisibility(View.GONE);
            advancedSearch_tv.setVisibility(View.GONE);
            findJobsNow_iv.setVisibility(View.GONE);
        }
    }


    @OnClick(R.id.hide_menu)
    void OnHideJobMenuCLick(View view) {
        reverseAnimation();

    }

    private void reverseAnimation() {
        TranslateAnimation translateAnimation = new TranslateAnimation(0, 0, 0, jobMenu_ll.getHeight());
        translateAnimation.setDuration(1000);
        jobMenu_ll.startAnimation(translateAnimation);

        translateAnimation.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {

            }

            @Override
            public void onAnimationEnd(Animation animation) {
                jobMenu_ll.setVisibility(View.GONE);
                revealIcon_iv.setVisibility(View.VISIBLE);
                advancedSearch_tv.setVisibility(View.VISIBLE);
                findJobsNow_iv.setVisibility(View.VISIBLE);
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
    }


    @OnClick(R.id.jobs_for_you)
    void onJobsForYouClick(final View view) {
        if (Utility.isConnectingToInternet(actv)) {
            reverseAnimation();
            Log.d(LOG_TAG, "onJobsForYouClick: ");
            Utility.showProgressDialog(actv);
            view.setBackground(actv.getResources().getDrawable(R.drawable.view_btn_background));
            ((TextView) view).setTextColor(actv.getResources().getColor(R.color.white));
            RetroHelper.getBaseClassService(homeActivity, "", "").jobsForYou(commonRequest, new Callback<JsonObject>() {
                @Override
                public void success(JsonObject jsonObject, Response response) {
                    Utility.dismissDialog();
                    view.setBackground(actv.getResources().getDrawable(R.drawable.save_btn_background));
                    ((TextView) view).setTextColor(actv.getResources().getColor(R.color.label_textcolor));
                    showJobs(jsonObject, "Jobs For You");
                }

                @Override
                public void failure(RetrofitError error) {
                    Utility.dismissDialog();
                    view.setBackground(actv.getResources().getDrawable(R.drawable.save_btn_background));
                    ((TextView) view).setTextColor(actv.getResources().getColor(R.color.label_textcolor));
                    if (error != null && error.getResponse() != null
                            && error.getResponse().getStatus() == 501) {
                        Utility.showAppUpdateAlert(actv);
                    } else if (error != null && error.getResponse() != null
                            && error.getResponse().getStatus() == 502)  // Blocked User.
                    {
                        Utility.serviceCallFailureMessage(error, mActivity);
                    } else {
                        DialogUtility.showDialogWithOneButton(actv, Constants.APP_NAME, getContext().getString(R.string.something_wrong_alert));
                    }
                }
            });
        } else {
            DialogUtility.showDialogWithOneButton(actv, Constants.APP_NAME, getString(R.string.check_internet));
            // Toast.makeText(actv, getString(R.string.check_internet), Toast.LENGTH_SHORT).show();
        }

    }

    @OnClick(R.id.application_status)
    void onApplicationStatusClick(final View view) {
        if (Utility.isConnectingToInternet(actv)) {
            reverseAnimation();
            Log.d(LOG_TAG, "onApplicationStatusClick: ");
            Utility.showProgressDialog(actv);
            view.setBackground(actv.getResources().getDrawable(R.drawable.view_btn_background));
            ((TextView) view).setTextColor(actv.getResources().getColor(R.color.white));
            RetroHelper.getBaseClassService(homeActivity, "", "").applicationStatus(commonRequest, new Callback<JsonObject>() {
                @Override
                public void success(JsonObject jsonObject, Response response) {
                    Utility.dismissDialog();
                    view.setBackground(actv.getResources().getDrawable(R.drawable.save_btn_background));
                    ((TextView) view).setTextColor(actv.getResources().getColor(R.color.label_textcolor));
                    showJobs(jsonObject, "Application Status");
                }

                @Override
                public void failure(RetrofitError error) {
                    Utility.dismissDialog();
                    view.setBackground(actv.getResources().getDrawable(R.drawable.save_btn_background));
                    ((TextView) view).setTextColor(actv.getResources().getColor(R.color.label_textcolor));
                    if (error != null && error.getResponse() != null
                            && error.getResponse().getStatus() == 501) {
                        Utility.showAppUpdateAlert(actv);
                    } else if (error != null && error.getResponse() != null
                            && error.getResponse().getStatus() == 502)  // Blocked User.
                    {
                        Utility.serviceCallFailureMessage(error, mActivity);
                    } else {
                        DialogUtility.showDialogWithOneButton(actv,
                                Constants.APP_NAME, getContext().getString(R.string.something_wrong_alert));
                    }
                }
            });
        } else

        {
            DialogUtility.showDialogWithOneButton(actv,
                    Constants.APP_NAME, getString(R.string.check_internet));
            //Toast.makeText(actv, getString(R.string.check_internet), Toast.LENGTH_SHORT).show();
        }

    }

    @OnClick(R.id.job_history)
    void onJobHistoryClick(final View view) {
        if (Utility.isConnectingToInternet(actv)) {
            reverseAnimation();
            Log.d(LOG_TAG, "onJobHistoryClick: ");
            Utility.showProgressDialog(actv);
            view.setBackground(actv.getResources().getDrawable(R.drawable.view_btn_background));
            ((TextView) view).setTextColor(actv.getResources().getColor(R.color.white));
            RetroHelper.getBaseClassService(homeActivity, "", "").jobsHistory(commonRequest, new Callback<JsonObject>() {
                @Override
                public void success(JsonObject jsonObject, Response response) {
                    Utility.dismissDialog();
                    view.setBackground(actv.getResources().getDrawable(R.drawable.save_btn_background));
                    ((TextView) view).setTextColor(actv.getResources().getColor(R.color.label_textcolor));
                    showJobs(jsonObject, "Job History");
                }

                @Override
                public void failure(RetrofitError error) {
                    Utility.dismissDialog();
                    view.setBackground(actv.getResources().getDrawable(R.drawable.save_btn_background));
                    ((TextView) view).setTextColor(actv.getResources().getColor(R.color.label_textcolor));

                    if (error != null && error.getResponse() != null
                            && error.getResponse().getStatus() == 501) {
                        Utility.showAppUpdateAlert(actv);
                    } else if (error != null && error.getResponse() != null
                            && error.getResponse().getStatus() == 502) // Blocked User.
                    {
                        Utility.serviceCallFailureMessage(error, mActivity);
                    } else {
                        DialogUtility.showDialogWithOneButton(actv, Constants.APP_NAME, getContext().getString(R.string.something_wrong_alert));
                    }
                }
            });
        } else

        {
            DialogUtility.showDialogWithOneButton(actv, Constants.APP_NAME, getString(R.string.check_internet));
            //Toast.makeText(actv, getString(R.string.check_internet), Toast.LENGTH_SHORT).show();
        }

    }

    @OnClick(R.id.saved_jobs)
    void onSavedJobsClick(final View view) {
        if (Utility.isConnectingToInternet(actv)) {
            reverseAnimation();
            Log.d(LOG_TAG, "onSavedJobsClick: ");
            Utility.showProgressDialog(actv);
            view.setBackground(actv.getResources().getDrawable(R.drawable.view_btn_background));
            ((TextView) view).setTextColor(actv.getResources().getColor(R.color.white));
            RetroHelper.getBaseClassService(homeActivity, "", "").savedJobs(commonRequest, new Callback<JsonObject>() {
                @Override
                public void success(JsonObject jsonObject, Response response) {
                    Utility.dismissDialog();
                    view.setBackground(actv.getResources().getDrawable(R.drawable.save_btn_background));
                    ((TextView) view).setTextColor(actv.getResources().getColor(R.color.label_textcolor));
                    showJobs(jsonObject, "Saved Jobs");
                }

                @Override
                public void failure(RetrofitError error) {
                    Utility.dismissDialog();
                    view.setBackground(actv.getResources().getDrawable(R.drawable.save_btn_background));
                    ((TextView) view).setTextColor(actv.getResources().getColor(R.color.label_textcolor));

                    if (error != null && error.getResponse() != null
                            && error.getResponse().getStatus() == 501) {
                        Utility.showAppUpdateAlert(actv);
                    } else if (error != null && error.getResponse() != null
                            && error.getResponse().getStatus() == 502) // Blocked User.
                    {
                        Utility.serviceCallFailureMessage(error, mActivity);
                    } else {
                        DialogUtility.showDialogWithOneButton(actv, Constants.APP_NAME, getContext().getString(R.string.something_wrong_alert));
                    }
                }
            });
        } else {
            DialogUtility.showDialogWithOneButton(actv, Constants.APP_NAME, getString(R.string.check_internet));
            //Toast.makeText(actv, getString(R.string.check_internet), Toast.LENGTH_SHORT).show();
        }
    }

}

