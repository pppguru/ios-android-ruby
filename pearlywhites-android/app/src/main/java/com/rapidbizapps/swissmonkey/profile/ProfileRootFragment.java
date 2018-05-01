package com.rapidbizapps.swissmonkey.profile;


import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ProgressBar;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import com.rapidbizapps.swissmonkey.HomeActivity;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.Services.ProfileHelper;
import com.rapidbizapps.swissmonkey.Services.RetroHelper;
import com.rapidbizapps.swissmonkey.fragments.ProfileDetailFragment;
import com.rapidbizapps.swissmonkey.models.Profile;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.DialogUtility;
import com.rapidbizapps.swissmonkey.utility.PreferencesData;
import com.rapidbizapps.swissmonkey.utility.Utility;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;


/**
 * A simple {@link Fragment} subclass.
 */
public class ProfileRootFragment extends Fragment {

    private static final String TAG = ProfileRootFragment.class.getSimpleName();

    @BindView(R.id.circle_1_activity_profile)
    ImageView iv_one;

    @BindView(R.id.circle_2_activity_profile)
    ImageView iv_two;

    @BindView(R.id.circle_3_activity_profile)
    ImageView iv_three;

    @BindView(R.id.circle_4_activity_profile)
    ImageView iv_four;

    @BindView(R.id.indicator_1_activity_profile)
    View indicator_one;

    @BindView(R.id.indicator_2_activity_profile)
    View indicator_two;

    @BindView(R.id.indicator_3_activity_profile)
    View indicator_three;

    @BindView(R.id.indicator_4_activity_profile)
    View indicator_four;

    @BindView(R.id.viewpager_activity_profile)
    ViewPager profileViewPager;


    @BindView(R.id.progressbar_activity_profile)
    ProgressBar profileProgress;

    private static final String LOG_TAG = "ProfileRootFragment";

    List<Fragment> profileFragments;

    ImageView saveProfile_iv;

    JsonObject profileJsonObject = new JsonObject();

    HomeActivity mActivity;

    public ProfileRootFragment() {
        // Required empty public constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_profile_root, container, false);
        ButterKnife.bind(this, view);

        profileFragments = new ArrayList<>();
        profileFragments.add(ProfileFragment1.newInstance());
        profileFragments.add(ProfileFragment2.newInstance());
        profileFragments.add(ProfileFragment3.newInstance());
        profileFragments.add(ProfileFragment4.newInstance());

        mActivity.setHeaderText(Constants.PROFILE);
        mActivity.hideNotification();
        mActivity.showSaveButton();
        saveProfile_iv = ((HomeActivity) mActivity).getHeaderRightImage();
        saveProfile_iv.setImageResource(R.drawable.save);


        //--
        String[] practicArray = Profile.getInstance().getPracticeManagementID();
        if (practicArray != null && practicArray.length > 0) {
            JsonArray tempArray = new JsonArray();
            for (String string : practicArray) {
                tempArray.add(new JsonPrimitive(string));
            }

            ProfileHelper.getInstance().setSelectedPracticeSoftware(tempArray);
        }
        //--
        int[] positionArray = Profile.getInstance().getPositionIDs();
        if (positionArray != null && positionArray.length > 0) {
            JsonArray tempArray = new JsonArray();
            for (int position : positionArray) {
                tempArray.add(new JsonPrimitive(position));
            }

            ProfileHelper.getInstance().setSelectedPositions(tempArray);
        }
        ///
        String[] skillsArray = Profile.getInstance().getSkills();
        if (skillsArray != null && skillsArray.length > 0) {
            JsonArray tempArray = new JsonArray();
            for (String string : skillsArray) {
                tempArray.add(new JsonPrimitive(string));
            }

            ProfileHelper.getInstance().setSelectedSkillsArray(tempArray);
        }

        String[] statesArray = Profile.getInstance().getLicenseVerifiedStates();
        if (statesArray != null && statesArray.length > 0) {
            JsonArray tempArray = new JsonArray();
            for (String string : statesArray) {
                tempArray.add(new JsonPrimitive(string));
            }

            ProfileHelper.getInstance().setSelectedStatesArray(tempArray);
        }


        if (Profile.getInstance().getExperienceID() > -1)
            ProfileHelper.getInstance().setExperienceId(Profile.getInstance().getExperienceID());


        if (Profile.getInstance().getBoardCertifiedID() > -1)
            ProfileHelper.getInstance().setBoardCertifiedId(Profile.getInstance().getBoardCertifiedID());

        if (Profile.getInstance().getWorkAvailablityID() > -1)
            ProfileHelper.getInstance().setWorkAvailabilityId(Profile.getInstance().getWorkAvailablityID());

        if (Profile.getInstance().getCompensationID() > -1)
            ProfileHelper.getInstance().setCompensationId(Profile.getInstance().getCompensationID());


        saveProfile_iv.setOnClickListener(
            new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    ProfileHelper.getInstance().setShifts(mActivity.mShifts);
                    saveProfileToServer();
                }
            }

        );

        Log.d(TAG, "onCreateView: profile progress " + mActivity.mProgress);
        profileProgress.setProgress(mActivity.mProgress);

        profileViewPager.setAdapter(new FragmentPagerAdapter(getChildFragmentManager()) {
            @Override
            public Fragment getItem(int position) {
                switch (position) {
                    case 0:
                        return ProfileFragment1.newInstance();
                    case 1:
                        return ProfileFragment2.newInstance();
                    case 2:
                        return ProfileFragment3.newInstance();
                    case 3:
                        return ProfileFragment4.newInstance();
                    default:
                        return ProfileFragment1.newInstance();
                }

            }

            @Override
            public int getCount() {
                return 4;
            }
        });

        profileViewPager.setCurrentItem(0);
        profileViewPager.setOffscreenPageLimit(3); //set this?

        profileViewPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset,
                                       int positionOffsetPixels) {
                indicator_one.setVisibility(View.INVISIBLE);
                indicator_two.setVisibility(View.INVISIBLE);
                indicator_three.setVisibility(View.INVISIBLE);
                indicator_four.setVisibility(View.INVISIBLE);

                switch (position) {
                    case 0:
                        iv_one.setImageDrawable(getResources().getDrawable(R.drawable.cs1));
                        iv_two.setImageDrawable(getResources().getDrawable(R.drawable.cu2));
                        iv_three.setImageDrawable(getResources().getDrawable(R.drawable.cu3));
                        iv_four.setImageDrawable(getResources().getDrawable(R.drawable.cu4));
                        indicator_one.setVisibility(View.VISIBLE);

                        break;

                    case 1:
                        iv_one.setImageDrawable(getResources().getDrawable(R.drawable.cu1));
                        iv_two.setImageDrawable(getResources().getDrawable(R.drawable.cs2));
                        iv_three.setImageDrawable(getResources().getDrawable(R.drawable.cu3));
                        iv_four.setImageDrawable(getResources().getDrawable(R.drawable.cu4));
                        indicator_two.setVisibility(View.VISIBLE);

                        break;

                    case 2:
                        iv_one.setImageDrawable(getResources().getDrawable(R.drawable.cu1));
                        iv_two.setImageDrawable(getResources().getDrawable(R.drawable.cu2));
                        iv_three.setImageDrawable(getResources().getDrawable(R.drawable.cs3));
                        iv_four.setImageDrawable(getResources().getDrawable(R.drawable.cu4));
                        indicator_three.setVisibility(View.VISIBLE);

                        break;

                    case 3:
                        iv_one.setImageDrawable(getResources().getDrawable(R.drawable.cu1));
                        iv_two.setImageDrawable(getResources().getDrawable(R.drawable.cu2));
                        iv_three.setImageDrawable(getResources().getDrawable(R.drawable.cu3));
                        iv_four.setImageDrawable(getResources().getDrawable(R.drawable.cs4));
                        indicator_four.setVisibility(View.VISIBLE);

                        break;
                }
            }

            @Override
            public void onPageSelected(int position) {

            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });


        return view;
    }

    public static ProfileRootFragment newInstance() {
        Bundle args = new Bundle();
        ProfileRootFragment fragment = new ProfileRootFragment();
        fragment.setArguments(args);
        return fragment;
    }


    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        mActivity = (HomeActivity) context;
    }

    private void saveProfileToServer() {
        if (areFieldsValid()) {
            profileJsonObject.addProperty(Constants.AUTH_TOKEN_KEY, mActivity.mAuthToken);
            profileJsonObject.addProperty(Constants.NAME_KEY, mActivity.name);
            profileJsonObject.addProperty(Constants.ADDRESS_LINE1_KEY, mActivity.addressLine1);
            profileJsonObject.addProperty(Constants.ADDRESS_LINE2_KEY, mActivity.addressLine2);
            profileJsonObject.addProperty(Constants.CITY_KEY, mActivity.city);
            profileJsonObject.addProperty(Constants.STATE_KEY, mActivity.state);
            profileJsonObject.addProperty(Constants.ZIPCODE_KEY, mActivity.zip);

//            Performing removal of '$' symbol in areFieldsValid() method.
//            if (mActivity.salaryMin != null && mActivity.salaryMin.length() > 0) {
//                mActivity.salaryMin = mActivity.salaryMin.substring(1);
//            }
//
//            if (mActivity.salaryMax != null && mActivity.salaryMax.length() > 0) {
//                mActivity.salaryMax = mActivity.salaryMax.substring(1);
//            }

            try {
                String sMin = mActivity.salaryMin;
                String sMax = mActivity.salaryMax;
                if (mActivity.salaryMin != null && mActivity.salaryMin.length() > 0) {
                    sMin = mActivity.salaryMin.substring(1);
                }

                if (mActivity.salaryMax != null && mActivity.salaryMax.length() > 0) {
                    sMax = mActivity.salaryMax.substring(1);
                }
                if (Integer.valueOf(sMin) > Integer.valueOf(sMax)) {
                    DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, "Maximum expected salary should be greater than Minimum expected salary");
                    return;
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }


            if (mActivity.salaryMin != null && mActivity.salaryMin.length() > 0) {
                mActivity.salaryMin = mActivity.salaryMin.substring(1);
            }

            if (mActivity.salaryMax != null && mActivity.salaryMax.length() > 0) {
                mActivity.salaryMax = mActivity.salaryMax.substring(1);
            }


            // We don't want incorrect range to get saved in server.
            //if(mActivity.salaryMin.trim().length()>0) {
            profileJsonObject.addProperty(Constants.SALARY_MIN_KEY, mActivity.salaryMin);
            // }


            //if(mActivity.salaryMin.trim().length()>0) {
            profileJsonObject.addProperty(Constants.SALARY_MAX_KEY, mActivity.salaryMax);
            // }


            profileJsonObject.addProperty(Constants.OTHER_REQS_KEY, mActivity.otherReqs);

            // if is new email, add newEmail key and also send the old email as usual
            if (mActivity.isNewEmail) {
                profileJsonObject.addProperty(Constants.NEW_EMAIL_KEY, mActivity.newEmail);
                profileJsonObject.addProperty(Constants.EMAIL_KEY, Profile.getInstance().getEmail());
            } else {
                profileJsonObject.addProperty(Constants.EMAIL_KEY, mActivity.email);
            }

            profileJsonObject.addProperty(Constants.PHONE_NUMBER_KEY, mActivity.phoneNumber);
            profileJsonObject.addProperty(Constants.ABOUT_ME_KEY, mActivity.aboutMe);
            profileJsonObject.addProperty(Constants.LICENSE_NUMBER_KEY, mActivity.licenseNumber);

            if (ProfileHelper.getInstance().getSelectedPositions() != null) {
                profileJsonObject.add(Constants.POSITION_ID_KEY, ProfileHelper.getInstance().getSelectedPositions());
            }

            if (ProfileHelper.getInstance().getExperienceId() != 0)
                profileJsonObject.addProperty(Constants.EXPERIENCE_ID_KEY, ProfileHelper.getInstance().getExperienceId());

            if (ProfileHelper.getInstance().getBoardCertifiedId() != -1) {
                profileJsonObject.addProperty(Constants.BOARD_CERTIFIED_ID_KEY, ProfileHelper.getInstance().getBoardCertifiedId());
            }

            if (ProfileHelper.getInstance().getSelectedJobTypes() != null) {
                profileJsonObject.add(Constants.JOB_TYPE_KEY, ProfileHelper.getInstance().getSelectedJobTypes());
            }

            if (ProfileHelper.getInstance().getWorkAvailabilityId() != 0) {
                profileJsonObject.addProperty(Constants.WORK_AVAILABILITY_ID_KEY, ProfileHelper.getInstance().getWorkAvailabilityId());

                if (ProfileHelper.getInstance().getWorkAvailabilityId() == 2) {
                    profileJsonObject.addProperty(Constants.WORK_AVAILABILITY_DATE_KEY, mActivity.workAvailabilitydate);
                }
            }

            if (ProfileHelper.getInstance().getShifts() != null && ProfileHelper.getInstance().getShifts().size() != 0) {
                profileJsonObject.add(Constants.SHIFTS_KEY, ProfileHelper.getInstance().getShifts());
            }
            profileJsonObject.addProperty(Constants.LOCATION_RANGE_ID_KEY, ProfileHelper.getInstance().getMilesId());

            if (ProfileHelper.getInstance().getSelectedPracticeSoftware() != null) {
                for (int i = 0; i < ProfileHelper.getInstance().getSelectedPracticeSoftware().size(); i++) {
                    Log.d(LOG_TAG, "saveProfileToServer: " + ProfileHelper.getInstance().getSelectedPracticeSoftware().get(i));
                }
            }
            profileJsonObject.add(Constants.PRACTICE_MANAGEMENT_ID_KEY, ProfileHelper.getInstance().getSelectedPracticeSoftware());
            profileJsonObject.addProperty(Constants.NEW_PRACTICE_SOFTWARE, mActivity.otherSoftwareExperience);

            if (ProfileHelper.getInstance().getSelectedSkillsArray() != null) {
                for (int i = 0; i < ProfileHelper.getInstance().getSelectedSkillsArray().size(); i++) {
                    Log.d(LOG_TAG, "saveProfileToServer: " + ProfileHelper.getInstance().getSelectedSkillsArray().get(i));
                }
            }
            profileJsonObject.add(Constants.SKILLS_KEY, ProfileHelper.getInstance().getSelectedSkillsArray());

            if (ProfileHelper.getInstance().getCompensationId() != 0)
                profileJsonObject.addProperty(Constants.COMPENSATION_ID_KEY, ProfileHelper.getInstance().getCompensationId());

            profileJsonObject.addProperty(Constants.LICENSE_VERIFIED_KEY, ProfileHelper.getInstance().getLicenseVerified());
            profileJsonObject.addProperty(Constants.BILINGUAL_LANGUAGES_KEY, mActivity.languages);


            //add the states only when the box is checked
            if (ProfileHelper.getInstance().getLicenseVerified() != null) {
                if (ProfileHelper.getInstance().getLicenseVerified().equals("1")) {
                    profileJsonObject.add(Constants.LICENSE_VERIFIED_STATES_KEY, ProfileHelper.getInstance().getSelectedStatesArray());
                }
            }

            if (mActivity.licenseNumber.trim().length() > 0)
                if (!mActivity.licenseDate.equals("-") && !mActivity.licenseMonth.equals("-") && !mActivity.licenseYear.equals("-")) {
                    profileJsonObject.addProperty(Constants.LICENSE_EXPIRY_KEY, mActivity.licenseYear + "-" +
                            mActivity.licenseMonth + "-" + mActivity.licenseDate);
                }

            if (Utility.isConnectingToInternet(mActivity)) {
                Utility.showProgressDialog(mActivity);
                RetroHelper.getBaseClassService(mActivity, "", "").saveProfile(profileJsonObject, new Callback<JsonObject>() {
                    @Override
                    public void success(JsonObject jsonObject, Response response) {
                        Log.v(TAG, "Response code: " + response.getStatus());
                        Log.d(LOG_TAG, "success: " + profileJsonObject.entrySet().size());
                        PreferencesData.saveInt(mActivity, Constants.PROFILE_PROGRESS_COUNT, profileJsonObject.entrySet().size());
                        PreferencesData.saveBoolean(mActivity, Constants.PROMPT_COMPLETE_PROFILE, false);
                        if (jsonObject != null && jsonObject.toString().length() > 0) {
                            Utility.dismissDialog();
                            String successMsg;
                            if (jsonObject.has(Constants.SUCCESS_RESPONSE_KEY)) {
                                successMsg = jsonObject.get(Constants.SUCCESS_RESPONSE_KEY).getAsString();
                            } else {
                                successMsg = jsonObject.get("succes").getAsString();
                            }

                            if (successMsg.equalsIgnoreCase("Email Updated")) {
                                DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, "Please verify your updated email address. Note: You will be logged out of the application", new View.OnClickListener() {
                                    @Override
                                    public void onClick(View v) {
                                        mActivity.logoutUser();
                                    }
                                });
                            } else if (successMsg.contains("already")) {
                                DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, mActivity.getString(R.string.email_already_registered));
                            } else {
                                if (profileViewPager.getCurrentItem() == (profileFragments.size() - 1)) {
                                    mActivity.changeFragment(new ProfileDetailFragment());
                                } else {
                                    profileViewPager.setCurrentItem(profileViewPager.getCurrentItem() + 1);
                                }
                            }
                        }
                    }

                    @Override
                    public void failure(RetrofitError retrofitError) {
                        Utility.dismissDialog();
                        Utility.serviceCallFailureMessage(retrofitError, mActivity);
                    }
                });
            } else {
                DialogUtility.showDialogWithOneButton(mActivity, Constants.NO_NETWORK_HEADER, Constants.NO_NETWORK);
            }
        }

    }

    private boolean areFieldsValid() {
        switch (profileViewPager.getCurrentItem()) {
            case 0:
                if (mActivity.name.length() == 0 || mActivity.city.length() == 0 || mActivity.state.length() == 0 || mActivity.zip.length() == 0) {
                    DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, Constants.REQUIRED_FIELDS);
                    return false;
                }

                Log.d(LOG_TAG, "areFieldsValid: isProfilePicSet" + ProfileHelper.getInstance().isProfilePicSet());
                if (!ProfileHelper.getInstance().isProfilePicSet()) {
                    DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, "Please set a profile picture");
                    return false;
                }

                if (mActivity.newEmail != null && !Utility.isValidEmail(mActivity.newEmail.trim())) {
                    Log.d(LOG_TAG, "areFieldsValid: invalid new email");
                    DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, Constants.INVALID_EMAIL);
                    return false;
                }

                if (mActivity.phoneNumber != null && mActivity.phoneNumber.length() > 0 && !Utility.isValidMobile(mActivity.phoneNumber.trim())) {
                    DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, Constants.INVALID_PHONE);
                    return false;
                }
                break;
            case 1:
                if (ProfileHelper.getInstance().getExperienceId() <= 0) {
                    DialogUtility.showDialogWithOneButton(mActivity, "Please enter experience", Constants.INVALID_EXPERIENCE);
                    return false;
                }

                if (mActivity.licenseNumber.length() > 0) {
                    if (mActivity.licenseDate.equals("-")) {
                        DialogUtility.showDialogWithOneButton(mActivity, "Please enter available date for license expiry date", Constants.INVALID_PHONE);
                        return false;
                    }
                }

                if (ProfileHelper.getInstance().getLicenseVerified() != null) {
                    if (ProfileHelper.getInstance().getLicenseVerified().equals("1")) {
                        if (ProfileHelper.getInstance().getSelectedStatesArray() != null && ProfileHelper.getInstance().getSelectedStatesArray().size() == 0) {
                            DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, "Please select at least a single state where your license is valid");
                            return false;
                        }
                    }
                }
                break;
            case 2:
                if (ProfileHelper.getInstance().getWorkAvailabilityId() != 0) {
                    if (ProfileHelper.getInstance().getWorkAvailabilityId() == 2) {
                        if (mActivity.workAvailabilitydate == null || mActivity.workAvailabilitydate.isEmpty()) {
                            DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, "Please enter available date for work availability");
                            return false;
                        }

                    }
                }
                break;
            case 3:
                if (!ProfileHelper.getInstance().isAgreeToTerms()) {
                    DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, "Please agree to the terms of service");
                    return false;
                }
                break;
        }
        return true;
    }

    @OnClick(R.id.circle_1_activity_profile)
    void onCircle1Click() {
        profileViewPager.setCurrentItem(0);
    }

    @OnClick(R.id.circle_2_activity_profile)
    void onCircle2Click() {
        profileViewPager.setCurrentItem(1);
    }

    @OnClick(R.id.circle_3_activity_profile)
    void onCircle3Click() {
        profileViewPager.setCurrentItem(2);
    }

    @OnClick(R.id.circle_4_activity_profile)
    void onCircle4Click() {
        profileViewPager.setCurrentItem(3);
    }


}
