package com.rapidbizapps.swissmonkey.jobs;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.location.LocationManager;
import android.os.AsyncTask;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.FragmentManager;
import android.support.v4.content.ContextCompat;
import android.support.v4.graphics.ColorUtils;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.Html;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;
import android.location.LocationListener;

import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.maps.model.Polyline;
import com.google.android.gms.maps.model.PolylineOptions;
import com.google.gson.JsonObject;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.Services.RetroHelper;
import com.rapidbizapps.swissmonkey.models.Job;
import com.rapidbizapps.swissmonkey.models.WeekdayInfo;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.DialogUtility;
import com.rapidbizapps.swissmonkey.utility.PreferencesData;
import com.rapidbizapps.swissmonkey.utility.Utility;

import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper;

public class JobResultsActivity extends AppCompatActivity implements OnMapReadyCallback, LocationListener {

    private static final String LOG_TAG = "JobResultsActivity";
    Context mContext;

    ArrayList<Job> mJobs;
    ArrayList<LatLng> mCoordinates;

    @BindView(R.id.list_view_strip)
    TextView viewList_tv;

    @BindView(R.id.map_view_strip)
    TextView viewMap_tv;

    @BindView(R.id.job_header_left_item)
    TextView headerText_tv;

/*    @BindView(R.id.job_detail_window)
    LinearLayout jobDetailWindow_ll;*/

    @BindView(R.id.results_container)
    FrameLayout fragmentContainer_fl;

    @BindView(R.id.activity_job_results_clicked_layout)
    LinearLayout displayLayout_ll;

    @BindView(R.id.activity_job_results_scroll)
    ScrollView scrollview;
    @BindView(R.id.hide_job_card)
    ImageView cancel_iv;

    private Marker previousMarker = null;

    int index;

    String mHeaderText;
    JobResultsFragment mJobResultsFragment;
    boolean mShowApplicationStatus;
    SupportMapFragment mapsFragment;
    FragmentManager mFragmentManager;


    protected LocationManager locationManager;
    protected LocationListener locationListener;

    private static final int PERMISSION_REQUEST_CODE_LOCATION = 1;

    private double mClickedLatitude;
    private double mClickedLongitude;

    private GoogleMap mGoogleMap;
    Polyline mPolyLine = null;
    private Marker currentMarker = null;

    private String locationSearchKey = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_jobs_results);
        ButterKnife.bind(this);

        mContext = this;
        mFragmentManager = getSupportFragmentManager();

        if (getIntent() != null) {
            Intent intent = getIntent();

            mJobs = intent.getParcelableArrayListExtra(Constants.JOBS_INTENT_EXTRA);
            mCoordinates = new ArrayList<>(mJobs.size());

            locationSearchKey = intent.getStringExtra(Constants.SEARCH_KEY);

            if (intent.hasExtra(Constants.HEADER_TEXT_INTENT_EXTRA)) {
                mHeaderText = intent.getStringExtra(Constants.HEADER_TEXT_INTENT_EXTRA);
                headerText_tv.setText("Back to Search");

                mShowApplicationStatus = mHeaderText.equals("Application Status");
            }
            mJobResultsFragment = JobResultsFragment.newInstance(mJobs, mShowApplicationStatus);

            mapsFragment = SupportMapFragment.newInstance();

            // displayLayout_ll.setVisibility(View.VISIBLE);
            onViewListClick(viewList_tv);
        }


    }

    @Override
    public void onLocationChanged(Location location) {
    }

    @Override
    public void onProviderDisabled(String provider) {
        Log.d("Latitude", "disable");
    }

    @Override
    public void onProviderEnabled(String provider) {
        Log.d("Latitude", "enable");
    }

    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {
        Log.d("Latitude", "status");
    }

    @OnClick(R.id.list_view_strip)
    void onViewListClick(TextView view) {
        //hideJobCard();
        scrollview.setVisibility(View.GONE);

        view.setBackgroundColor(getResources().getColor(R.color.purple2));
        view.setTextColor(getResources().getColor(R.color.white));

        viewMap_tv.setBackgroundColor(ColorUtils.setAlphaComponent(getResources().getColor(R.color.pageTitleColor), 85));
        viewMap_tv.setTextColor(getResources().getColor(R.color.pageTitleColor));

        displayLayout_ll.setVisibility(View.GONE); //hide it again when the list view is clicked
        mFragmentManager.beginTransaction().replace(R.id.results_container, mJobResultsFragment).commit();
    }

    @OnClick(R.id.map_view_strip)
    void onViewMapClick(TextView view) {
        view.setBackgroundColor(getResources().getColor(R.color.pageTitleColor));
        view.setTextColor(getResources().getColor(R.color.white));

        viewList_tv.setBackgroundColor(ColorUtils.setAlphaComponent(getResources().getColor(R.color.purple2), 85));
        viewList_tv.setTextColor(getResources().getColor(R.color.purple2));

        mapsFragment.getMapAsync(this);
        mFragmentManager.beginTransaction().replace(R.id.results_container, mapsFragment).commit();

    }


    @OnClick(R.id.job_header_right_item)
    void onAdvancedSearchClick() {
        Intent intent = new Intent(this, AdvancedJobSearchActivity.class);
        startActivity(intent);
    }

    private Location getLastKnownLocation() {
        locationManager = (LocationManager)getApplicationContext().getSystemService(LOCATION_SERVICE);
        List<String> providers = locationManager.getProviders(true);
        Location bestLocation = null;
        for (String provider : providers) {
            Location l = locationManager.getLastKnownLocation(provider);
            if (l == null) {
                continue;
            }
            if (bestLocation == null || l.getAccuracy() < bestLocation.getAccuracy()) {
                // Found best last known location: %s", l);
                bestLocation = l;
            }
        }
        return bestLocation;
    }

    @Override
    public void onMapReady(final GoogleMap googleMap) {
        Job job;
        mGoogleMap = googleMap;
        int jobsSize = mJobs.size();
        for (int i = 0; i < jobsSize; i++) {
            job = mJobs.get(i);
            Log.d(LOG_TAG, "onMapReady:lat " + job.getCompanyLat());
            Log.d(LOG_TAG, "onMapReady:long " + job.getCompanyLong());
            MarkerOptions marker = new MarkerOptions()
                    .position(new LatLng(job.getCompanyLat(), job.getCompanyLong()))
                    .snippet(job.getCompanyLat() + "/" + job.getCompanyLong())
                    .title(mJobs.get(i).getCompanyName())
                    .icon(BitmapDescriptorFactory.fromResource(R.drawable.location_copy_2));

            googleMap.addMarker(marker); //show company name? or something else?
        }


        // TODO: 03-07-2016 set bounds with the nearest and farthest job locations
        LatLng location = null;
        if (locationSearchKey == null) {
            if (checkPermission(Manifest.permission.ACCESS_FINE_LOCATION, getApplicationContext(), JobResultsActivity.this)) {
                Location position = getLastKnownLocation();
                if (position != null) {
                    location = new LatLng(position.getLatitude(), position.getLongitude());
                }
            } else {
                requestPermission(Manifest.permission.ACCESS_FINE_LOCATION, PERMISSION_REQUEST_CODE_LOCATION, getApplicationContext(), JobResultsActivity.this);
            }
        } else {
            Geocoder coder = new Geocoder(this);
            try {
                List<Address> addresses = coder.getFromLocationName(locationSearchKey, 1);
                if (addresses != null && addresses.size() > 0) {
                    Address position = addresses.get(0);
                    location = new LatLng(position.getLatitude(), position.getLongitude());
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        if (location == null) {
            location = new LatLng(mJobs.get(0).getCompanyLat(), mJobs.get(0).getCompanyLong());
        }
        CameraUpdate cameraUpdate = CameraUpdateFactory.newLatLngZoom(location, 13.0f);
        googleMap.moveCamera(cameraUpdate);

        googleMap.setOnMarkerClickListener(new GoogleMap.OnMarkerClickListener() {
            @Override
            public boolean onMarkerClick(Marker marker) {
                String[] latLng = marker.getSnippet().split("/");
                Job job = new Job();
                job.setCompanyLat(Double.parseDouble(latLng[0]));
                job.setCompanyLong(Double.parseDouble(latLng[1]));
                setupJobDetailCard(job);
                mClickedLatitude = marker.getPosition().latitude;
                mClickedLongitude = marker.getPosition().longitude;
                displayLayout_ll.setVisibility(View.VISIBLE);
                scrollview.setVisibility(View.VISIBLE);
                if (previousMarker != null) {
                    previousMarker.setIcon(BitmapDescriptorFactory.fromResource(R.drawable.location_copy_2));
                }
                marker.setIcon(BitmapDescriptorFactory.fromResource(R.drawable.location_copy_6));
                previousMarker = marker; //Now the clicked marker becomes previousMarker

                return true;
            }

        });

    }

    @OnClick(R.id.hide_job_card)
    void onJobDetailHideClick() {
        hideJobCard();
    }

    private void hideJobCard() {
        TranslateAnimation translateAnimation = new TranslateAnimation(0, 0, 0, displayLayout_ll.getHeight());
        translateAnimation.setDuration(1500);
        scrollview.startAnimation(translateAnimation);

        translateAnimation.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {

            }

            @Override
            public void onAnimationEnd(Animation animation) {
                scrollview.setVisibility(View.GONE);
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
    }

    private void setupJobDetailCard(Job clickedJob) {

        displayLayout_ll.removeAllViews();
        //making list of matched lat&lng jobs.
        ArrayList<Job> samePositionList = new ArrayList<>();
        for (Job job : mJobs) {
            if (job.equals(clickedJob)) {
                Log.e("---", "setupJobDetailCard --" + job.getJobId());
                samePositionList.add(job);
            }
        }

        for (int i = 0; i < samePositionList.size(); i++) {
            LayoutInflater inflater = LayoutInflater.from(JobResultsActivity.this);
            View v = inflater.inflate(R.layout.job_detail_card, null);

            final Job job = samePositionList.get(i);
            Log.d(LOG_TAG, "setupJobDetailCard: " + job.getJobId());
            v.setTag(job);
            TextView jobType_tv = ButterKnife.findById(v, R.id.job_type);
            TextView compensation_tv = ButterKnife.findById(v, R.id.compensation);
            final TextView applicationStatus_tv = ButterKnife.findById(v, R.id.application_status);
            final ImageButton saveJob_btn = ButterKnife.findById(v, R.id.save_job);
            saveJob_btn.setTag(job);
            final Button viewJob_btn = ButterKnife.findById(v, R.id.view_job);
            viewJob_btn.setTag(job);
            ImageView iv_cuurentLocation = ButterKnife.findById(v, R.id.iv_current_location_icon);
            iv_cuurentLocation.setVisibility(View.VISIBLE);

            //views in job detail card
            TextView position_tv = ButterKnife.findById(v, R.id.position);
            TextView timeElpase_tv = ButterKnife.findById(v, R.id.time_elapsed);
            TextView location_tv = ButterKnife.findById(v, R.id.address1);
            TextView cityState_tv = ButterKnife.findById(v, R.id.city_state);


            jobType_tv.setText(job.getJobType());
            position_tv.setText(job.getPosition());


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


            compensation_tv.setText(job.getCompensations() + "- " + formattedString);
            // TODO: 31-05-2016 find a way to avoid this warning
            location_tv.setText(job.getAddress1() + ",");
            cityState_tv.setText(job.getCity() + "," + job.getState());


            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US);
            format.setTimeZone(TimeZone.getTimeZone("UTC"));
            try {
                long postedTime = format.parse(job.getUpdatedAt()).getTime();
                String timeAgo = Utility.dateFormat(postedTime) + " ago";
                timeElpase_tv.setText(mContext.getString(R.string.posted, timeAgo));
            } catch (Exception e) {
                e.printStackTrace();
            }

           /* try {
                CharSequence elapsedTime = DateUtils.getRelativeTimeSpanString(format.parse(job.getUpdatedAt()).getTime(), format.parse(format.format(new Date())).getTime(), DateUtils.MINUTE_IN_MILLIS);
                timeElpase_tv.setText(mContext.getString(R.string.posted, elapsedTime));
            } catch (ParseException e) {
                Log.e(LOG_TAG, "setupJobDetailCard: " + e.getMessage());
                timeElpase_tv.setText(mContext.getString(R.string.job_elapsed, job.getNumOfDaysOld()));

            }*/

            applicationStatus_tv.setText(mContext.getString(R.string.application_status, job.getStatus()));

            if (mShowApplicationStatus) {
                applicationStatus_tv.setVisibility(View.VISIBLE);
            } else {
                applicationStatus_tv.setVisibility(View.GONE);
            }

            if (job.isSaved()) {
//                saveJob_btn.setVisibility(View.GONE);
                saveJob_btn.setImageResource(R.drawable.love_icon);
            } else {
//                saveJob_btn.setVisibility(View.VISIBLE);
                saveJob_btn.setImageResource(R.drawable.love_empty_icon);
            }

            if (Utility.isConnectingToInternet(JobResultsActivity.this)) {
                saveJob_btn.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        JsonObject jsonObject = new JsonObject();
                        jsonObject.addProperty(Constants.AUTH_TOKEN_KEY, PreferencesData.getString(mContext, Constants.AUTHORIZATION_KEY, ""));
                        jsonObject.addProperty(Constants.JOB_ID_KEY, ((Job) v.getTag()).getJobId());
                        RetroHelper.getBaseClassService(mContext, "", "").saveJob(jsonObject, new Callback<JsonObject>() {
                                    @Override
                                    public void success(JsonObject jsonObject, Response response) {
                                        Toast.makeText(mContext, "Job saved successfully", Toast.LENGTH_SHORT).show();
//                                        saveJob_btn.setVisibility(View.GONE);
                                        saveJob_btn.setImageResource(R.drawable.love_icon);
                                        Log.d(LOG_TAG, "success: " + job.getJobId());
                                    }

                                    @Override
                                    public void failure(RetrofitError error) {
                                        if (error != null && error.getResponse() != null && error.getResponse().getStatus() == 501) {
                                            Utility.showAppUpdateAlert((Activity) mContext);
                                        } else {
                                            Toast.makeText(mContext, "Unable to save job. Please try later", Toast.LENGTH_SHORT).show();
                                        }
                                    }

                                }

                        );
                    }
                });
            } else {
                DialogUtility.showDialogWithOneButton(JobResultsActivity.this, Constants.APP_NAME, getString(R.string.check_internet));
            }

            viewJob_btn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Log.d(LOG_TAG, "onJobViewClick: ");
                    if (Utility.isConnectingToInternet(JobResultsActivity.this)) {
                        scrollview.setVisibility(View.GONE);
                        Intent intent = new Intent(mContext, JobDetailActivity.class);
                        intent.putExtra(Constants.JOB_ID_INTENT_EXTRA, ((Job) v.getTag()).getJobId());
                        mContext.startActivity(intent);
                    } else {
                        DialogUtility.showDialogWithOneButton(JobResultsActivity.this, Constants.APP_NAME, getString(R.string.check_internet));
                    }
                }
            });

            iv_cuurentLocation.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (checkPermission(Manifest.permission.ACCESS_FINE_LOCATION, getApplicationContext(), JobResultsActivity.this)) {
                        Location location = getLastKnownLocation();
                        fetchRoutePath(location);
                    } else {
                        requestPermission(Manifest.permission.ACCESS_FINE_LOCATION, PERMISSION_REQUEST_CODE_LOCATION, getApplicationContext(), JobResultsActivity.this);
                    }
                }
            });


            v.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Job tempJob = (Job) v.getTag();
                    Intent intent = new Intent(mContext, WorkdayPrefsDialogActivity.class);
                    intent.putParcelableArrayListExtra(Constants.JOB_INTENT_EXTRA, new ArrayList<WeekdayInfo>(Arrays.asList(tempJob.getShifts())));
                    mContext.startActivity(intent);
                }
            });


            displayLayout_ll.addView(v);
            View lineView = new View(JobResultsActivity.this);
            lineView.setBackgroundColor(getResources().getColor(R.color.black));
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, 1);
            lineView.setLayoutParams(params);
            displayLayout_ll.addView(lineView);

        }

        scrollview.setVisibility(View.VISIBLE);

        TranslateAnimation translateAnimation = new TranslateAnimation(0, 0, displayLayout_ll.getHeight(), 0);
        translateAnimation.setDuration(1500);
        translateAnimation.setFillEnabled(true);
        translateAnimation.setAnimationListener(new Animation.AnimationListener()

                                                {
                                                    @Override
                                                    public void onAnimationStart(Animation animation) {

                                                    }

                                                    @Override
                                                    public void onAnimationEnd(Animation animation) {
                                                    }

                                                    @Override
                                                    public void onAnimationRepeat(Animation animation) {

                                                    }
                                                }

        );
        scrollview.startAnimation(translateAnimation);

        //displayLayout_ll.setVisibility(View.VISIBLE);
    }

    @OnClick(R.id.job_header_left_item)
    void onBackArrowClick() {
        onBackPressed();
    }


    public void requestPermission(String strPermission, int perCode, Context _c, Activity _a) {

        if (ActivityCompat.shouldShowRequestPermissionRationale(_a, strPermission)) {
            Toast.makeText(JobResultsActivity.this, "GPS permission allows us to access location data. Please allow in App Settings for additional functionality.", Toast.LENGTH_LONG).show();
        } else {

            ActivityCompat.requestPermissions(_a, new String[]{strPermission}, perCode);
        }
    }

    public boolean checkPermission(String strPermission, Context _c, Activity _a) {
        int result = ContextCompat.checkSelfPermission(_c, strPermission);
        if (result == PackageManager.PERMISSION_GRANTED) {

            return true;

        } else {

            return false;

        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {
        switch (requestCode) {

            case PERMISSION_REQUEST_CODE_LOCATION:
                if (checkPermission(Manifest.permission.ACCESS_FINE_LOCATION, getApplicationContext(), JobResultsActivity.this)) {
                    Location location = getLastKnownLocation();
                    fetchRoutePath(location);
                } else {
                    Toast.makeText(getApplicationContext(), "Permission Denied, You cannot access location data.", Toast.LENGTH_LONG).show();
                }
                break;

        }
    }

    private void fetchRoutePath(Location location) {

        if (location != null) {
            LatLng origin = new LatLng(location.getLatitude(), location.getLongitude());
            if (currentMarker != null) {
                currentMarker.remove();
            }
            currentMarker = mGoogleMap.addMarker(new MarkerOptions().icon(BitmapDescriptorFactory.fromResource(R.drawable.map)).position(origin));
            LatLng dest = new LatLng(mClickedLatitude, mClickedLongitude);

            String url = getDirectionsUrl(origin, dest);

            DownloadTask downloadTask = new DownloadTask();
            // Start downloading json data from Google Directions API
            downloadTask.execute(url);
        } else {
            Toast.makeText(JobResultsActivity.this, "Unable to fetch location.Please enable GPS and try again!", Toast.LENGTH_LONG).show();
        }


    }

    private String getDirectionsUrl(LatLng origin, LatLng dest) {

        // Origin of route
        String str_origin = "origin=" + origin.latitude + "," + origin.longitude;

        // Destination of route
        String str_dest = "destination=" + dest.latitude + "," + dest.longitude;

        // Sensor enabled
        String sensor = "sensor=false";

        // Building the parameters to the web service
        String parameters = str_origin + "&" + str_dest + "&" + sensor;

        // Output format
        String output = "json";

        // Building the url to the web service
        String url = "https://maps.googleapis.com/maps/api/directions/" + output + "?" + parameters;

        return url;
    }

    /**
     * A method to download json data from url
     */
    private String downloadUrl(String strUrl) throws IOException {
        String data = "";
        InputStream iStream = null;
        HttpURLConnection urlConnection = null;
        try {
            URL url = new URL(strUrl);

            // Creating an http connection to communicate with url
            urlConnection = (HttpURLConnection) url.openConnection();

            // Connecting to url
            urlConnection.connect();

            // Reading data from url
            iStream = urlConnection.getInputStream();

            BufferedReader br = new BufferedReader(new InputStreamReader(iStream));

            StringBuffer sb = new StringBuffer();

            String line = "";
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }

            data = sb.toString();

            br.close();

        } catch (Exception e) {
            Log.d("Exception", "downloading url :" + e.toString());
        } finally {
            iStream.close();
            urlConnection.disconnect();
        }
        return data;
    }

    @Override
    protected void attachBaseContext(Context newBase) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase));
    }

    // Fetches data from url passed
    private class DownloadTask extends AsyncTask<String, Void, String> {

        // Downloading data in non-ui thread
        @Override
        protected String doInBackground(String... url) {

            // For storing data from web service
            String data = "";

            try {
                // Fetching the data from web service
                data = downloadUrl(url[0]);
            } catch (Exception e) {
                Log.d("Background Task", e.toString());
            }
            return data;
        }

        // Executes in UI thread, after the execution of
        // doInBackground()
        @Override
        protected void onPostExecute(String result) {
            super.onPostExecute(result);

            ParserTask parserTask = new ParserTask();

            // Invokes the thread for parsing the JSON data
            parserTask.execute(result);
        }
    }

    /**
     * A class to parse the Google Places in JSON format
     */
    private class ParserTask extends AsyncTask<String, Integer, List<List<HashMap<String, String>>>> {

        // Parsing the data in non-ui thread
        @Override
        protected List<List<HashMap<String, String>>> doInBackground(String... jsonData) {

            JSONObject jObject;
            List<List<HashMap<String, String>>> routes = null;

            try {
                jObject = new JSONObject(jsonData[0]);
                DirectionsJSONParser parser = new DirectionsJSONParser();

                // Starts parsing data
                routes = parser.parse(jObject);
            } catch (Exception e) {
                e.printStackTrace();
            }
            return routes;
        }

        // Executes in UI thread, after the parsing process
        @Override
        protected void onPostExecute(List<List<HashMap<String, String>>> result) {
            ArrayList<LatLng> points = null;

            MarkerOptions markerOptions = new MarkerOptions();
            PolylineOptions lineOptions = null;
            if (mPolyLine != null) {
                mPolyLine.remove();
            }

            // Traversing through all the routes
            for (int i = 0; i < result.size(); i++) {
                points = new ArrayList<LatLng>();
                lineOptions = new PolylineOptions();

                // Fetching i-th route
                List<HashMap<String, String>> path = result.get(i);

                // Fetching all the points in i-th route
                for (int j = 0; j < path.size(); j++) {
                    HashMap<String, String> point = path.get(j);

                    double lat = Double.parseDouble(point.get("lat"));
                    double lng = Double.parseDouble(point.get("lng"));
                    LatLng position = new LatLng(lat, lng);

                    points.add(position);
                }

                // Adding all the points in the route to LineOptions
                lineOptions.addAll(points);
                lineOptions.width(5);
                lineOptions.color(Color.BLACK);
            }

            // Drawing polyline in the Google Map for the i-th route
            if (mGoogleMap != null && lineOptions != null) {
                mPolyLine = mGoogleMap.addPolyline(lineOptions);
            }
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        Utility.checkTermsAndConditionsStatus(this);
    }
}
