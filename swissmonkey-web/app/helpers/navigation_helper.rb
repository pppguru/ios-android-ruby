# Provides configuration to the navigation
module NavigationHelper
  def left_navigation_menu_items
    proc do |primary|
      primary.dom_class = 'nav side-nav navbar-nav'

      primary.item :jobs, 'My Job Postings', job_postings_path, class: 'my-job-postings', highlights_on: :subpath
      primary.item :applicants, 'Applicants', applicants_path, class: 'applicants-li', highlights_on: :subpath
      primary.item :practice_profile, 'Practice Profile', companies_path, class: 'my-profile-li',
                                                                          highlights_on: :subpath
      primary.item :subscription, 'Subscription', subscription_path, class: 'subscription', highlights_on: :subpath
      primary.item :logout, 'Logout', destroy_user_session_path, method: :delete, class: 'logout-li',
                                                                 highlights_on: :subpath
    end
  end

  def super_admin_menu_items
    proc do |primary|
      # Add an item which has a sub navigation (same params, but with block)
      primary.item(:super_admin, 'Super Admin', super_admin_path,
                   if: proc { admin_signed_in? }, highlights_on: :subpath) do |sub_nav|
        add_super_admin_sub_nav_items sub_nav
        sub_nav.dom_class = 'nav navbar-top-links navbar-nav'
      end

      primary.dom_class = 'nav'
    end
  end

  private

  def add_super_admin_sub_nav_items(sub_nav)
    sub_nav.item :dashboard, 'Dashboard', super_admin_path, highlights_on: :subpath
    sub_nav.item :companies, "Companies (#{Company.count})", super_admin_companies_path, highlights_on: :subpath
    sub_nav.item :job_seekers, "Job Seekers (#{User.job_seekers.count})", super_admin_users_path(role: :job_seeker),
                 highlights_on: :subpath
    sub_nav.item :users, 'Users', super_admin_users_path, highlights_on: :subpath
    # sub_nav.item :android_users, "Android Users (#{AndroidUser.count})", super_admin_android_users_path,
    #              highlights_on: :subpath
    # sub_nav.item :reports, 'Reports', super_admin_reports_path, highlights_on: :subpath
    # sub_nav.item :coupons, 'Coupons', super_admin_coupons_path, highlights_on: :subpath
    sub_nav.item :sign_out, 'Sign Out', destroy_admin_session_path, method: :delete, highlights_on: :subpath
  end
end
