package com.rapidbizapps.swissmonkey.jobs;

import android.Manifest;
import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.graphics.ColorUtils;
import android.support.v7.app.AppCompatActivity;
import android.text.Html;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.Services.RetroHelper;
import com.rapidbizapps.swissmonkey.models.Job;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.DialogUtility;
import com.rapidbizapps.swissmonkey.utility.PreferencesData;
import com.rapidbizapps.swissmonkey.utility.Utility;

import java.lang.reflect.Type;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper;

public class JobDetailActivity extends AppCompatActivity implements JobDetailInfoFragment.OnJobDetailInfoFragmentListener, PracticeInfoFragment.onPracticeInfoFragmentListener {

    private static final String LOG_TAG = "JobDetailActivity";

    DisplayImageOptions mDisplayImageOptions;

    @BindView(R.id.job_or_practice_info)
    FrameLayout jobOrPPracticeInfo_fl;

    @BindView(R.id.job_header_right_item)
    TextView headerImageRight_tv;

    @BindView(R.id.map_view_strip)
    TextView practiceInfoTab_tv;

    @BindView(R.id.list_view_strip)
    TextView jobTab_tv;

    int mJobId = -1;
    Job mJob;
    Context mContext;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_job_detail);
        ButterKnife.bind(this);
        mContext = this;

        if (getIntent() != null) {
            mJobId = getIntent().getIntExtra(Constants.JOB_ID_INTENT_EXTRA, -1);
            Log.d(LOG_TAG, "onCreate: " + mJobId);
        }

        practiceInfoTab_tv.setText("PRACTICE INFO");
        jobTab_tv.setText("JOB");

        headerImageRight_tv.setVisibility(View.GONE); //hide advanced search button

        getJobDetails();
        getSupportFragmentManager().beginTransaction().add(R.id.job_or_practice_info, JobDetailInfoFragment.newInstance(mJob)).commit();

    }

    private void setupData() {

    }

    private void getJobDetails() {
        Utility.showProgressDialog(mContext);
        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty(Constants.AUTH_TOKEN_KEY, PreferencesData.getString(this, Constants.AUTHORIZATION_KEY, ""));
        RetroHelper.getBaseClassService(mContext, "", "").getJob(mJobId, jsonObject, new Callback<JsonArray>() {
            @Override
            public void success(JsonArray jsonArray, Response response) {
                Utility.dismissDialog();
                Type collectionType = new TypeToken<List<Job>>() {
                }.getType();
                List<Job> jobs = new Gson().fromJson(jsonArray, collectionType);
                mJob = jobs.get(0);
                Log.d(LOG_TAG, "success: " + mJob.getJobId());
                setupData();
                getSupportFragmentManager().beginTransaction().replace(R.id.job_or_practice_info, JobDetailInfoFragment.newInstance(mJob)).commit();
            }

            @Override
            public void failure(RetrofitError error) {
                Utility.dismissDialog();
                Utility.serviceCallFailureMessage(error, (Activity) mContext);
            }
        });
    }

    @OnClick(R.id.list_view_strip)
    void onJobInfoClick(View view) {
        jobTab_tv.setBackgroundColor(getResources().getColor(R.color.purple));
        jobTab_tv.setTextColor(getResources().getColor(R.color.white));

        practiceInfoTab_tv.setBackgroundColor(ColorUtils.setAlphaComponent(getResources().getColor(R.color.pageTitleColor), 85));
        practiceInfoTab_tv.setTextColor(getResources().getColor(R.color.pageTitleColor));

        getSupportFragmentManager().beginTransaction().replace(R.id.job_or_practice_info, JobDetailInfoFragment.newInstance(mJob)).commit();
    }


    @OnClick(R.id.map_view_strip)
    void onPracticeInfoCLick(View view) {
        jobTab_tv.setBackgroundColor(ColorUtils.setAlphaComponent(getResources().getColor(R.color.purple2), 85));
        jobTab_tv.setTextColor(getResources().getColor(R.color.purple2));

        practiceInfoTab_tv.setBackgroundColor(getResources().getColor(R.color.pageTitleColor));
        practiceInfoTab_tv.setTextColor(getResources().getColor(R.color.white));

        getSupportFragmentManager().beginTransaction().replace(R.id.job_or_practice_info, PracticeInfoFragment.newInstance(mJob)).commit();
    }

    @Override
    public void onFragmentInteraction(Uri uri) {

    }

    @OnClick(R.id.job_header_right_item)
    void onAdvancedSearchClick() {
        Intent intent = new Intent(this, AdvancedJobSearchActivity.class);
        startActivity(intent);
    }

    @OnClick(R.id.job_header_left_item)
    void onBackArrowClick() {
        onBackPressed();
    }

    @Override
    protected void attachBaseContext(Context newBase) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase));
    }

    @Override
    protected void onResume() {
        super.onResume();

        Utility.checkTermsAndConditionsStatus(this);
    }
}
