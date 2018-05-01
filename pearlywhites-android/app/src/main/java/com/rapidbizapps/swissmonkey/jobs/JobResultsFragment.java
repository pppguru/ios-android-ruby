package com.rapidbizapps.swissmonkey.jobs;


import android.app.Activity;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.models.Job;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Locale;

import butterknife.BindView;
import butterknife.ButterKnife;


/**
 * A simple {@link Fragment} subclass.
 * Use the {@link JobResultsFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class JobResultsFragment extends Fragment {


    ArrayList<Job> mJobs;
    boolean mShowApplicationStatus;

    @BindView(R.id.job_list)
    ListView jobs_lv;

    public JobResultsFragment() {
        // Required empty public constructor
    }

    Activity actv;
    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        actv=activity;
    }

    public static JobResultsFragment newInstance(ArrayList<Job> jobs, boolean showApplicationStatus) {
        JobResultsFragment fragment = new JobResultsFragment();
        Bundle args = new Bundle();
        args.putParcelableArrayList("jobs", jobs);
        args.putBoolean("show_application_status",showApplicationStatus);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mJobs = getArguments().getParcelableArrayList("jobs");
            mShowApplicationStatus = getArguments().getBoolean("show_application_status");
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_job_results, container, false);
        ButterKnife.bind(this, view);
        setupJobs();
        return view;

    }

    private void setupJobs() {
        Collections.sort(mJobs,new ComparatorJob());
        JobsAdapter jobsAdapter = new JobsAdapter(actv, mJobs, mShowApplicationStatus);
        jobs_lv.setAdapter(jobsAdapter);

    }


    public class ComparatorJob implements Comparator {

        public int compare(Object arg0, Object arg1) {
            Job job0 = (Job) arg0;
            Job job1 = (Job) arg1;
            Date job0Date = null,job1Date = null;
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US);
            try {
                job0Date=format.parse(job0.getUpdatedAt());
                job1Date=format.parse(job1.getUpdatedAt());
            } catch (ParseException e) {
                e.printStackTrace();
            }

            int flag = job1Date.compareTo(job0Date);
           return flag;
        }

    }


}
