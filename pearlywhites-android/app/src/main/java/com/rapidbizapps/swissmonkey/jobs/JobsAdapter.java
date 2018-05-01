package com.rapidbizapps.swissmonkey.jobs;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.text.Html;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.JsonObject;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.Services.RetroHelper;
import com.rapidbizapps.swissmonkey.models.Job;
import com.rapidbizapps.swissmonkey.models.WeekdayInfo;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.DialogUtility;
import com.rapidbizapps.swissmonkey.utility.PreferencesData;
import com.rapidbizapps.swissmonkey.utility.Utility;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import butterknife.BindView;
import butterknife.ButterKnife;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;

/**
 * Created by mlanka on 31-05-2016.
 */
public class JobsAdapter extends BaseAdapter {
    private static final String LOG_TAG = JobsAdapter.class.getSimpleName();
    List<Job> mJobs;
    Context mContext;
    int mCurrentPosition;
    boolean mShowApplicationStatus;

    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US);


    public JobsAdapter(Context context, List<Job> jobs, boolean showApplicationStatus) {
        mContext = context;
        mJobs = jobs;
        mShowApplicationStatus = showApplicationStatus;
    }


    @Override
    public int getCount() {
        return mJobs.size();
    }

    @Override
    public Job getItem(int position) {
        return mJobs.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final ViewHolder viewHolder;

        if (convertView != null) {
            viewHolder = (ViewHolder) convertView.getTag();
        } else {
            convertView = LayoutInflater.from(mContext).inflate(R.layout.job_list_item, parent, false);
            viewHolder = new ViewHolder(convertView);
            convertView.setTag(viewHolder);
        }

        mCurrentPosition = position;
        final Job job = mJobs.get(position);

        viewHolder.jobType_tv.setText(job.getJobType());
        viewHolder.position_tv.setText(job.getPosition());


        String formattedString;
        if (job.getFromcompensationAmount() == null && job.getTocompensationAmount() == null) {
            formattedString = "Not Specified - (Not Specified)";
        } else if (job.getFromcompensationAmount() == null && job.getTocompensationAmount() != null) {
            formattedString = "Not Specified - $" + job.getTocompensationAmount();
        } else if (job.getFromcompensationAmount() != null && job.getTocompensationAmount() == null) {
            formattedString = "$" + job.getFromcompensationAmount() + " - (Not Specified)";
        } else {
            formattedString = "$" + job.getFromcompensationAmount() + "-$" + job.getTocompensationAmount();
        }


        viewHolder.compensation_tv.setText(job.getCompensations() + "- " + formattedString);


        // TODO: 31-05-2016 find a way to avoid this warning
        String address1 = job.getAddress1();
        if (address1 != null)
            address1 = address1.replace(",", ", ");
        else
            address1 = "-";

        String address2 = job.getAddress2();

        if (address2 != null && !address2.isEmpty()) address2 = address2 + ",";
        else address2 = "";

        viewHolder.location_tv.setText(address1 + ", " + address2);
        viewHolder.cityState_tv.setText(job.getCity() + ", " + job.getState());
        viewHolder.applicationStatus_tv.setText(mContext.getString(R.string.application_status, job.getStatus()));
        format.setTimeZone(TimeZone.getTimeZone("UTC"));
        try {
            long postedTime = format.parse(job.getUpdatedAt()).getTime();
            String timeAgo = Utility.dateFormat(postedTime) + " ago";
            viewHolder.timeElpase_tv.setText(mContext.getString(R.string.posted, timeAgo));
        } catch (ParseException e) {
            Log.e(LOG_TAG, "setupJobDetailCard: " + e.getMessage());
            viewHolder.timeElpase_tv.setText(mContext.getString(R.string.job_elapsed, job.getNumOfDaysOld()));

        }

        if (mShowApplicationStatus) {
            viewHolder.applicationStatus_tv.setVisibility(View.VISIBLE);
        } else {
            viewHolder.applicationStatus_tv.setVisibility(View.GONE);
        }

        if (job.isSaved()) {
//            viewHolder.saveJob_btn.setVisibility(View.GONE);
            viewHolder.saveJob_btn.setImageResource(R.drawable.love_icon);
        } else {
//            viewHolder.saveJob_btn.setVisibility(View.VISIBLE);
            viewHolder.saveJob_btn.setImageResource(R.drawable.love_empty_icon);
        }

        viewHolder.saveJob_btn.setTag(position);
        viewHolder.viewJob_btn.setTag(position);
        viewHolder.jobType_tv.setTag(position);

        viewHolder.saveJob_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View v) {
                final int tempPosition = Integer.parseInt(v.getTag().toString());
                final Job tempJob = mJobs.get(tempPosition);

                if (Utility.isConnectingToInternet(mContext)) {
                    Utility.showProgressDialog(mContext);
                    JsonObject jsonObject = new JsonObject();
                    jsonObject.addProperty(Constants.AUTH_TOKEN_KEY, PreferencesData.getString(mContext, Constants.AUTHORIZATION_KEY, ""));
                    jsonObject.addProperty(Constants.JOB_ID_KEY, tempJob.getJobId());
                    RetroHelper.getBaseClassService(mContext, "", "").saveJob(jsonObject, new Callback<JsonObject>() {
                        @Override
                        public void success(JsonObject jsonObject, Response response) {
                            Utility.dismissDialog();
                            mJobs.get(tempPosition).setSaved(true);
                            Toast.makeText(mContext, "Job saved successfully", Toast.LENGTH_SHORT).show();
                            v.setVisibility(View.GONE);
                            Log.d(LOG_TAG, "success: " + tempJob.getJobId());
                            Log.d(LOG_TAG, "success: " + tempJob.getPosition());
                        }

                        @Override
                        public void failure(RetrofitError error) {
                            Utility.dismissDialog();
                            if (error != null && error.getResponse() != null && error.getResponse().getStatus() == 501) {
                                Utility.showAppUpdateAlert((Activity) mContext);
                            } else {
                                Toast.makeText(mContext, "Unable to save job. Please try later", Toast.LENGTH_SHORT).show();
                            }
                            // Log.e(LOG_TAG, "failure: " + error);
                        }
                    });
                } else {
                    DialogUtility.showDialogWithOneButton((Activity) mContext, Constants.APP_NAME, mContext.getResources().getString(R.string.check_internet));
                }
            }
        });

        viewHolder.viewJob_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Log.d(LOG_TAG, "onJobViewClick: " + position);
                if (Utility.isConnectingToInternet(mContext)) {
                    Intent intent = new Intent(mContext, JobDetailActivity.class);
                    intent.putExtra(Constants.JOB_ID_INTENT_EXTRA, mJobs.get(Integer.parseInt(v.getTag().toString())).getJobId());
                    mContext.startActivity(intent);
                } else {
                    DialogUtility.showDialogWithOneButton((Activity) mContext, Constants.APP_NAME, mContext.getResources().getString(R.string.check_internet));
                }


            }
        });

        viewHolder.jobType_tv.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int tempPosition = Integer.parseInt(v.getTag().toString());
                Job tempJob = mJobs.get(tempPosition);
                Intent intent = new Intent(mContext, WorkdayPrefsDialogActivity.class);
                intent.putParcelableArrayListExtra(Constants.JOB_INTENT_EXTRA, new ArrayList<WeekdayInfo>(Arrays.asList(tempJob.getShifts())));
                mContext.startActivity(intent);
            }
        });

        return convertView;
    }

    class ViewHolder {
        @BindView(R.id.position)
        TextView position_tv;
        @BindView(R.id.time_elapsed)
        TextView timeElpase_tv;
        @BindView(R.id.address1)
        TextView location_tv;
        @BindView(R.id.city_state)
        TextView cityState_tv;

        @BindView(R.id.job_type)
        TextView jobType_tv;
        @BindView(R.id.compensation)
        TextView compensation_tv;

        @BindView(R.id.application_status)
        TextView applicationStatus_tv;

        @BindView(R.id.save_job)
        ImageButton saveJob_btn;

        @BindView(R.id.view_job)
        Button viewJob_btn;

        ViewHolder(View view) {
            ButterKnife.bind(this, view);
        }
    }

}
