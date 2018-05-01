package com.rapidbizapps.swissmonkey.jobs;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.widget.ImageView;

import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.models.WeekdayInfo;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.Utility;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindViews;
import butterknife.ButterKnife;
import butterknife.OnClick;
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper;

public class WorkdayPrefsDialogActivity extends Activity {

    private static final String LOG_TAG = "WorkdayPrefsDialogActivity";
    ArrayList<WeekdayInfo> mShifts;

    @BindViews({R.id.monday_morning, R.id.tuesday_morning, R.id.wednesday_morning, R.id.thursday_morning, R.id.friday_morning, R.id.saturday_morning, R.id.sunday_morning})
    List<ImageView> morningViews;

    @BindViews({R.id.monday_afternoon, R.id.tuesday_afternoon, R.id.wednesday_afternoon, R.id.thursday_afternoon, R.id.friday_afternoon, R.id.saturday_afternoon, R.id.sunday_afternoon})
    List<ImageView> afternoonViews;

    @BindViews({R.id.monday_evening, R.id.tuesday_evening, R.id.wednesday_evening, R.id.thursday_evening, R.id.friday_evening, R.id.saturday_evening, R.id.sunday_evening})
    List<ImageView> eveningViews;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_workday_prefs_dialog);
        ButterKnife.bind(this);

        if (getIntent() != null && getIntent().hasExtra(Constants.JOB_INTENT_EXTRA)) {
            mShifts = getIntent().getParcelableArrayListExtra(Constants.JOB_INTENT_EXTRA);
        }
        setupData();
    }

    private void setupData() {
        WeekdayInfo morningObject = null, afternoonObject = null, eveningObject = null;
        if (mShifts != null) {
            int shiftId;
            for (int i = 0; i < mShifts.size(); i++) {
                shiftId = mShifts.get(i).getShiftID();
                if (shiftId == 1) morningObject = mShifts.get(i);
                else if (shiftId == 2) afternoonObject = mShifts.get(i);
                else eveningObject = mShifts.get(i);
            }

            if (morningObject != null) {
                for (int i = 0; i < morningObject.getDays().length; i++) {
                    if (morningObject.getDays()[i].equals(Constants.MONDAY)) {
                        morningViews.get(0).setImageResource(R.drawable.day3);
                    } else if (morningObject.getDays()[i].equals(Constants.TUESDAY)) {
                        morningViews.get(1).setImageResource(R.drawable.day3);
                    } else if (morningObject.getDays()[i].equals(Constants.WEDNESDAY)) {
                        morningViews.get(2).setImageResource(R.drawable.day3);
                    } else if (morningObject.getDays()[i].equals(Constants.THURSDAY)) {
                        morningViews.get(3).setImageResource(R.drawable.day3);
                    } else if (morningObject.getDays()[i].equals(Constants.FRIDAY)) {
                        morningViews.get(4).setImageResource(R.drawable.day3);
                    } else if (morningObject.getDays()[i].equals(Constants.SATURDAY)) {
                        morningViews.get(5).setImageResource(R.drawable.day3);
                    } else if (morningObject.getDays()[i].equals(Constants.SUNDAY)) {
                        morningViews.get(6).setImageResource(R.drawable.day3);
                    }
                }
            }

            if (afternoonObject != null) {
                for (int i = 0; i < afternoonObject.getDays().length; i++) {
                    if (afternoonObject.getDays()[i].equals(Constants.MONDAY)) {
                        afternoonViews.get(0).setImageResource(R.drawable.day1);
                    } else if (afternoonObject.getDays()[i].equals(Constants.TUESDAY)) {
                        afternoonViews.get(1).setImageResource(R.drawable.day1);
                    } else if (afternoonObject.getDays()[i].equals(Constants.WEDNESDAY)) {
                        afternoonViews.get(2).setImageResource(R.drawable.day1);
                    } else if (afternoonObject.getDays()[i].equals(Constants.THURSDAY)) {
                        afternoonViews.get(3).setImageResource(R.drawable.day1);
                    } else if (afternoonObject.getDays()[i].equals(Constants.FRIDAY)) {
                        afternoonViews.get(4).setImageResource(R.drawable.day1);
                    } else if (afternoonObject.getDays()[i].equals(Constants.SATURDAY)) {
                        afternoonViews.get(5).setImageResource(R.drawable.day1);
                    } else if (afternoonObject.getDays()[i].equals(Constants.SUNDAY)) {
                        afternoonViews.get(6).setImageResource(R.drawable.day1);
                    }
                }
            }


            if (eveningObject != null) {
                for (int i = 0; i < eveningObject.getDays().length; i++) {
                    if (eveningObject.getDays()[i].equals(Constants.MONDAY)) {
                        eveningViews.get(0).setImageResource(R.drawable.day4);
                    } else if (eveningObject.getDays()[i].equals(Constants.TUESDAY)) {
                        eveningViews.get(1).setImageResource(R.drawable.day4);
                    } else if (eveningObject.getDays()[i].equals(Constants.WEDNESDAY)) {
                        eveningViews.get(2).setImageResource(R.drawable.day4);
                    } else if (eveningObject.getDays()[i].equals(Constants.THURSDAY)) {
                        eveningViews.get(3).setImageResource(R.drawable.day4);
                    } else if (eveningObject.getDays()[i].equals(Constants.FRIDAY)) {
                        eveningViews.get(4).setImageResource(R.drawable.day4);
                    } else if (eveningObject.getDays()[i].equals(Constants.SATURDAY)) {
                        eveningViews.get(5).setImageResource(R.drawable.day4);
                    } else if (eveningObject.getDays()[i].equals(Constants.SUNDAY)) {
                        eveningViews.get(6).setImageResource(R.drawable.day4);
                    }
                }
            }

        }
    }

    @OnClick(R.id.close_workdays_iv)
    void onCloseClick() {
        Intent intent = getIntent();
        setResult(Activity.RESULT_CANCELED, intent);
        finish();
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

