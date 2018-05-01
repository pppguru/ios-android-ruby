package com.rapidbizapps.swissmonkey.jobs;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.ImageView;

import com.nostra13.universalimageloader.core.ImageLoader;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.utility.Utility;


/**
 * Created by mlanka on 09-06-2016.
 */
public class ImageAdapter extends BaseAdapter {
    String[] mPracticePhotos;
    Context mContext;

    public ImageAdapter(Context context, String[] practicePhotos) {
        mPracticePhotos = practicePhotos;
        mContext = context;
    }

    @Override
    public int getCount() {
        return mPracticePhotos.length;
    }

    @Override
    public Object getItem(int position) {
        return mPracticePhotos[position];
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ImageView imageView;
        if (convertView == null) {
            // if it's not recycled, initialize some attributes
            imageView = new ImageView(mContext);
        } else {
            imageView = (ImageView) convertView;
        }

        imageView.setLayoutParams(new AbsListView.LayoutParams(mContext.getResources().getDimensionPixelSize(R.dimen.margin_90),mContext.getResources().getDimensionPixelSize(R.dimen.margin_90)));

        imageView.setAdjustViewBounds(true);

        ImageLoader.getInstance().displayImage(mPracticePhotos[position],imageView,Utility.getCircularDisplayOptions(mContext.getResources().getDimensionPixelSize(R.dimen.margin_xlarge)));

        return imageView;

    }
}
