package com.rapidbizapps.swissmonkey.jobs;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.rapidbizapps.swissmonkey.HomeActivity;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.models.Job;
import com.rapidbizapps.swissmonkey.models.Notification;
import com.rapidbizapps.swissmonkey.models.Profile;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.DialogUtility;
import com.rapidbizapps.swissmonkey.utility.Utility;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Locale;
import java.util.TimeZone;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by mlanka on 27-06-2016.
 */
public class AlertsAdapter extends BaseAdapter {
    ArrayList<Notification> mJobs;
    Context mContext;

    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US);
    private static final String LOG_TAG = "AlertsAdapter";

    public AlertsAdapter(ArrayList jobs, Context context) {
        mJobs = jobs;
        mContext = context;
    }

    @Override
    public int getCount() {
        return mJobs.size();
    }

    @Override
    public Object getItem(int position) {
        return mJobs.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder;

        if (convertView != null) {
            viewHolder = (ViewHolder) convertView.getTag();
        } else {
            convertView = LayoutInflater.from(mContext).inflate(R.layout.alert_list_item, parent, false);
            viewHolder = new ViewHolder(convertView);
            convertView.setTag(viewHolder);
        }

        viewHolder.alertMessage_tv.setText(mJobs.get(position).getNotification_description());
        viewHolder.viewJob_tv.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(Utility.isConnectingToInternet(mContext)) {
                    Intent intent = new Intent(mContext, JobDetailActivity.class);
                    intent.putExtra(Constants.JOB_ID_INTENT_EXTRA, mJobs.get(position).getJob_id());
                    mContext.startActivity(intent);
                }else
                {
                    DialogUtility.showDialogWithOneButton((Activity) mContext, Constants.APP_NAME, mContext.getResources().getString(R.string.check_internet));
                }

            }
        });

      /*  if (mJobs.get(position).getCompanyId() == 0) {
            viewHolder.viewJob_tv.setVisibility(View.GONE);
        } else {
            viewHolder.viewJob_tv.setVisibility(View.VISIBLE);
        }*/

        format.setTimeZone(TimeZone.getTimeZone("UTC"));
        try {
            long postedTime = format.parse(mJobs.get(position).getUpdated_at()).getTime();
            String timeAgo = Utility.dateFormat(postedTime) + " ago";
            viewHolder.postedAgo_tv.setText(timeAgo);
        } catch (ParseException e) {
            viewHolder.postedAgo_tv.setText(mJobs.get(position).getNumOfDaysOld());

        }

        return convertView;
    }


    class ViewHolder {
        @BindView(R.id.message_alert_list)
        TextView alertMessage_tv;

        @BindView(R.id.view_job_alert_list)
        TextView viewJob_tv;

        @BindView(R.id.posted_ago_alert_list)
        TextView postedAgo_tv;

        ViewHolder(View view) {
            ButterKnife.bind(this, view);
        }
    }
}
