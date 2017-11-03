#!/usr/bin/python3

# written by andrewt@cse.unsw.edu.au October 2017
# as a starting point for COMP[29]041 assignment 2
# https://cgi.cse.unsw.edu.au/~cs2041/assignments/UNSWtalk/

from flask import Flask, render_template, session, redirect, request, url_for
from flask_login import current_user, login_required, logout_user, LoginManager
from helper_fns import *
from server import app

########################
#      LOGIN PAGE      #
########################
@app.route('/', methods=['GET','POST'])
def login():
	error = None
	notLogged = True

	if request.method == "POST":
		zid = request.form["zid"]
		pw = request.form["pw"]
		if "create_acct" in request.form:
			if check_zid_available(zid):
				save_pw(zid, pw)
				return redirect(url_for('dashboard'))
			else:
				error = "User ID already exists"
		if "login" in request.form:
			if check_zid(zid):
				if check_pw(zid,pw):
					return redirect(url_for('dashboard'))
				else:
					error = "Invalid password!"
			else:
				error = "Invalid User ID!"
		
	return render_template('login.html', error=error, notLogged=notLogged)

########################
#    DASHBOARD PAGE    #
########################
@app.route('/dashboard', methods=['GET', 'POST'])
@login_required
def dashboard():

	zid = current_user.user_id

	# to do: student can create a new post

	friends_list = get_friends(zid)

	# fix this so that it shows mentions also
	# commenter needs to be a link to their profile page
	posts = get_own_posts(zid)
	comments = get_comments(posts)

	friends_posts = get_friends_posts(friends_list)
	friends_comments = get_friends_comments(friends_posts)

	new_friends = suggested_friends(zid)

	if request.method == "POST":
		if "home" in request.form:
			return redirect(url_for('dashboard'))
		elif "profile" in request.form:
			return redirect(url_for('profile'))
		elif "notifications" in request.form:
			return redirect(url_for('notifications'))
		elif "search" in request.form:
			search_string = request.form["query"]
			return redirect(url_for('search', search_string=search_string))
		elif "log_out" in request.form:
			logout_user()
			return redirect(url_for('login'))
		elif "new_post" in request.form:
			msg = request.form["newstork"]
			add_post(zid, msg)
			return redirect(url_for('dashboard'))
		else:
			for x in range (0, len(friends_list)):
				friend_name = friends_list[x][0]
				if friend_name in request.form:
					return redirect(url_for('stork', zid=friend_name))
			for x in range (0, len(new_friends)):
				suggested_name = new_friends[x]
				if suggested_name in request.form:
					return redirect(url_for('stork', zid=suggested_name))
			own_name = get_name(zid)
			if own_name in request.form:
				return redirect(url_for('profile'))

	return render_template('dashboard.html', friends=friends_list, sugg_friends=new_friends, posts=posts, comments=comments, friends_comments=friends_comments, friends_posts=friends_posts)

########################
#     PROFILE PAGE     #
########################
@app.route('/profile', methods=["GET", "POST"])
@login_required
def profile():

	zid = current_user.user_id

	details = get_student_details(zid)

	if request.method == "POST":
		if "home" in request.form:
			return redirect(url_for('dashboard'))
		if "profile" in request.form:
			return redirect(url_for('profile'))
		elif "notifications" in request.form:
			return redirect(url_for('notifications'))
		if "log_out" in request.form:
			logout_user()
			return redirect(url_for('login'))
		if "suspend" in request.form:
			# check if this is what they want
			suspend_acct(zid)
			logout_user()
			return redirect(url_for('login'))
		if "search" in request.form:
			search_string = request.form["query"]
			return redirect(url_for('search', search_string=search_string))
		if "reactivate" in request.form:
			reactivate_acct(zid)
		if "delete" in request.form:
			# check if this is what they want
			delete_acct(zid)
			logout_user()
			return redirect(url_for('login'))
		if "edit_details" in request.form:
			return redirect(url_for('edit_profile'))

	return render_template('profile.html', zid=zid, details=details)

########################
#     EDIT PROFILE     #
########################
@app.route('/edit_profile', methods=["GET", "POST"])
@login_required
def edit_profile():

	zid = current_user.user_id
	details = get_all_details(zid)

	if request.method == "POST":
		if "save" in request.form:
			name = request.form["name"]
			email = request.form["email"]
			pw = request.form["pw"]
			bday = request.form["bday"]
			suburb = request.form["suburb"]
			longitude = request.form["longitude"]
			latitude = request.form["latitude"]
			program = request.form["program"]
			description = request.form["description"]
			save_details(zid, name, email, pw, bday, suburb, longitude, latitude, program, description)
			return redirect(url_for('profile'))
		elif "notifications" in request.form:
			return redirect(url_for('notifications'))
		if "home" in request.form:
			return redirect(url_for('dashboard'))
		if "search" in request.form:
			search_string = request.form["query"]
			return redirect(url_for('search', search_string=search_string))
		if "profile" in request.form:
			return redirect(url_for('profile'))
		if "log_out" in request.form:
			logout_user()
			return redirect(url_for('login'))
		
	return render_template('edit_profile.html', zid=zid, details=details)



########################
#    SEARCH RESULTS    #
########################
@app.route('/search/<search_string>', methods=["GET", "POST"])
def search(search_string):

	people_results = query_search_people(search_string)
	post_results = query_search_posts(search_string)

	if request.method == "POST":
		if "home" in request.form:
			return redirect(url_for('dashboard'))
		if "profile" in request.form:
			return redirect(url_for('profile'))
		elif "notifications" in request.form:
			return redirect(url_for('notifications'))
		if "search" in request.form:
			search_string = request.form["query"]
			return redirect(url_for('search', search_string=search_string))
		if "log_out" in request.form:
			logout_user()
			return redirect(url_for('login'))
	
	return render_template('search.html', people=people_results, posts=post_results)

########################
#    OTHER PROFILES    #
########################
@app.route('/stork/<zid>', methods=["GET", "POST"])
@login_required
def stork(zid):

	my_zid = current_user.user_id
	zid = get_zid(zid)
	details = get_student_details(zid)
	
	current_friends = check_if_friends(my_zid, zid)

	requested_friend = check_if_requested(my_zid, zid)

	if request.method == "POST":
		if "home" in request.form:
			return redirect(url_for('dashboard'))
		if "profile" in request.form:
			return redirect(url_for('profile'))
		elif "notifications" in request.form:
			return redirect(url_for('notifications'))
		if "log_out" in request.form:
			logout_user()
			return redirect(url_for('login'))
		if "request_friend" in request.form:
			request_friend(my_zid, zid)
			return redirect(url_for('stork', zid=get_name(zid)))
		elif "cancel_request" in request.form:
			cancel_request(my_zid, zid)
			return redirect(url_for('stork', zid=get_name(zid)))
		if "delete" in request.form:
			delete_friend(my_zid, zid)
			return redirect(url_for('stork', zid=get_name(zid)))

	return render_template('other_profile.html', zid=zid, details=details, current_friends=current_friends, requested_friend=requested_friend)

########################
#    NOTIFICATIONS     #
########################
@app.route('/notifications', methods=["GET", "POST"])
@login_required
def notifications():
	my_zid = current_user.user_id
	friends_requests = get_friend_requests(my_zid)

	if request.method == "POST":
		if "home" in request.form:
			return redirect(url_for('dashboard'))
		if "profile" in request.form:
			return redirect(url_for('profile'))
		elif "notifications" in request.form:
			return redirect(url_for('notifications'))
		if "log_out" in request.form:
			logout_user()
			return redirect(url_for('login'))
		if "request_friend" in request.form:
			request_friend(my_zid, zid)
			return redirect(url_for('stork', zid=get_name(zid)))
		if "delete" in request.form:
			delete_friend(my_zid, zid)
			return redirect(url_for('stork', zid=get_name(zid)))
		else:
			for friend_request in friends_requests:
				accepted_id = str(friend_request[0])
				if accepted_id in request.form:
					accept_friend_request(my_zid, accepted_id)
					return redirect(url_for('notifications'))

	return render_template('notifications.html', friends_requests=friends_requests)

