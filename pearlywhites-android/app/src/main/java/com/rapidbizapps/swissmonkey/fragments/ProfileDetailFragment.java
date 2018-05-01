package com.rapidbizapps.swissmonkey.fragments;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.graphics.ColorUtils;
import android.text.Html;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.JsonObject;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.rapidbizapps.swissmonkey.HomeActivity;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.Services.DataHelper;
import com.rapidbizapps.swissmonkey.Services.ProfileHelper;
import com.rapidbizapps.swissmonkey.Services.RetroHelper;
import com.rapidbizapps.swissmonkey.models.Position;
import com.rapidbizapps.swissmonkey.models.Profile;
import com.rapidbizapps.swissmonkey.profile.ProfileRootFragment;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.PreferencesData;
import com.rapidbizapps.swissmonkey.utility.Utility;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;


public class ProfileDetailFragment extends Fragment {

    private static final String LOG_TAG = "ProfileDetailFragment";

    @BindView(R.id.map_view_strip)
    TextView work;

    @BindView(R.id.list_view_strip)
    TextView aboutMe;

    Context mContext;

    ImageView editProfile_iv;

    AboutMeFragment mAboutMeFragment;
    WorkFragment mWorkFragment;

    Activity actv;

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        actv = activity;
    }

    public ProfileDetailFragment() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View rootView = inflater.inflate(R.layout.fragment_profile_detail, container, false);
        ButterKnife.bind(this, rootView);
        ((HomeActivity) actv).hideNotification();
        editProfile_iv = ((HomeActivity) actv).getHeaderRightImage();
        editProfile_iv.setVisibility(View.VISIBLE);

        editProfile_iv.setImageResource(R.drawable.ic_image_edit);
        editProfile_iv.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ((HomeActivity) actv).changeFragment(ProfileRootFragment.newInstance());
            }
        });

        mContext = actv;

        aboutMe.setText("ABOUT ME");
        work.setText("WORK");
        getProfileData();


        return rootView;
    }

    private void setUpData() {
        mAboutMeFragment = AboutMeFragment.newInstance(Profile.getInstance());
        mWorkFragment = WorkFragment.newInstance(Profile.getInstance());

        onJobInfoClick(null);
    }

    public void getProfileData() {

        String authHeader = PreferencesData.getString(actv, Constants.AUTHORIZATION_KEY, "");

        JsonObject profileJsonObject = new JsonObject();
        profileJsonObject.addProperty(Constants.AUTH_TOKEN_KEY, authHeader);

        if (Utility.isConnectingToInternet(actv)) {
            Utility.showProgressDialog(actv);
            RetroHelper.getBaseClassService(actv, "", "").getProfileData(profileJsonObject, new Callback<Profile>() {
                @Override
                public void success(Profile profile, Response response) {
                    Utility.dismissDialog();
                    Log.d("Response", profile.toString());

                    Profile.setInstance(profile);
                    ProfileHelper.setInstance();
                    ((HomeActivity) actv).mProgress = ((HomeActivity) actv).getProgress();
                    Log.d(LOG_TAG, "success: progress" + ((HomeActivity) actv).mProgress);
                    setUpData();
                }

                @Override
                public void failure(RetrofitError error) {
                    Utility.dismissDialog();
                    Utility.serviceCallFailureMessage(error, actv);
                }
            });
        } else {
            Toast.makeText(actv, "", Toast.LENGTH_SHORT).show();
        }

    }

    @OnClick(R.id.list_view_strip)
    void onJobInfoClick(View view) {
        aboutMe.setBackgroundColor(actv.getResources().getColor(R.color.purple2));
        aboutMe.setTextColor(actv.getResources().getColor(R.color.white));

        work.setBackgroundColor(ColorUtils.setAlphaComponent(actv.getResources().getColor(R.color.pageTitleColor), 85));
        work.setTextColor(actv.getResources().getColor(R.color.pageTitleColor));

        ((HomeActivity) actv).getSupportFragmentManager().beginTransaction().replace(R.id.about_or_work_info, mAboutMeFragment).commit();
    }


    @OnClick(R.id.map_view_strip)
    void onPracticeInfoCLick(View view) {
        aboutMe.setBackgroundColor(ColorUtils.setAlphaComponent(actv.getResources().getColor(R.color.purple2), 85));
        aboutMe.setTextColor(actv.getResources().getColor(R.color.purple2));

        work.setBackgroundColor(actv.getResources().getColor(R.color.pageTitleColor));
        work.setTextColor(actv.getResources().getColor(R.color.white));

        ((HomeActivity) actv).getSupportFragmentManager().beginTransaction().replace(R.id.about_or_work_info, mWorkFragment).commit();
    }

}
