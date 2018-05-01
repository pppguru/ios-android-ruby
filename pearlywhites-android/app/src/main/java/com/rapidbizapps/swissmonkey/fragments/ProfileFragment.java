package com.rapidbizapps.swissmonkey.fragments;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.rapidbizapps.swissmonkey.HomeActivity;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.Services.RetroHelper;
import com.rapidbizapps.swissmonkey.models.Profile;
import com.rapidbizapps.swissmonkey.profile.ProfileRootFragment;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.PreferencesData;
import com.rapidbizapps.swissmonkey.utility.Utility;

import butterknife.BindView;
import butterknife.ButterKnife;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;

public class ProfileFragment extends Fragment implements View.OnClickListener {

    String profilePicUrl;
    private static final String TAG = "ProfileFragment";

    String[] videoUrls;

    @BindView(R.id.iv_profile_picture)
    ImageView iv_profileImage;

    @BindView(R.id.tv_name)
    TextView name;

    @BindView(R.id.tv_userName)
    TextView userName;

    @BindView(R.id.tv_completeProfile)
    TextView tv_completeProfile;

    @BindView(R.id.progressBar)
    ProgressBar progressBar;

    String mAuthToken;

    HomeActivity mActivity;

    private static final String LOG_TAG = "ProfileFragment";


    private int mProgress;
    public ProfileFragment() {
        // Required empty public constructor
    }

    public static ProfileFragment newInstance() {
        ProfileFragment fragment = new ProfileFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

       Bundle bundle= getArguments();

        if(bundle!=null)
        {
            mProgress=bundle.getInt("progress");
        }

        mAuthToken = PreferencesData.getString(mActivity, Constants.AUTHORIZATION_KEY, "");
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View rootView = inflater.inflate(R.layout.fragment_profile, container, false);
        ButterKnife.bind(this, rootView);

//        mActivity = ((HomeActivity) mActivity);

        if (mActivity != null) {
            mActivity.hideNotification();
            mActivity.hideSaveButton();
            Log.d(TAG, "onCreateView: mActivity progress" + mActivity.mProgress);
        }

        Log.d(TAG, "onCreateView: progress" + mProgress);
        progressBar.setProgress(mProgress);
        ImageLoader.getInstance().displayImage(Profile.getInstance().getProfile_url(), iv_profileImage, Utility.getProfilePicDisplayOptions(Constants.CIRCULAR_IMAGE_RADIUS));
        userName.setText(Profile.getInstance().getEmail());
        name.setText(Profile.getInstance().getName());
        tv_completeProfile.setOnClickListener(this);
        return rootView;
    }

    private void getProfileFromServer() {
        Log.d(LOG_TAG, "getProfileFromServer: ");

        JsonObject profileJsonObject = new JsonObject();
        profileJsonObject.addProperty(Constants.AUTH_TOKEN_KEY, mAuthToken);

        if (Utility.isConnectingToInternet(mActivity)) {
            Log.d(LOG_TAG, "getProfileFromServer: request to be made");
            Utility.showProgressDialog(mActivity);
            RetroHelper.getBaseClassService(mActivity, "", "").getProfileData(profileJsonObject, new Callback<Profile>() {

                @Override
                public void success(Profile profile, Response response) {
                    Utility.dismissDialog();
                    Profile.setInstance(profile);
                    initializeUiElements();
                }

                @Override
                public void failure(RetrofitError error) {
                    Utility.dismissDialog();
                    Utility.serviceCallFailureMessage(error, mActivity);

                }
            });
        } else {
            Toast.makeText(mActivity, "Please check your internet connection", Toast.LENGTH_SHORT).show();
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


    private void initializeUiElements() {

        Log.d(LOG_TAG, "initializeUiElements: ");
        videoUrls = new String[Profile.getInstance().getVideo().length];

        JsonObject requestBody = new JsonObject();
        requestBody.addProperty(Constants.AUTH_TOKEN_KEY, mAuthToken);
        requestBody.addProperty(Constants.TYPE_KEY, "profile");
        requestBody.addProperty("file", Profile.getInstance().getProfilePic());

        //set profile pic
        RetroHelper.getBaseClassService(mActivity, "", "").downloadFiles(requestBody, new Callback<JsonObject>() {
            @Override
            public void success(JsonObject jsonObject, Response response) {
                if (jsonObject != null) {
                    JsonElement url = jsonObject.get("url");
                    profilePicUrl = url.getAsString();
                }
            }

            @Override
            public void failure(RetrofitError error) {
                Utility.serviceCallFailureMessage(error,mActivity);
            }
        });

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_completeProfile:
                ProfileRootFragment profileRootFragment = ProfileRootFragment.newInstance();
                mActivity.changeFragment(profileRootFragment);
        }
    }





}
